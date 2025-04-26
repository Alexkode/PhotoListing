# Architecture Logicielle Mobile - PhotoListing

Ce document décrit l'architecture logicielle de l'application mobile PhotoListing, qui sera développée avec Flutter pour un déploiement cross-platform sur iOS et Android.

## 1. Vue d'ensemble de l'architecture

### 1.1 Principes architecturaux

L'architecture de PhotoListing repose sur les principes suivants :
- **Séparation des préoccupations** : Découplage clair entre interface utilisateur, logique métier et accès aux données
- **Testabilité** : Architecture permettant des tests unitaires, d'intégration et UI automatisés
- **Maintenabilité** : Organisation du code facilitant la maintenance et l'extension
- **Réactivité** : Gestion efficace des flux de données et des états de l'application
- **Performance** : Optimisation du traitement et du rendu des images

### 1.2 Pattern architectural global

PhotoListing adopte une architecture **Clean Architecture** combinée avec le pattern **MVVM** (Model-View-ViewModel), spécifiquement adaptée pour Flutter.

```
┌───────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                      │
│  ┌──────────────┐  ┌─────────────┐  ┌──────────────────────┐  │
│  │    Pages     │  │   Widgets   │  │      ViewModels      │  │
│  │  (Screens)   │◄─┼─►(UI Comp.) │◄─┼─►(State Management)  │  │
│  └──────────────┘  └─────────────┘  └──────────────────────┘  │
└───────┬───────────────────────────────────────┬───────────────┘
        │                                       │
        ▼                                       ▼
┌───────────────────────┐       ┌───────────────────────────────┐
│     DOMAIN LAYER      │       │        APPLICATION LAYER       │
│  ┌─────────────────┐  │       │  ┌───────────────────────┐    │
│  │     Entités     │  │       │  │         Usecases      │    │
│  └─────────────────┘  │       │  └───────────────────────┘    │
│  ┌─────────────────┐  │◄─────►│  ┌───────────────────────┐    │
│  │  Repositories   │  │       │  │       Services        │    │
│  │   (Interfaces)  │  │       │  └───────────────────────┘    │
│  └─────────────────┘  │       │                               │
└───────┬───────────────┘       └───────────────────────────────┘
        │
        ▼
┌───────────────────────────────────────────────────────────────┐
│                         DATA LAYER                             │
│  ┌──────────────┐  ┌─────────────┐  ┌──────────────────────┐  │
│  │ Repositories │  │ Data Models │  │     Data Sources     │  │
│  │(Impléments.) │◄─┼─►(DTOs, etc)│◄─┼─►(API, Local Storage)│  │
│  └──────────────┘  └─────────────┘  └──────────────────────┘  │
└───────────────────────────────────────────────────────────────┘
```

## 2. Description des couches

### 2.1 Couche Présentation (Presentation Layer)

Responsable de l'affichage des informations à l'utilisateur et de la capture des interactions.

#### 2.1.1 Pages (Screens)
- Composants de niveau supérieur représentant un écran complet
- Orchestrent les widgets et gèrent la navigation
- Connectent les widgets aux ViewModels
- Exemples : `HomeScreen`, `PhotoEditorScreen`, `ProjectsScreen`

#### 2.1.2 Widgets
- Composants UI réutilisables
- Représentation visuelle pure (idéalement sans logique métier)
- Exemples : `BeforeAfterSlider`, `PhotoThumbnail`, `EditingControlsPanel`

#### 2.1.3 ViewModels
- Gèrent l'état et la logique de présentation
- Exposent des données réactives consommées par les Widgets
- Transforment les actions utilisateur en appels aux Usecases
- Implémentés avec Provider ou Riverpod pour la gestion d'état
- Exemples : `PhotoEditorViewModel`, `ProjectListViewModel`

### 2.2 Couche Domaine (Domain Layer)

Contient les règles métier et les concepts fondamentaux de l'application, indépendants de toute implémentation UI ou base de données.

#### 2.2.1 Entités
- Objets métier avec leurs propriétés et comportements
- Implémentés comme classes immuables
- Exemples : `Photo`, `Project`, `EditingPreset`, `User`

#### 2.2.2 Repositories (Interfaces)
- Définissent des contrats pour l'accès aux données
- Abstraient la source des données (API, local)
- Exemples : `IPhotoRepository`, `IUserRepository`, `IPresetRepository`

### 2.3 Couche Application (Application Layer)

Orchestre le flux de données entre la couche Présentation et la couche Domaine.

#### 2.3.1 Usecases
- Encapsulent une fonctionnalité métier spécifique
- Orchestrent les appels aux repositories
- Implémentent la logique métier complexe
- Exemples : `EnhancePhotoUsecase`, `CreateProjectUsecase`, `ExportPhotosUsecase`

#### 2.3.2 Services
- Encapsulent des fonctionnalités transversales
- Exemples : `AnalyticsService`, `ConnectivityService`, `PermissionsService`

### 2.4 Couche Données (Data Layer)

Responsable de l'accès aux données provenant de différentes sources.

#### 2.4.1 Repositories (Implémentations)
- Implémentent les interfaces définies dans la couche Domaine
- Gèrent la conversion entre Data Models et Entités
- Exemples : `PhotoRepositoryImpl`, `UserRepositoryImpl`

#### 2.4.2 Data Models
- Représentations des données spécifiques à la source
- Objets de transfert (DTOs) pour la sérialisation/désérialisation
- Exemples : `PhotoDTO`, `UserDTO`, `ApiResponse`

#### 2.4.3 Data Sources
- Fournissent l'accès direct aux données 
- Exemples : `OpenAIApiClient`, `LocalStorageService`, `FirebaseDataSource`

## 3. Flux de données et gestion d'état

### 3.1 Approche générale

PhotoListing utilise un flux de données unidirectionnel :
1. Les widgets déclenchent des événements via les ViewModels
2. Les ViewModels appellent les Usecases appropriés
3. Les Usecases interagissent avec les Repositories
4. Les données modifiées remontent la chaîne et mettent à jour l'UI

### 3.2 Gestion d'état

Pour la gestion d'état, nous utilisons **Riverpod** qui offre :
- Une gestion d'état réactive et performante
- Un système de dépendances clair et testable
- Un support pour les états asynchrones (loading, error, data)

Types de providers utilisés :
- **StateNotifierProvider** : Pour les états complexes avec mutations
- **FutureProvider** : Pour les données asynchrones
- **StreamProvider** : Pour les flux de données continus (comme les mises à jour en temps réel)

### 3.3 Exemple de flux de données

Exemple pour la fonctionnalité d'amélioration de photo :

```
┌───────────────┐   Actions    ┌───────────────────┐    appel     ┌───────────────────┐
│ PhotoEditPage │ ──────────► │PhotoEditorViewModel│ ──────────► │EnhancePhotoUsecase│
└───────────────┘              └───────────────────┘              └───────────────────┘
       ▲                               │                                   │
       │                               │                                   │
       │          Mise à jour          │                                   │
       │          de l'état            │                                   ▼
       │                               │                          ┌───────────────────┐
       └───────────────────────────────┘ ◄──────────────────────┐│  PhotoRepository  │
                                                                 └───────────────────┘
                                                                          │
                                                                          │
                                                                          ▼
                                                                 ┌───────────────────┐
                                                                 │   OpenAI API      │
                                                                 └───────────────────┘
```

## 4. Modules principaux

### 4.1 Module d'authentification

Gère l'inscription, la connexion et la session utilisateur.

**Composants clés :**
- `AuthRepository` : Interface pour les opérations d'authentification
- `AuthService` : Gestion de la session et des tokens
- `AuthViewModel` : État d'authentification et méthodes d'interaction
- `LoginScreen`, `RegisterScreen` : Interfaces utilisateur

### 4.2 Module de projets

Gère l'organisation des photos en projets et dossiers.

**Composants clés :**
- `ProjectRepository` : Opérations CRUD sur les projets
- `ProjectViewModel` : Gestion de la liste et détails des projets
- `ProjectListScreen`, `ProjectDetailScreen` : Interfaces utilisateur
- `CreateProjectUsecase`, `UpdateProjectUsecase` : Logique métier

### 4.3 Module d'édition de photos

Cœur fonctionnel de l'application, gère le traitement des images via l'API OpenAI.

**Composants clés :**
- `PhotoRepository` : Opérations sur les photos (local et cloud)
- `EnhancePhotoUsecase` : Orchestration du processus d'amélioration
- `PhotoEditorViewModel` : Gestion de l'état d'édition
- `PhotoEditorScreen` : Interface principale d'édition
- `EditingControlsWidget` : Contrôles d'édition
- `BeforeAfterComparisonWidget` : Visualisation du résultat

### 4.4 Module d'OpenAI

Gère l'intégration avec l'API DALL-E d'OpenAI.

**Composants clés :**
- `OpenAIService` : Service encapsulant les appels API
- `OpenAIRepository` : Interface du repository
- `OpenAIRepositoryImpl` : Implémentation concrète
- `OpenAIDataSource` : Accès direct à l'API REST
- `EnhancementRequest`, `EnhancementResponse` : Modèles de données

### 4.5 Module de stockage local

Gère la persistance locale des images et métadonnées.

**Composants clés :**
- `LocalStorageRepository` : Interface du repository
- `LocalStorageService` : Service de stockage
- `DatabaseHelper` : Couche d'abstraction SQLite/Hive
- `FileStorageService` : Gestion du stockage des images

### 4.6 Module d'export et partage

Gère l'exportation et le partage des photos traitées.

**Composants clés :**
- `ExportService` : Gestion des formats et résolutions
- `SharingService` : Intégration avec les APIs de partage
- `ExportOptionsViewModel` : Gestion des options d'export
- `SharingViewModel` : Gestion du partage
- `ExportScreen` : Interface d'exportation

## 5. Technologies et bibliothèques

### 5.1 Framework principal
- **Flutter** : Framework cross-platform UI (version 3.0+)
- **Dart** : Langage de programmation (version 2.16+)

### 5.2 Bibliothèques essentielles
- **Riverpod** : Gestion d'état (alternative à Provider)
- **Dio** : Client HTTP pour les requêtes API
- **flutter_secure_storage** : Stockage sécurisé (tokens, clés API)
- **sqflite** / **hive** : Stockage local structuré
- **path_provider** : Accès au système de fichiers
- **image** : Manipulation d'images basique côté client
- **share_plus** : Fonctionnalités de partage intégrées au système
- **flutter_image_compress** : Compression d'images

### 5.3 Bibliothèques d'UI
- **flutter_hooks** : Gestion du cycle de vie des widgets
- **google_fonts** : Polices personnalisées
- **cached_network_image** : Chargement et mise en cache d'images
- **shimmer** : Effets de chargement
- **photo_view** : Visualisation zoomable des images
- **before_after** : Widget de comparaison avant/après

### 5.4 Bibliothèques de test
- **mockito** : Framework de mock pour les tests
- **integration_test** : Tests d'intégration Flutter
- **golden_toolkit** : Tests de snapshot d'UI

## 6. Stratégie de communication API

### 6.1 Service OpenAI

#### 6.1.1 Configuration de base
```dart
class OpenAIConfig {
  static const String baseUrl = 'https://api.openai.com/v1';
  static const String imagesEndpoint = '/images';
  static const int timeoutSeconds = 30;
  // Autres configurations...
}
```

#### 6.1.2 Client API
```dart
class OpenAIClient {
  final Dio _dio;
  
  OpenAIClient(String apiKey) : _dio = Dio(BaseOptions(
    baseUrl: OpenAIConfig.baseUrl,
    connectTimeout: Duration(seconds: OpenAIConfig.timeoutSeconds),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
  ));
  
  Future<ImageEnhancementResponse> enhanceImage(ImageEnhancementRequest request) async {
    // Implémentation...
  }
  
  // Autres méthodes...
}
```

### 6.2 Gestion des erreurs API

```dart
enum ApiErrorType {
  network,
  authentication,
  server,
  timeout,
  unknown,
}

class ApiException implements Exception {
  final String message;
  final ApiErrorType type;
  final int? statusCode;
  
  ApiException({
    required this.message,
    required this.type,
    this.statusCode,
  });
  
  // Méthodes utilitaires...
}
```

### 6.3 Stratégie de mise en cache

Pour optimiser les performances et réduire les appels API :
- Mise en cache locale des résultats d'amélioration d'image
- Stratégie TTL (Time-To-Live) pour les ressources
- Stockage des thumbnails pour affichage rapide
- Priorisation du chargement des données essentielles

## 7. Exemples de code clés

### 7.1 Définition d'une entité

```dart
@freezed
class Photo with _$Photo {
  const factory Photo({
    required String id,
    required String path,
    required DateTime createdAt,
    String? enhancedPath,
    PhotoEnhancementSettings? enhancementSettings,
    PhotoEnhancementStatus status,
    String? projectId,
  }) = _Photo;
  
  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
}
```

### 7.2 Exemple de Repository

```dart
abstract class PhotoRepository {
  Future<List<Photo>> getPhotos(String projectId);
  Future<Photo> getPhoto(String id);
  Future<Photo> savePhoto(Photo photo);
  Future<Photo> enhancePhoto(String id, PhotoEnhancementSettings settings);
  Future<void> deletePhoto(String id);
}

class PhotoRepositoryImpl implements PhotoRepository {
  final LocalDataSource _localDataSource;
  final OpenAIService _openAIService;
  
  PhotoRepositoryImpl(this._localDataSource, this._openAIService);
  
  @override
  Future<Photo> enhancePhoto(String id, PhotoEnhancementSettings settings) async {
    // Implémentation...
  }
  
  // Autres méthodes...
}
```

### 7.3 Exemple de UseCase

```dart
class EnhancePhotoUseCase {
  final PhotoRepository _photoRepository;
  final AnalyticsService _analyticsService;
  
  EnhancePhotoUseCase(this._photoRepository, this._analyticsService);
  
  Future<Photo> execute(EnhancePhotoParams params) async {
    try {
      final enhancedPhoto = await _photoRepository.enhancePhoto(
        params.photoId,
        params.settings,
      );
      
      _analyticsService.trackEvent('photo_enhanced', {
        'preset': params.settings.preset.name,
        'intensity': params.settings.intensity,
      });
      
      return enhancedPhoto;
    } catch (e) {
      // Gestion des erreurs...
      rethrow;
    }
  }
}
```

### 7.4 Exemple de ViewModel

```dart
class PhotoEditorViewModel extends StateNotifier<PhotoEditorState> {
  final EnhancePhotoUseCase _enhancePhotoUseCase;
  final GetPhotoUseCase _getPhotoUseCase;
  final SavePhotoUseCase _savePhotoUseCase;
  
  PhotoEditorViewModel(
    this._enhancePhotoUseCase,
    this._getPhotoUseCase,
    this._savePhotoUseCase,
  ) : super(PhotoEditorState.initial());
  
  Future<void> loadPhoto(String photoId) async {
    state = state.copyWith(isLoading: true);
    try {
      final photo = await _getPhotoUseCase.execute(photoId);
      state = state.copyWith(
        photo: photo,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
  
  Future<void> enhancePhoto(PhotoEnhancementSettings settings) async {
    state = state.copyWith(isProcessing: true);
    try {
      final params = EnhancePhotoParams(
        photoId: state.photo!.id,
        settings: settings,
      );
      
      final enhancedPhoto = await _enhancePhotoUseCase.execute(params);
      
      state = state.copyWith(
        photo: enhancedPhoto,
        isProcessing: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isProcessing: false,
      );
    }
  }
  
  // Autres méthodes...
}
```

### 7.5 Exemple de Widget

```dart
class PhotoEditorScreen extends ConsumerWidget {
  final String photoId;
  
  const PhotoEditorScreen({required this.photoId, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = photoEditorViewModelProvider(photoId);
    final state = ref.watch(viewModelProvider);
    
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(viewModelProvider.notifier).loadPhoto(photoId);
      });
      return null;
    }, const []);
    
    return Scaffold(
      appBar: AppBar(title: Text('Amélioration de photo')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? ErrorView(message: state.error!)
              : Column(
                  children: [
                    Expanded(
                      child: BeforeAfterView(
                        beforeImage: state.photo!.path,
                        afterImage: state.photo!.enhancedPath,
                      ),
                    ),
                    EditingControlsPanel(
                      onSettingsChanged: (settings) {
                        ref.read(viewModelProvider.notifier).enhancePhoto(settings);
                      },
                      isProcessing: state.isProcessing,
                    ),
                  ],
                ),
    );
  }
}
```

## 8. Stratégie de test

### 8.1 Tests unitaires
- Tests des Usecases, Services et Repositories
- Utilisation de Mockito pour simuler les dépendances
- Couverture minimum de 80% pour la logique métier

### 8.2 Tests d'intégration
- Tests de l'interaction entre les couches
- Tests réels avec les APIs (avec mocks conditionnels)
- Tests des flux complets (ex: amélioration d'une photo de A à Z)

### 8.3 Tests d'interface utilisateur
- Tests golden pour vérifier le rendu visuel
- Tests des widgets pour vérifier le comportement
- Tests de bout en bout des scénarios utilisateur critiques

### 8.4 Configuration CI/CD
- Exécution automatique des tests à chaque pull request
- Vérification de la couverture de code
- Déploiement automatique vers les environnements de test

## 9. Considérations de performance et sécurité

### 9.1 Performance
- Chargement intelligent des images (thumbnails, streaming)
- Mise en cache des résultats d'API
- Traitement asynchrone en arrière-plan
- Optimisation de la taille des images avant envoi API

### 9.2 Sécurité
- Stockage sécurisé de la clé API OpenAI
- Chiffrement des données sensibles
- Validation des entrées utilisateur
- Tokens d'authentification avec rotation
- Stratégie de détection et gestion des erreurs API

## 10. Extensibilité et évolutions futures

### 10.1 Points d'extension prévus
- Support pour d'autres fournisseurs d'IA (pas seulement OpenAI)
- Système de plugins pour fonctionnalités additionnelles
- Internationalisation (i18n) intégrée dès le départ
- Architecture préparée pour le mode hors ligne

### 10.2 Évolutions planifiées
- Synchronisation cross-device
- Mode batch pour traitement de multiples images
- Intégration directe avec plateformes de location (Airbnb API)
- Analyse statistique des performances des annonces