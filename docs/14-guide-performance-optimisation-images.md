# Guide Performance & Optimisation Images

## Résumé Exécutif

Ce document fournit des directives techniques pour optimiser les performances de l'application PhotoListing, avec un accent particulier sur le traitement et l'affichage des images. Il définit les bonnes pratiques pour garantir une expérience utilisateur fluide même avec de grands volumes de photos.

## 1. Principes Généraux d'Optimisation

### 1.1 Métriques de Performance Clés

| Métrique | Objectif | Impact Utilisateur |
|----------|----------|-------------------|
| Temps de démarrage à froid | < 2 secondes | Première impression |
| Temps de réponse UI | < 16ms (60 FPS) | Fluidité perçue |
| Chargement galerie (100 photos) | < 1 seconde | Expérience de navigation |
| Mémoire utilisée | < 150 MB | Stabilité, multitâche |
| Consommation de batterie | < 5%/heure | Autonomie |
| Taille de l'application | < 30 MB | Facilité d'installation |

### 1.2 Architecture Performante

- Utilisation du pattern MVVM avec coroutines/flows (Android) et Combine (iOS)
- Isolation du travail intensif dans des threads dédiés
- Cache à plusieurs niveaux (mémoire, disque)
- Lazy loading pour tous les composants non critiques
- Pré-calcul et mémorisation des opérations coûteuses

## 2. Optimisation des Images

### 2.1 Formats et Compression

| Format | Cas d'usage | Avantages | Inconvénients |
|--------|-------------|-----------|---------------|
| JPEG | Photos standards | Compacité, universalité | Perte de qualité |
| WebP | Alternative moderne | Meilleure compression, support alpha | Compatible Android 4.0+, iOS 14+ |
| HEIC | Photos haute qualité | Meilleure compression que JPEG | Support limité (iOS 11+, Android 10+) |
| PNG | UI, transparence | Sans perte, alpha | Taille importante |
| AVIF | Futur (à surveiller) | Compression supérieure | Support très limité |

#### Recommandations de compression:
- Photos d'affichage: JPEG qualité 85%, ou WebP qualité 80%
- Vignettes: JPEG qualité 70%, ou WebP qualité 65%
- Export haute qualité: JPEG qualité 95% ou HEIC

### 2.2 Gestion des Résolutions

| Usage | Résolution maximale | Poids cible |
|-------|---------------------|------------|
| Vignette grille | 200x200px | < 10KB |
| Aperçu liste | 400x400px | < 30KB |
| Affichage plein écran | 1080p | < 200KB |
| Vue détaillée | 4K max | < 1MB |
| Stockage source | Original | Compressé sans perte visible |

#### Stratégie multi-résolutions:
- Génération automatique des variantes lors de l'import
- Affichage progressif (basse résolution → haute résolution)
- Adaptation dynamique selon la connexion réseau

## 3. Optimisation du Chargement

### 3.1 Stratégie de Lazy Loading

```kotlin
// Exemple Android avec Glide
Glide.with(context)
    .load(photoUrl)
    .placeholder(R.drawable.placeholder)
    .thumbnail(0.1f)
    .transition(DrawableTransitionOptions.withCrossFade())
    .diskCacheStrategy(DiskCacheStrategy.ALL)
    .into(imageView)
```

```swift
// Exemple iOS avec Kingfisher
let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
imageView.kf.indicatorType = .activity
imageView.kf.setImage(
    with: URL(string: photoUrl),
    placeholder: UIImage(named: "placeholder"),
    options: [
        .processor(processor),
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(0.2)),
        .cacheOriginalImage
    ])
```

### 3.2 Pagination et Recyclage

- Utilisation de RecyclerView/UICollectionView avec ViewHolder pattern
- Pagination avec taille de page adaptative (20-50 items)
- Préchargement des 2 pages suivantes en arrière-plan
- Libération des ressources hors-écran (± 10 positions)
- Optimisation des rebind pour éviter les recalculs

### 3.3 Préchargement Intelligent

- Analyse des habitudes de navigation utilisateur
- Préchargement directionnel (vertical/horizontal)
- Priorisation des contenus les plus consultés
- Adaptation selon la qualité de connexion

## 4. Caching et Stockage

### 4.1 Architecture de Cache Multi-niveaux

![Architecture Cache](https://via.placeholder.com/800x400?text=Schema+Architecture+Cache)

1. **Cache Mémoire (L1)**
   - LRU Cache limité à 20% de la mémoire disponible
   - Stockage des vignettes actives et des métadonnées
   - Durée de vie courte (session)

2. **Cache Disque (L2)**
   - Stockage persistant des images fréquemment consultées
   - Indexation par clé de hachage (MD5)
   - Limite de taille configurable (100MB-1GB)
   - Politique d'expiration: LRU avec TTL de 7 jours

3. **Stockage Local (L3)**
   - Base de données pour les métadonnées (Room/CoreData)
   - Système de fichiers pour les originaux
   - Compression adaptative selon l'espace disponible

### 4.2 Politiques de Gestion

```kotlin
// Configuration Android du cache disque
val cacheSize = calculateDiskCacheSize(context, 0.02f, 50 * 1024 * 1024, 250 * 1024 * 1024)
val diskCache = DiskLruCache.create(
    FileSystem.SYSTEM,
    File(context.cacheDir, "image_cache"),
    1, // version
    2, // valueCount (original + thumbnail)
    cacheSize
)
```

```swift
// Configuration iOS du cache disque
let cache = ImageCache.default
cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024 // 100 MB
cache.diskStorage.config.sizeLimit = 500 * 1024 * 1024 // 500 MB
cache.diskStorage.config.expiration = .days(7)
```

### 4.3 Nettoyage Automatique

- Surveillance de l'espace disque disponible
- Purge proactive quand stockage < 10%
- Compression supplémentaire des images peu consultées
- Export automatique vers le cloud si nécessaire
- Journal des opérations de maintenance pour debug

## 5. Optimisation du Rendu

### 5.1 Downsampling et Réduction de Résolution

```kotlin
// Android: Downsampling efficace avec BitmapFactory
private fun decodeSampledBitmapFromFile(path: String, reqWidth: Int, reqHeight: Int): Bitmap {
    return BitmapFactory.Options().run {
        inJustDecodeBounds = true
        BitmapFactory.decodeFile(path, this)
        inSampleSize = calculateInSampleSize(this, reqWidth, reqHeight)
        inJustDecodeBounds = false
        BitmapFactory.decodeFile(path, this)
    }
}

private fun calculateInSampleSize(options: BitmapFactory.Options, reqWidth: Int, reqHeight: Int): Int {
    val height = options.outHeight
    val width = options.outWidth
    var inSampleSize = 1
    if (height > reqHeight || width > reqWidth) {
        val halfHeight = height / 2
        val halfWidth = width / 2
        while (halfHeight / inSampleSize >= reqHeight && halfWidth / inSampleSize >= reqWidth) {
            inSampleSize *= 2
        }
    }
    return inSampleSize
}
```

```swift
// iOS: Downsampling avec UIGraphicsImageRenderer
func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
    
    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    let downsampleOptions = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
    ] as CFDictionary
    
    let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
    return UIImage(cgImage: downsampledImage)
}
```

### 5.2 Optimisation du UI Thread

- Utilisation de Jetpack Compose/SwiftUI pour minimiser les mesures
- Exécution de tout traitement d'image sur des threads dédiés
- Buffering et pre-rendering pour les transitions complexes
- Mécanisme de throttling pour les événements UI rapides
- Différer le chargement des images pendant les animations

### 5.3 Hardware Acceleration

- Activation du rendu GPU pour l'affichage des listes
- Utilisation des shaders pour les filtres simples
- OpenGL/Metal pour les effets visuels complexes
- Adaptation dynamique selon les capacités du device

## 6. Optimisation Réseau

### 6.1 Stratégies de Téléchargement

- Téléchargement adaptatif selon la qualité de connexion
- Résolution progressive (placeholder → basse rés → haute rés)
- Priorisation des contenus visibles
- Pause/reprise automatique des téléchargements volumineux

### 6.2 Compression et Headers

- Activation de la compression gzip/brotli pour les API
- Utilisation des headers HTTP/2 pour multiplexing
- Cache-Control optimisé pour les assets statiques
- ETags pour validation conditionnelle

### 6.3 Surveillance des Performances Réseau

```kotlin
// Exemple Android: Intercepteur OkHttp pour mesurer les performances
class PerformanceInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        val startTime = System.nanoTime()
        
        val response = chain.proceed(request)
        val duration = TimeUnit.NANOSECONDS.toMillis(System.nanoTime() - startTime)
        
        Log.d("NetworkPerf", "URL: ${request.url}, Duration: $duration ms, Size: ${response.body?.contentLength() ?: 0} bytes")
        
        // Enregistrer dans la télémétrie
        trackNetworkPerformance(request.url.toString(), duration, response.body?.contentLength() ?: 0)
        
        return response
    }
}
```

## 7. Traitement par Lots et Optimisation

### 7.1 Traitement Batch des Images

- Regroupement des opérations similaires
- Utilisation d'un thread pool dédié aux traitements lourds
- Mécanisme de pause/reprise selon l'activité utilisateur
- Indicateurs de progression précis

### 7.2 Optimisation Intelligente des Images

- Détection de contenu pour compression adaptative
- Plus forte compression pour les zones uniformes
- Préservation de la qualité sur les zones de détail
- Identification des visages pour préservation prioritaire

### 7.3 Analyse des Points Chauds

Profiling régulier pour identifier les goulots d'étranglement:

1. **CPU**: Flame graphs des méthodes les plus coûteuses
2. **Mémoire**: Détection des fuites et allocations excessives
3. **I/O**: Optimisation des opérations disque (batching, buffering)
4. **Réseau**: Réduction des requêtes et de la latence
5. **Batterie**: Identification des wake locks et services gourmands

## 8. Surveillance et Alerting

### 8.1 Métriques à Surveiller

- ANR (Application Not Responding) sur Android
- Crashes liés à la mémoire (OOM)
- Temps de chargement des écrans principaux
- Latence des opérations critiques
- Consommation de batterie

### 8.2 Implémentation Firebase Performance

```kotlin
// Android: Trace personnalisée Firebase Performance
private fun loadGallery() {
    val trace = FirebasePerformance.getInstance().newTrace("load_gallery_trace")
    trace.start()
    
    // Mesurer le temps de chargement de la BD
    trace.incrementMetric("db_query_count", 1)
    val dbStartTime = System.currentTimeMillis()
    val photos = photoRepository.loadRecentPhotos(100)
    val dbDuration = System.currentTimeMillis() - dbStartTime
    trace.putMetric("db_query_time_ms", dbDuration)
    
    // Mesurer le temps de traitement des images
    val processingStartTime = System.currentTimeMillis()
    processPhotosForDisplay(photos)
    val processingDuration = System.currentTimeMillis() - processingStartTime
    trace.putMetric("processing_time_ms", processingDuration)
    
    trace.stop()
}
```

```swift
// iOS: Trace personnalisée Firebase Performance
func loadGallery() {
    let trace = Performance.startTrace(name: "load_gallery_trace")
    
    // Mesurer le temps de chargement de la BD
    trace?.incrementMetric(named: "db_query_count", by: 1)
    let dbStartTime = Date()
    let photos = photoRepository.loadRecentPhotos(limit: 100)
    let dbDuration = Date().timeIntervalSince(dbStartTime) * 1000
    trace?.setMetric(named: "db_query_time_ms", to: dbDuration)
    
    // Mesurer le temps de traitement des images
    let processingStartTime = Date()
    processPhotosForDisplay(photos)
    let processingDuration = Date().timeIntervalSince(processingStartTime) * 1000
    trace?.setMetric(named: "processing_time_ms", to: processingDuration)
    
    trace?.stop()
}
```

### 8.3 Dashboards et Alertes

- Dashboard Firebase Performance/Crashlytics
- Alertes sur dégradation de performance > 20%
- Rapport hebdomadaire des tendances
- Intégration avec le système de tickets

## 9. Optimisations Spécifiques par Plateforme

### 9.1 Android

- Utilisation de RenderThread pour le traitement d'image
- Recyclage des bitmaps avec inBitmap
- RecyclerView avec DiffUtil pour mises à jour efficaces
- WorkManager pour les opérations en arrière-plan
- Chargement natif des codecs via NDK si nécessaire

### 9.2 iOS

- Utilisation de Metal pour le traitement d'image
- Optimisation avec Core Image et vImage
- Prefetching avec UICollectionViewDataSourcePrefetching
- Background tasks avec BGProcessingTask
- HEIC comme format de stockage natif lorsque disponible

## 10. Tests de Performance

### 10.1 Benchmarking

- Suite de tests automatisés sur un jeu de données standardisé
- Comparaison avec les versions précédentes (régression)
- Tests sur différentes configurations matérielles
- Analyse de l'impact des nouvelles fonctionnalités

### 10.2 Stress Tests

- Test avec bibliothèque de 10,000+ images
- Comportement sous mémoire limitée
- Performance en multitâche
- Consommation de batterie en utilisation prolongée

### 10.3 Profiling

- Utilisation régulière de Android Profiler/Instruments
- Détection des problèmes de rendu (Systrace/Core Animation)
- Analyse des allocations mémoire
- Identification des opérations bloquantes sur le thread UI

## 11. Ressources et Formation

### 11.1 Guides de Bonnes Pratiques

- [Android Performance Patterns](https://www.youtube.com/playlist?list=PLWz5rJ2EKKc9CBxr3BVjPTPoDPLdPIFCE)
- [Apple Performance Documentation](https://developer.apple.com/documentation/performance)
- [Image Optimization on Web](https://web.dev/fast/#optimize-your-images)

### 11.2 Outils Recommandés

- [Redefined.io](https://redefined.io/) pour l'optimisation automatique
- [TinyPNG](https://tinypng.com/) pour la compression
- [ImageOptim](https://imageoptim.com/) pour macOS
- [ExifTool](https://exiftool.org/) pour le nettoyage des métadonnées

## 12. Feuille de Route d'Optimisation

### 12.1 Court Terme (Sprint 1-2)

- Implémentation du lazy loading et downsampling
- Configuration du cache multi-niveaux
- Optimisation du RecyclerView/UICollectionView

### 12.2 Moyen Terme (Sprint 3-5)

- Traitement batch des images
- Compression adaptative selon le contenu
- Préchargement intelligent

### 12.3 Long Terme (Sprint 6+)

- Migration vers WebP/AVIF
- Optimisation hardware avec Metal/RenderScript
- Implémentation de techniques d'IA pour analyse et optimisation

## Annexes

### A. Exemple de Configuration Glide (Android)

```kotlin
@GlideModule
class PhotoListingGlideModule : AppGlideModule() {
    override fun applyOptions(context: Context, builder: GlideBuilder) {
        // Calcul de la mémoire disponible
        val memoryCacheSize = calculateMemoryCacheSize(context)
        val diskCacheSize = calculateDiskCacheSize(context)
        
        builder.setMemoryCache(LruResourceCache(memoryCacheSize))
        builder.setDiskCache(DiskLruCacheFactory(
            File(context.cacheDir, "image_cache").path,
            diskCacheSize
        ))
        
        // Configuration des décodeurs
        builder.setDefaultRequestOptions(
            RequestOptions()
                .format(DecodeFormat.PREFER_RGB_565)
                .disallowHardwareConfig()
        )
        
        // Logging en debug uniquement
        if (BuildConfig.DEBUG) {
            builder.setLogLevel(Log.VERBOSE)
        }
    }
    
    private fun calculateMemoryCacheSize(context: Context): Int {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryClass = activityManager.memoryClass
        // Utiliser 20% de la mémoire disponible pour le cache
        return (1024 * 1024 * memoryClass / 5)
    }
    
    private fun calculateDiskCacheSize(context: Context): Long {
        val statFs = StatFs(context.cacheDir.path)
        val available = statFs.blockCountLong * statFs.blockSizeLong
        // Limiter le cache disque à 250MB ou 5% de l'espace disponible
        return min(250 * 1024 * 1024, available / 20)
    }
}
```

### B. Exemple de Configuration Kingfisher (iOS)

```swift
struct ImageCacheManager {
    static func setupCache() {
        // Configuration du cache mémoire
        let memoryCapacity = Int(ProcessInfo.processInfo.physicalMemory * 0.2 / 1024 / 1024) // 20% de la RAM
        let preferredMemoryCapacity = min(memoryCapacity, 300) // Max 300MB
        
        // Configuration du cache disque
        let diskCapacity = 500 * 1024 * 1024 // 500MB
        
        // Application des paramètres
        ImageCache.default.memoryStorage.config.totalCostLimit = preferredMemoryCapacity * 1024 * 1024
        ImageCache.default.diskStorage.config.sizeLimit = UInt(diskCapacity)
        ImageCache.default.diskStorage.config.expiration = .days(7)
        
        // Configuration des processeurs d'image par défaut
        let processors: [ImageProcessor] = [
            DownsamplingImageProcessor(size: CGSize(width: 1080, height: 1080)),
            RoundCornerImageProcessor(cornerRadius: 5)
        ]
        
        // Options de téléchargement par défaut
        KingfisherManager.shared.defaultOptions = [
            .processor(processors.compose()),
            .scaleFactor(UIScreen.main.scale),
            .backgroundDecode,
            .cacheOriginalImage,
            .transition(.fade(0.2))
        ]
        
        // Configuration du downloader
        KingfisherManager.shared.downloader.downloadTimeout = 15.0
    }
    
    static func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
    
    static func prefetchImages(urls: [URL]) {
        let prefetcher = ImagePrefetcher(urls: urls)
        prefetcher.start()
    }
}
```

### C. Benchmarks de Compression par Format

| Format | Taille Originale | Compression | Qualité Visuelle | Temps Décodage | Support |
|--------|------------------|-------------|-----------------|----------------|---------|
| JPEG | 3.2 MB | 800 KB | Bonne | Rapide | Universel |
| WebP | 3.2 MB | 600 KB | Bonne | Moyen | Partiel |
| HEIC | 3.2 MB | 400 KB | Très bonne | Lent | Limité |
| PNG | 3.2 MB | 6.5 MB | Parfaite | Moyen | Universel |
| AVIF | 3.2 MB | 300 KB | Excellente | Lent | Très limité |