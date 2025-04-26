# Guide de Journalisation & Monitoring

## Résumé Exécutif

Ce document définit la stratégie de journalisation, de monitoring et d'analyse des performances pour l'application PhotoListing. Il établit un cadre pour la collecte structurée des données techniques, le suivi des erreurs, la détection proactive des problèmes et l'amélioration continue de l'expérience utilisateur.

## 1. Principes et Objectifs

### 1.1 Objectifs de la Journalisation

- Fournir une visibilité sur l'état de l'application et son utilisation
- Faciliter le diagnostic des problèmes en production
- Permettre la détection précoce des anomalies
- Collecter des métriques pour l'optimisation continue
- Suivre les tendances d'utilisation et les comportements utilisateurs

### 1.2 Niveaux de Journalisation

| Niveau | Cas d'utilisation | Rétention | Volume |
|--------|-------------------|-----------|--------|
| ERROR | Exceptions non gérées, échecs critiques | 90 jours | Faible |
| WARNING | Conditions anormales, retrying | 30 jours | Moyen |
| INFO | Actions utilisateur, transitions d'états | 14 jours | Élevé |
| DEBUG | Données détaillées pour le développement | En DEV uniquement | Très élevé |
| VERBOSE | Traces d'exécution détaillées | En DEV uniquement | Extrême |

### 1.3 Gouvernance des Données

- Respect du RGPD et anonymisation des données personnelles
- Conservation limitée selon la finalité
- Chiffrement des journaux sensibles
- Politique de purge automatique
- Accès restreint aux données brutes

## 2. Architecture de Journalisation

### 2.1 Approche Multi-niveaux

![Architecture de Logging](https://via.placeholder.com/800x400?text=Schema+Architecture+Logging)

1. **Niveau Client (Mobile)**
   - Logs en mémoire et disque local
   - Tamponnage et envoi par lots
   - Filtrage selon l'environnement

2. **Niveau Transport**
   - Compression et chiffrement
   - Mécanisme de retry avec backoff exponentiel
   - Queue persistante en mode hors-ligne

3. **Niveau Backend**
   - Agrégation et stockage dans Elasticsearch
   - Analyse en temps réel avec Kibana
   - Alerting et reporting automatique

### 2.2 Flux des Données

```
[Events App] → [Logger Local] → [Buffer] → [Transport Service] 
→ [API Gateway] → [Event Processor] → [Storage] → [Analytics]
```

### 2.3 Implémentation Technique

#### Android
```kotlin
// Configuration Timber + Firebase Crashlytics
class LoggingApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        if (BuildConfig.DEBUG) {
            // En dev: logs verbeux vers la console
            Timber.plant(Timber.DebugTree())
        } else {
            // En prod: logs d'erreur vers Crashlytics, INFO+ vers Analytics
            Timber.plant(CrashlyticsTree())
            Timber.plant(AnalyticsTree(threshold = Log.INFO))
        }
    }
}

// Arbre Timber pour Crashlytics
class CrashlyticsTree : Timber.Tree() {
    override fun log(priority: Int, tag: String?, message: String, t: Throwable?) {
        if (priority >= Log.WARN) {
            FirebaseCrashlytics.getInstance().apply {
                setCustomKey("priority", priority)
                setCustomKey("tag", tag ?: "")
                log(message)
                t?.let { recordException(it) }
            }
        }
    }
}
```

#### iOS
```swift
// Configuration SwiftyBeaver + Firebase Crashlytics
class AppDelegate: UIResponder, UIApplicationDelegate {
    let log = SwiftyBeaver.self
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configuration du logging
        setupLogging()
        
        return true
    }
    
    private func setupLogging() {
        // Console pour le développement
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss$d $L $N.$F:$l - $M"
        
        // Fichier pour le debug local
        let file = FileDestination()
        file.logFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("photolisting.log")
        
        // Configuration de Firebase Analytics & Crashlytics
        let crashlytics = CrashlyticsDestination()
        crashlytics.minLevel = .warning
        
        // Ajout des destinations selon l'environnement
        #if DEBUG
        log.addDestination(console)
        log.addDestination(file)
        #else
        log.addDestination(crashlytics)
        #endif
    }
}
```

## 3. Événements et Métriques

### 3.1 Catégories d'Événements

| Catégorie | Description | Exemples |
|-----------|-------------|----------|
| Lifecycle | États de l'application | Démarrage, arrêt, mise en arrière-plan |
| Navigation | Changement d'écrans | Ouverture galerie, édition photo |
| Action | Interactions utilisateur | Upload photo, application filtre |
| Network | Communications réseau | API calls, téléchargements |
| Performance | Métriques de performance | Temps de chargement, mémoire |
| Error | Erreurs et exceptions | Crash, timeout, erreur API |

### 3.2 Structure d'un Événement

```json
{
  "timestamp": "2023-06-15T14:22:31.123Z",
  "session_id": "abc123def456",
  "user_id": "anonymized_hash",
  "type": "navigation",
  "name": "gallery_opened",
  "properties": {
    "source_screen": "home",
    "gallery_size": 128,
    "filtered": true,
    "load_time_ms": 245
  },
  "app_version": "1.2.3",
  "platform": "android",
  "os_version": "12",
  "device_model": "Pixel 6",
  "network_type": "wifi"
}
```

### 3.3 Métriques Clés

#### 3.3.1 Métriques de Performance
- Temps de démarrage à froid/à chaud
- Frame time (jank detection)
- Temps de chargement des écrans principaux
- Latence des opérations d'image
- Utilisation mémoire et CPU
- Durée des requêtes réseau

#### 3.3.2 Métriques d'Utilisation
- Session duration
- Nombre de photos traitées
- Taux d'utilisation des fonctionnalités
- Taux de conversion
- Rétention utilisateur
- Taux d'erreur

## 4. Crash Reporting

### 4.1 Stratégie de Collecte

- Détection automatique des crashes non gérés
- Capture des ANR (Application Not Responding) sur Android
- Rapport d'exceptions non fatales mais significatives
- Collecte du contexte avant crash (breadcrumbs)
- Capture d'écran optionnelle (avec consentement utilisateur)

### 4.2 Informations Collectées

- Stack trace complète
- Device fingerprint
- Version OS et application
- État de la mémoire et du stockage
- Logs précédant l'erreur
- Actions utilisateur récentes
- Variables d'état pertinentes (anonymisées)

### 4.3 Mise en Œuvre avec Firebase Crashlytics

#### Android
```kotlin
// Enrichissement des rapports de crash
class CrashReportingManager {
    fun initCrashReporting() {
        FirebaseCrashlytics.getInstance().apply {
            setCrashlyticsCollectionEnabled(!BuildConfig.DEBUG)
            
            // Informations utilisateur anonymisées
            val userId = getUserIdHash()
            setUserId(userId)
            
            // Informations contextuelles
            setCustomKey("subscription_tier", userPrefs.getSubscriptionTier())
            setCustomKey("photo_count", photoRepository.getPhotoCount())
            setCustomKey("last_sync", dateFormatter.format(userPrefs.getLastSyncDate()))
            setCustomKey("device_memory", getDeviceMemoryInfo())
            setCustomKey("available_storage", getAvailableStorage())
        }
    }
    
    fun logHandledException(exception: Exception, context: String) {
        Timber.e(exception, "Error in $context")
        FirebaseCrashlytics.getInstance().apply {
            setCustomKey("error_context", context)
            recordException(exception)
        }
    }
}
```

#### iOS
```swift
// Enrichissement des rapports de crash
class CrashReportingManager {
    static let shared = CrashReportingManager()
    
    func initCrashReporting() {
        #if !DEBUG
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
        // Informations utilisateur anonymisées
        let userId = getUserIdHash()
        Crashlytics.crashlytics().setUserID(userId)
        
        // Informations contextuelles
        Crashlytics.crashlytics().setCustomValue(userPrefs.subscriptionTier, forKey: "subscription_tier")
        Crashlytics.crashlytics().setCustomValue(photoRepository.photoCount, forKey: "photo_count")
        Crashlytics.crashlytics().setCustomValue(dateFormatter.string(from: userPrefs.lastSyncDate), forKey: "last_sync")
        Crashlytics.crashlytics().setCustomValue(getDeviceMemoryInfo(), forKey: "device_memory")
        Crashlytics.crashlytics().setCustomValue(getAvailableStorage(), forKey: "available_storage")
        #endif
    }
    
    func logHandledException(_ exception: Error, context: String) {
        log.error("Error in \(context): \(exception.localizedDescription)")
        Crashlytics.crashlytics().record(error: exception, userInfo: ["error_context": context])
    }
}
```

### 4.4 Processus de Traitement des Crashes

1. **Triage quotidien**
   - Analyse des nouveaux crashes
   - Priorisation par impact utilisateur
   - Assignation aux développeurs

2. **Investigation**
   - Reproduction en environnement de test
   - Analyse de la cause racine
   - Développement d'un correctif

3. **Validation**
   - Tests unitaires et d'intégration
   - Déploiement canary
   - Surveillance des métriques post-correction

4. **Rétroaction**
   - Mise à jour de la base de connaissances
   - Amélioration des tests de non-régression
   - Revue du processus si nécessaire

## 5. Performance Monitoring

### 5.1 Traces d'Exécution

Utilisation de Firebase Performance pour les traces critiques:

#### Android
```kotlin
// Trace personnalisée pour le chargement de la galerie
fun loadGallery() {
    val trace = FirebasePerformance.getInstance().newTrace("gallery_load")
    trace.start()
    
    try {
        trace.incrementCounter("photo_count", photoRepository.getPhotoCount())
        
        // Étape 1: Chargement des métadonnées
        val metadataStart = System.currentTimeMillis()
        val photos = photoRepository.getRecentPhotos(limit = 100)
        val metadataDuration = System.currentTimeMillis() - metadataStart
        trace.putMetric("metadata_load_ms", metadataDuration)
        
        // Étape 2: Préchargement des vignettes
        val thumbnailStart = System.currentTimeMillis()
        preloadThumbnails(photos)
        val thumbnailDuration = System.currentTimeMillis() - thumbnailStart
        trace.putMetric("thumbnail_preload_ms", thumbnailDuration)
        
        // Mise à jour UI
        updateUI(photos)
        
    } finally {
        trace.stop()
    }
}
```

#### iOS
```swift
// Trace personnalisée pour le chargement de la galerie
func loadGallery() {
    guard let trace = Performance.startTrace(name: "gallery_load") else { return }
    
    do {
        trace.incrementMetric(named: "photo_count", by: photoRepository.photoCount)
        
        // Étape 1: Chargement des métadonnées
        let metadataStart = Date()
        let photos = photoRepository.getRecentPhotos(limit: 100)
        let metadataDuration = Date().timeIntervalSince(metadataStart) * 1000
        trace.setMetric(named: "metadata_load_ms", to: metadataDuration)
        
        // Étape 2: Préchargement des vignettes
        let thumbnailStart = Date()
        preloadThumbnails(photos)
        let thumbnailDuration = Date().timeIntervalSince(thumbnailStart) * 1000
        trace.setMetric(named: "thumbnail_preload_ms", to: thumbnailDuration)
        
        // Mise à jour UI
        updateUI(photos)
        
    } finally {
        trace.stop()
    }
}
```

### 5.2 Métriques Automatiques

Firebase Performance collecte automatiquement:
- App start time
- Screen rendering time
- Network requests timing
- Slow frames & frozen frames

### 5.3 Seuils et Alertes

| Métrique | Seuil Warning | Seuil Critique | Action |
|----------|---------------|----------------|--------|
| App Start | > 2s | > 4s | Optimisation du startup |
| Screen Render | > 500ms | > 1s | Simplification UI, lazy loading |
| API Request | > 3s | > 5s | Optimisation réseau, caching |
| OOM Rate | > 0.5% | > 1% | Optimisation mémoire |
| ANR Rate | > 0.2% | > 0.5% | Déport des opérations du thread UI |
| Crash Rate | > 1% | > 3% | Investigation prioritaire |

## 6. Monitoring en Temps Réel

### 6.1 Dashboard Opérationnel

Dashboard Firebase avec:
- Nombre d'utilisateurs actifs
- Taux d'erreur global
- Crashes par version
- Latence moyenne des API
- Principaux écrans problématiques
- Distribution des versions

### 6.2 Alertes et Notifications

Configuration d'alertes pour:
- Augmentation soudaine des crashes (> 1%)
- Latence API anormale (> 5s)
- Taux d'ANR élevé
- Chute d'utilisateurs actifs
- Erreurs d'API récurrentes

### 6.3 Runbook d'Intervention

Procédures à suivre en cas d'alertes:

1. **Évaluation**
   - Confirmation du problème
   - Estimation de l'impact
   - Détermination de la portée

2. **Communication**
   - Notification interne à l'équipe
   - Mise à jour du statut pour les utilisateurs si nécessaire

3. **Mitigation**
   - Application des mesures temporaires
   - Déploiement d'urgence si nécessaire
   - Rollback à une version stable si critique

4. **Résolution**
   - Développement d'un correctif permanent
   - Tests approfondis
   - Déploiement progressif

5. **Post-mortem**
   - Analyse des causes
   - Documentation de l'incident
   - Mise à jour des procédures

## 7. Analyse des Tendances

### 7.1 Rapports Périodiques

Rapports hebdomadaires automatisés:
- Top 10 des crashes
- Performances moyennes
- Adoption des versions
- Utilisation des fonctionnalités
- Comportement utilisateur

### 7.2 Analyse A/B Testing

- Configuration de Firebase A/B Testing
- Mesure d'impact des variations
- Analyse statistique des résultats
- Prise de décision basée sur les données

### 7.3 Corrélation Multi-sources

Croisement des données:
- Logs applicatifs
- Crashlytics
- Firebase Performance
- Firebase Analytics
- Reviews App Store/Play Store
- Support utilisateur

## 8. Mise en Œuvre Technique

### 8.1 Dépendances et Configuration

#### Android
```gradle
// build.gradle
dependencies {
    // Logging
    implementation 'com.jakewharton.timber:timber:5.0.1'
    
    // Firebase
    implementation platform('com.google.firebase:firebase-bom:30.0.0')
    implementation 'com.google.firebase:firebase-analytics-ktx'
    implementation 'com.google.firebase:firebase-crashlytics-ktx'
    implementation 'com.google.firebase:firebase-perf-ktx'
    
    // Monitoring
    implementation 'io.sentry:sentry-android:6.0.0'
}
```

#### iOS
```ruby
# Podfile
target 'PhotoListing' do
  # Logging
  pod 'SwiftyBeaver', '~> 1.9.0'
  
  # Firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Performance'
  
  # Monitoring
  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '7.0.0'
end
```

### 8.2 Initialisation

#### Android
```kotlin
// Application.kt
class PhotoListingApp : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Initialisation Firebase
        FirebaseApp.initializeApp(this)
        
        // Configuration logs selon l'environnement
        setupLogging()
        
        // Initialisation monitoring performance
        FirebasePerformance.getInstance().isPerformanceCollectionEnabled = !BuildConfig.DEBUG
        
        // Configuration Sentry pour logs backend
        if (!BuildConfig.DEBUG) {
            Sentry.init { options ->
                options.dsn = BuildConfig.SENTRY_DSN
                options.environment = BuildConfig.FLAVOR
                options.isEnableAutoSessionTracking = true
                options.sessionTrackingIntervalMillis = 60000 // 1 minute
                options.enableAllAutoBreadcrumbs()
            }
        }
    }
    
    private fun setupLogging() {
        // Configuration adaptée selon environnement
    }
}
```

#### iOS
```swift
// AppDelegate.swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialisation Firebase
        FirebaseApp.configure()
        
        // Configuration logs
        setupLogging()
        
        // Initialisation performance monitoring
        #if !DEBUG
        Performance.sharedInstance().isDataCollectionEnabled = true
        #endif
        
        // Configuration Sentry
        #if !DEBUG
        SentrySDK.start { options in
            options.dsn = "https://your-sentry-dsn"
            options.environment = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
            options.enableAutoSessionTracking = true
            options.sessionTrackingIntervalMillis = 60000 // 1 minute
            options.enableOutOfMemoryTracking = true
        }
        #endif
        
        return true
    }
    
    private func setupLogging() {
        // Configuration adaptée selon environnement
    }
}
```

### 8.3 Wrapper d'Abstraction

Pour simplifier l'utilisation et faciliter les changements futurs:

```kotlin
// AnalyticsManager.kt
object AnalyticsManager {
    fun logEvent(name: String, params: Map<String, Any?> = emptyMap()) {
        // Firebase Analytics
        val bundle = Bundle()
        params.forEach { (key, value) ->
            when (value) {
                is String -> bundle.putString(key, value)
                is Int -> bundle.putInt(key, value)
                is Long -> bundle.putLong(key, value)
                is Double -> bundle.putDouble(key, value)
                is Boolean -> bundle.putBoolean(key, value)
            }
        }
        FirebaseAnalytics.getInstance().logEvent(name, bundle)
        
        // Sentry Breadcrumb
        Sentry.addBreadcrumb(Breadcrumb().apply {
            category = "analytics"
            message = "Event: $name"
            level = SentryLevel.INFO
            data = params.mapValues { it.value.toString() }
        })
    }
    
    fun logError(error: Throwable, context: String, params: Map<String, Any?> = emptyMap()) {
        // Crashlytics
        FirebaseCrashlytics.getInstance().apply {
            setCustomKey("error_context", context)
            params.forEach { (key, value) ->
                when (value) {
                    is String -> setCustomKey(key, value)
                    is Int -> setCustomKey(key, value)
                    is Long -> setCustomKey(key, value)
                    is Double -> setCustomKey(key, value)
                    is Boolean -> setCustomKey(key, value)
                }
            }
            recordException(error)
        }
        
        // Sentry
        Sentry.captureException(error, ScopeCallback { scope ->
            scope.setTag("context", context)
            params.forEach { (key, value) ->
                scope.setExtra(key, value.toString())
            }
        })
        
        // Timber
        Timber.e(error, "Error in $context: ${params.entries.joinToString { "${it.key}=${it.value}" }}")
    }
    
    fun startTrace(name: String): Trace {
        val firebaseTrace = FirebasePerformance.getInstance().newTrace(name)
        firebaseTrace.start()
        return Trace(firebaseTrace, name)
    }
    
    class Trace(private val firebaseTrace: com.google.firebase.perf.metrics.Trace, private val name: String) {
        private val startTime = System.currentTimeMillis()
        
        fun putAttribute(key: String, value: String) {
            firebaseTrace.putAttribute(key, value)
        }
        
        fun incrementMetric(name: String, value: Long = 1) {
            firebaseTrace.incrementMetric(name, value)
        }
        
        fun putMetric(name: String, value: Long) {
            firebaseTrace.putMetric(name, value)
        }
        
        fun stop() {
            firebaseTrace.stop()
            val duration = System.currentTimeMillis() - startTime
            Timber.d("Trace '$name' completed in $duration ms")
        }
    }
}
```

## 9. Bonnes Pratiques

### 9.1 Réduction du Bruit

- Filtrage des événements non significatifs
- Échantillonnage des métriques haute fréquence
- Agrégation des erreurs similaires
- Dédoublonnage des rapports d'erreur

### 9.2 Optimisation des Performances

- Envoi asynchrone et par lots
- Compression des données
- Stockage local tampon
- Politique de retry intelligente
- Désactivation en mode économie d'énergie

### 9.3 Protection des Données Sensibles

- Pas de PII dans les logs
- Masquage automatique des informations sensibles
- Hachage des identifiants utilisateur
- Suppression des tokens d'authentification
- Chiffrement des données en transit

## 10. Annexes

### 10.1 Checklist de Mise en Production

- [ ] Vérification des clés API Firebase
- [ ] Test du reporting de crash
- [ ] Validation des traces critiques
- [ ] Configuration des alertes
- [ ] Revue des événements analytiques
- [ ] Test du mode hors-ligne

### 10.2 Glossaire

- **ANR**: Application Not Responding
- **OOM**: Out Of Memory
- **TTL**: Time To Live
- **PII**: Personally Identifiable Information
- **MAU**: Monthly Active Users

### 10.3 Ressources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Sentry Documentation](https://docs.sentry.io/)
- [Android Vitals](https://developer.android.com/topic/performance/vitals)