# Spécification d'Intégration API OpenAI - PhotoListing

Ce document détaille l'intégration de l'API OpenAI DALL-E 3 dans l'application PhotoListing, en se concentrant sur les aspects techniques nécessaires pour améliorer les photos immobilières.

## 1. Vue d'ensemble de l'intégration

### 1.1 Objectif de l'intégration
L'API OpenAI DALL-E 3 est utilisée pour transformer des photos immobilières ordinaires en images de qualité professionnelle. L'intégration doit permettre :
- L'amélioration de l'éclairage et des couleurs
- La correction de perspective
- L'optimisation de la composition
- La mise en valeur des atouts du bien immobilier
- Le maintien de l'authenticité (sans dénaturer la réalité)

### 1.2 Services OpenAI utilisés
PhotoListing utilise spécifiquement :
- **API DALL-E 3** via l'endpoint `/v1/images/generations`
- Mode "natural" pour des améliorations réalistes
- Qualité "hd" pour les photos finales

### 1.3 Architecture d'intégration

```
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│ Application   │     │ Backend       │     │   OpenAI      │
│ Mobile        │ ──► │ PhotoListing  │ ──► │   API         │
└───────┬───────┘     └───────┬───────┘     └───────┬───────┘
        │                     │                     │
        │ 1. Photo +          │ 3. Requête          │ 4. Traitement
        │    paramètres       │    formatée         │    IA
        ▼                     ▼                     ▼
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│ Traitement    │     │ Génération    │     │ Réponse avec  │
│ préliminaire  │ ──► │ de prompt     │     │ image traitée │
└───────────────┘     └───────────────┘     └───────┬───────┘
                                                    │
┌───────────────┐     ┌───────────────┐     ┌───────▼───────┐
│ Affichage     │     │ Traitement    │     │ Backend       │
│ à l'utilisateur│ ◄── │ post-génération│ ◄── │ PhotoListing  │
└───────────────┘     └───────────────┘     └───────────────┘
   8. Résultat          7. Optimisation        6. Réception et
      final                finale              stockage
```

## 2. Configuration et prérequis

### 2.1 Clés API et quotas
- **Type de clé** : Production API Key (OpenAI)
- **Quotas mensuels** : 
  - Plan de base : 500 requêtes/jour (forfait particulier)
  - Plan intermédiaire : 2 000 requêtes/jour (forfait professionnel)
  - Plan entreprise : 10 000+ requêtes/jour (forfait agence)

### 2.2 Limitations techniques
- **Taille maximale d'image en entrée** : 20 Mo
- **Formats acceptés** : JPG, PNG, WEBP
- **Dimensions supportées** : 1024x1024, 1792x1024, 1024x1792 pixels
- **Délai moyen de réponse** : 5-15 secondes par image
- **Quota de génération** : Variable selon le forfait utilisateur

### 2.3 Gestion des clés API
- Stockage sécurisé dans AWS Secrets Manager
- Rotation des clés trimestrielle
- Monitoring d'utilisation pour détection d'abus
- Clés API distinctes par environnement (dev, staging, prod)

## 3. Endpoints et schémas

### 3.1 Endpoint principal

```
POST https://api.openai.com/v1/images/generations
```

### 3.2 Schéma de requête

#### 3.2.1 Structure de base
```json
{
  "model": "dall-e-3",
  "prompt": "string",
  "n": 1,
  "size": "1024x1024",
  "quality": "hd",
  "style": "natural",
  "response_format": "url"
}
```

#### 3.2.2 Paramètres
| Paramètre | Type | Description | Valeurs possibles |
|-----------|------|-------------|-------------------|
| model | string | Le modèle à utiliser | "dall-e-3" |
| prompt | string | Instructions détaillées pour l'amélioration | Texte, max 4000 caractères |
| n | integer | Nombre d'images à générer | 1 (seule valeur pour DALL-E 3) |
| size | string | Taille de l'image générée | "1024x1024", "1792x1024", "1024x1792" |
| quality | string | Qualité de l'image générée | "standard", "hd" |
| style | string | Style de génération | "vivid" (dramatique), "natural" (réaliste) |
| response_format | string | Format de la réponse | "url", "b64_json" |

### 3.3 Schéma de réponse

```json
{
  "created": 1680105931,
  "data": [
    {
      "url": "https://...",
      "revised_prompt": "string"
    }
  ]
}
```

### 3.4 Gestion des erreurs

#### 3.4.1 Codes d'erreur courants
| Code | Description | Action |
|------|-------------|--------|
| 400 | Requête mal formée | Vérifier la structure de la requête et les paramètres |
| 401 | Authentification incorrecte | Vérifier la validité de la clé API |
| 429 | Quota dépassé | Mettre en file d'attente et réessayer après délai |
| 500 | Erreur serveur | Réessayer avec backoff exponentiel |

#### 3.4.2 Structure d'erreur
```json
{
  "error": {
    "message": "Description de l'erreur",
    "type": "Type d'erreur",
    "param": "Paramètre concerné",
    "code": "Code spécifique"
  }
}
```

## 4. Construction des prompts

### 4.1 Structure générale des prompts

Les prompts envoyés à DALL-E 3 sont structurés en plusieurs sections pour obtenir des résultats optimaux :

```
Améliore cette photo immobilière [type_de_pièce] tout en préservant sa disposition et ses caractéristiques exactes. 
[Instructions_spécifiques_pièce]
Ajuste subtilement l'éclairage pour [objectif_éclairage], corrige la balance des couleurs pour [objectif_couleur], 
et optimise la perspective pour mettre en valeur l'espace. 
Niveau d'amélioration : [intensité].
Important : l'image doit rester une représentation fidèle et authentique du bien immobilier.
```

### 4.2 Paramètres dynamiques et préréglages

#### 4.2.1 Types de pièce et instructions spécifiques
| Type de pièce | Instructions spécifiques |
|---------------|--------------------------|
| Salon | "Mets en valeur l'espace et le confort, améliore la luminosité ambiante et la chaleur des tons" |
| Cuisine | "Fais ressortir la propreté et la fonctionnalité, améliore la netteté des surfaces et la définition des appareils" |
| Chambre | "Crée une ambiance reposante, adoucis la lumière et optimise l'équilibre des couleurs pour une atmosphère apaisante" |
| Salle de bain | "Accentue la propreté et la luminosité, améliore la clarté des surfaces et le rendu des matériaux" |
| Extérieur | "Optimise le ciel et la verdure, équilibre les ombres et améliore la profondeur de l'image" |

#### 4.2.2 Objectifs d'éclairage
| Intensité | Objectif d'éclairage |
|-----------|----------------------|
| Légère | "équilibrer subtilement les zones sombres et claires" |
| Modérée | "améliorer la luminosité générale sans surexposer" |
| Marquée | "maximiser la luminosité et le contraste pour un rendu professionnel" |

#### 4.2.3 Objectifs de couleur
| Intensité | Objectif de couleur |
|-----------|---------------------|
| Légère | "neutraliser légèrement les dominantes de couleur" |
| Modérée | "obtenir des couleurs naturelles et équilibrées" |
| Marquée | "obtenir des couleurs vibrantes et attrayantes tout en restant réalistes" |

### 4.3 Exemples de prompts complets

#### 4.3.1 Amélioration légère d'un salon
```
Améliore cette photo immobilière de salon tout en préservant sa disposition et ses caractéristiques exactes.
Mets en valeur l'espace et le confort, améliore la luminosité ambiante et la chaleur des tons.
Ajuste subtilement l'éclairage pour équilibrer subtilement les zones sombres et claires, corrige la balance 
des couleurs pour neutraliser légèrement les dominantes de couleur, et optimise la perspective pour mettre 
en valeur l'espace.
Niveau d'amélioration : léger.
Important : l'image doit rester une représentation fidèle et authentique du bien immobilier.
```

#### 4.3.2 Amélioration marquée d'une cuisine
```
Améliore cette photo immobilière de cuisine tout en préservant sa disposition et ses caractéristiques exactes.
Fais ressortir la propreté et la fonctionnalité, améliore la netteté des surfaces et la définition des appareils.
Ajuste subtilement l'éclairage pour maximiser la luminosité et le contraste pour un rendu professionnel, 
corrige la balance des couleurs pour obtenir des couleurs vibrantes et attrayantes tout en restant réalistes, 
et optimise la perspective pour mettre en valeur l'espace.
Niveau d'amélioration : marqué.
Important : l'image doit rester une représentation fidèle et authentique du bien immobilier.
```

## 5. Implémentation technique

### 5.1 Prétraitement des images

Avant d'envoyer une image à l'API OpenAI, plusieurs étapes de prétraitement sont appliquées :

1. **Redimensionnement** :
   - Adapter la taille aux ratios pris en charge (1:1, 16:9, 9:16)
   - Préserver le ratio en ajoutant des marges si nécessaire
   - Résolution maximale de 1792px sur le côté le plus long

2. **Optimisation** :
   - Compression JPEG avec qualité 85-90%
   - Suppression des métadonnées EXIF non essentielles
   - Limitation de la taille à 4 Mo maximum

3. **Normalisation** :
   - Correction d'exposition automatique légère
   - Détection et classification automatique du type de pièce

#### 5.1.1 Exemple de code (Flutter)
```dart
Future<File> preprocessImage(File originalImage, PreprocessSettings settings) async {
  // Chargement de l'image
  final image = img.decodeImage(await originalImage.readAsBytes());
  if (image == null) throw Exception('Failed to decode image');
  
  // Détection automatique du type de pièce
  final pieceType = await _detectRoomType(image);
  
  // Redimensionnement
  final resizedImage = _resizeImage(image, settings.targetSize);
  
  // Correction d'exposition de base
  final correctedImage = _basicExposureCorrection(resizedImage);
  
  // Compression
  final compressedBytes = await FlutterImageCompress.compressWithList(
    img.encodeJpg(correctedImage, quality: settings.quality),
    quality: settings.quality,
    format: CompressFormat.jpeg,
  );
  
  // Sauvegarde temporaire
  final tempFile = File('${(await getTemporaryDirectory()).path}/preprocessed_${DateTime.now().millisecondsSinceEpoch}.jpg');
  await tempFile.writeAsBytes(compressedBytes);
  
  return tempFile;
}
```

### 5.2 Intégration backend

#### 5.2.1 Structure de la fonction Lambda

```javascript
exports.handler = async (event) => {
  try {
    // Extraction des paramètres
    const { imageUrl, settings } = JSON.parse(event.body);
    
    // Récupération de l'image depuis S3
    const imageBuffer = await getImageFromS3(imageUrl);
    
    // Prétraitement complémentaire si nécessaire
    const processedBuffer = await preprocessImageIfNeeded(imageBuffer, settings);
    
    // Conversion en base64
    const base64Image = processedBuffer.toString('base64');
    
    // Génération du prompt
    const prompt = generatePrompt(settings);
    
    // Appel à l'API OpenAI
    const openaiResponse = await callOpenAI({
      model: "dall-e-3",
      prompt: prompt,
      n: 1,
      size: settings.size || "1024x1024",
      quality: settings.quality || "hd",
      style: "natural",
      response_format: "url",
    });
    
    // Téléchargement de l'image résultante
    const enhancedImageUrl = openaiResponse.data[0].url;
    const enhancedImage = await downloadImage(enhancedImageUrl);
    
    // Stockage dans S3
    const s3Url = await uploadToS3(enhancedImage, settings.userId, settings.projectId);
    
    // Réponse
    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        enhancedImageUrl: s3Url,
        originalPrompt: prompt,
        revisedPrompt: openaiResponse.data[0].revised_prompt
      })
    };
  } catch (error) {
    // Gestion des erreurs
    return handleApiError(error);
  }
};
```

#### 5.2.2 Fonction de génération de prompt

```javascript
function generatePrompt(settings) {
  const { roomType, enhancementLevel, specificInstructions } = settings;
  
  // Récupération des préréglages spécifiques
  const roomInstructions = ROOM_TYPE_INSTRUCTIONS[roomType] || ROOM_TYPE_INSTRUCTIONS.default;
  const lightingGoal = LIGHTING_GOALS[enhancementLevel] || LIGHTING_GOALS.moderate;
  const colorGoal = COLOR_GOALS[enhancementLevel] || COLOR_GOALS.moderate;
  
  // Construction du prompt
  const prompt = `
    Améliore cette photo immobilière ${roomType ? 'de ' + roomType : ''} tout en préservant sa disposition et ses caractéristiques exactes.
    ${roomInstructions}
    Ajuste subtilement l'éclairage pour ${lightingGoal}, corrige la balance des couleurs pour ${colorGoal},
    et optimise la perspective pour mettre en valeur l'espace.
    Niveau d'amélioration : ${enhancementLevel}.
    ${specificInstructions ? specificInstructions : ''}
    Important : l'image doit rester une représentation fidèle et authentique du bien immobilier.
  `.trim().replace(/\s+/g, ' ');
  
  return prompt;
}
```

### 5.3 Traitement côté application

#### 5.3.1 Gestion de la file d'attente de traitement

```dart
class ProcessingQueue {
  final List<QueueItem> _queue = [];
  bool _isProcessing = false;
  
  Future<void> addToQueue(Photo photo, EnhancementSettings settings) async {
    final item = QueueItem(photo: photo, settings: settings);
    _queue.add(item);
    
    // Déclencher le traitement si non actif
    if (!_isProcessing) {
      _processQueue();
    }
    
    return item.completer.future;
  }
  
  Future<void> _processQueue() async {
    if (_queue.isEmpty || _isProcessing) return;
    
    _isProcessing = true;
    
    try {
      final item = _queue.first;
      
      // Traitement de l'élément
      final result = await _processPhoto(item.photo, item.settings);
      
      // Notification du résultat
      item.completer.complete(result);
      
      // Suppression de l'élément traité
      _queue.removeAt(0);
    } catch (e) {
      // Gestion des erreurs
      final item = _queue.first;
      item.completer.completeError(e);
      _queue.removeAt(0);
    } finally {
      _isProcessing = false;
      
      // Traitement de l'élément suivant s'il existe
      if (_queue.isNotEmpty) {
        _processQueue();
      }
    }
  }
  
  Future<EnhancedPhoto> _processPhoto(Photo photo, EnhancementSettings settings) async {
    // Implémentation du traitement
  }
}
```

#### 5.3.2 Interface de comparaison avant/après

```dart
class BeforeAfterView extends StatefulWidget {
  final String beforeImagePath;
  final String afterImagePath;
  
  const BeforeAfterView({
    Key? key,
    required this.beforeImagePath,
    required this.afterImagePath,
  }) : super(key: key);
  
  @override
  _BeforeAfterViewState createState() => _BeforeAfterViewState();
}

class _BeforeAfterViewState extends State<BeforeAfterView> {
  double _position = 0.5;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _position = (_position + details.delta.dx / context.size!.width)
            .clamp(0.0, 1.0);
        });
      },
      child: Stack(
        children: [
          // Image avant
          Positioned.fill(
            child: Image.file(File(widget.beforeImagePath), fit: BoxFit.cover),
          ),
          // Image après avec clip
          Positioned.fill(
            child: ClipRect(
              clipper: _BeforeAfterClipper(_position),
              child: Image.file(File(widget.afterImagePath), fit: BoxFit.cover),
            ),
          ),
          // Ligne de séparation
          Positioned(
            top: 0,
            bottom: 0,
            left: _position * context.size!.width,
            width: 2,
            child: Container(color: Colors.white, boxShadow: [/* ... */]),
          ),
          // Indicateur de position
          Positioned(
            top: (context.size!.height / 2) - 12,
            left: (_position * context.size!.width) - 12,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [/* ... */],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BeforeAfterClipper extends CustomClipper<Rect> {
  final double position;
  
  _BeforeAfterClipper(this.position);
  
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      position * size.width,
      0,
      size.width,
      size.height,
    );
  }
  
  @override
  bool shouldReclip(_BeforeAfterClipper oldClipper) {
    return position != oldClipper.position;
  }
}
```

## 6. Gestion des quotas et limites

### 6.1 Limites par niveau d'abonnement

| Abonnement | Limite quotidienne | Limite mensuelle | Prix par image supplémentaire |
|------------|-------------------|-------------------|------------------------------|
| Gratuit | 5 images | 5 images | N/A |
| Particulier | 50 images | 1 500 images | 0,20€ |
| Professionnel | 200 images | 6 000 images | 0,15€ |
| Agence | 500 images | 15 000 images | 0,10€ |

### 6.2 Stratégies de gestion des quotas

1. **Surveillance proactive** :
   - Comptabilisation en temps réel des utilisations
   - Notifications à 80% d'utilisation du quota
   - Rapports d'utilisation accessibles dans l'application

2. **File d'attente intelligente** :
   - Priorité aux utilisateurs selon leur plan
   - Traitement différé pendant les heures creuses
   - Possibilité de réservation de quota pour projets importants

3. **Optimisation des appels API** :
   - Mise en cache des résultats pour images similaires
   - Détection des images inappropriées avant envoi API
   - Analyse préalable pour suggérer les bons paramètres

### 6.3 Gestion des dépassements

```dart
class QuotaManager {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;
  
  Future<bool> checkQuotaBeforeProcessing(String userId) async {
    // Récupération du plan de l'utilisateur
    final userPlan = await _apiClient.getUserPlan(userId);
    
    // Récupération de l'utilisation actuelle
    final currentUsage = await _apiClient.getCurrentUsage(userId);
    
    // Vérification de la disponibilité
    if (currentUsage.dailyCount >= userPlan.dailyLimit) {
      if (userPlan.allowsOverage) {
        // Demander confirmation pour dépassement payant
        return await _confirmOverage(
          currentCount: currentUsage.dailyCount,
          limit: userPlan.dailyLimit,
          costPerAdditional: userPlan.ovarageCost,
        );
      } else {
        // Quota épuisé sans possibilité de dépassement
        throw QuotaExceededException(
          'Quota quotidien épuisé. Revenez demain ou passez à un forfait supérieur.',
        );
      }
    }
    
    // Notification si proche de la limite
    if (currentUsage.dailyCount >= userPlan.dailyLimit * 0.8) {
      _notifyQuotaAlmostReached(
        currentCount: currentUsage.dailyCount,
        limit: userPlan.dailyLimit,
      );
    }
    
    return true;
  }
  
  // Autres méthodes...
}
```

## 7. Exemples de requêtes et réponses

### 7.1 Exemple de requête complète

```
POST https://api.openai.com/v1/images/generations
Headers:
  Content-Type: application/json
  Authorization: Bearer sk-xxxxxxxxxxxxxxxxxxxx

Body:
{
  "model": "dall-e-3",
  "prompt": "Améliore cette photo immobilière de salon tout en préservant sa disposition et ses caractéristiques exactes. Mets en valeur l'espace et le confort, améliore la luminosité ambiante et la chaleur des tons. Ajuste subtilement l'éclairage pour améliorer la luminosité générale sans surexposer, corrige la balance des couleurs pour obtenir des couleurs naturelles et équilibrées, et optimise la perspective pour mettre en valeur l'espace. Niveau d'amélioration : modéré. Important : l'image doit rester une représentation fidèle et authentique du bien immobilier.",
  "n": 1,
  "size": "1792x1024",
  "quality": "hd",
  "style": "natural",
  "response_format": "url"
}
```

### 7.2 Exemple de réponse

```json
{
  "created": 1683245123,
  "data": [
    {
      "url": "https://oaidalleapiprodscus.blob.core.windows.net/private/org-ABCxyz/user-123xyz/img-ABCxyz.png?st=2023-05-01T12%3A00%3A00Z&se=2023-05-01T14%3A00%3A00Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-05-01T13%3A00%3A00Z&ske=2023-05-02T13%3A00%3A00Z&sks=b&skv=2021-08-06&sig=ABCXYZ123/SIGNATUREVALUE=",
      "revised_prompt": "Enhanced professional real estate photograph of a living room, preserving the exact layout and characteristics. The image showcases the spaciousness and comfort of the room, with improved ambient lighting that enhances the warm tones of the furniture and décor. The lighting has been subtly adjusted to improve overall brightness without overexposure, creating a balanced, natural color palette. The perspective has been optimized to highlight the spacious nature of the room while maintaining authentic representation of the property. The enhancement is moderate, ensuring the image remains a faithful representation of the real estate."
    }
  ]
}
```

### 7.3 Exemple d'erreur

```json
{
  "error": {
    "message": "You've exceeded your rate limit for this endpoint. For more information about your rate limit usage, see 'https://platform.openai.com/account/rate-limits'",
    "type": "rate_limit_exceeded",
    "param": null,
    "code": "rate_limit_exceeded"
  }
}
```

## 8. Bonnes pratiques et optimisations

### 8.1 Optimisation des coûts API

1. **Mise en cache intelligente** :
   - Stockage des résultats pour réutilisation possible
   - Déduplication des images similaires

2. **Traitement par lot** :
   - Regroupement des demandes pendant les heures creuses
   - Prioritisation des requêtes selon l'urgence

3. **Préqualification des images** :
   - Analyse préalable pour éviter les rejets par modération
   - Optimisation des dimensions avant envoi

### 8.2 Stratégies de fallback

En cas d'indisponibilité de l'API OpenAI :

1. **Traitement local basique** :
   - Améliorations basiques (luminosité, contraste) via Flutter
   - Message à l'utilisateur expliquant la situation

2. **File d'attente persistante** :
   - Enregistrement de la demande pour traitement ultérieur
   - Notification push quand l'image est prête

3. **API alternatives** :
   - Basculement vers d'autres services d'amélioration d'image
   - Configuration prête pour Replicate ou Stability AI

### 8.3 Sécurité et conformité

1. **Filtrage du contenu** :
   - Détection d'images inappropriées avant traitement
   - Respect des directives d'utilisation d'OpenAI

2. **Protection des données** :
   - Conservation minimale des images sur les serveurs OpenAI
   - Suppression des métadonnées identifiantes

3. **Audit trail** :
   - Journalisation de toutes les requêtes API
   - Suivi des usages par utilisateur

## 9. Tests et validation

### 9.1 Suite de tests automatisés

1. **Tests unitaires** :
   - Validation de la génération de prompt
   - Vérification de la gestion des erreurs

2. **Tests d'intégration** :
   - Validation de bout en bout du processus
   - Simulation de diverses conditions d'erreur

3. **Tests de charge** :
   - Vérification du comportement sous forte charge
   - Validation des mécanismes de file d'attente

### 9.2 Jeu de données de test

Un ensemble d'images de référence est utilisé pour :
- Valider la qualité des améliorations
- Mesurer la cohérence des résultats
- Évaluer les performances en conditions réelles

### 9.3 Métriques de qualité

Pour mesurer la qualité des améliorations :
- Score SSIM (Structural Similarity Index)
- Évaluation humaine (panel de testeurs)
- Feedback utilisateur (note de satisfaction)

## 10. Maintenance et évolution

### 10.1 Surveillance de l'API

- Monitoring des changements dans l'API OpenAI
- Alertes sur les modifications de quotas ou tarifs
- Tests automatisés après mises à jour du modèle

### 10.2 Améliorations futures

1. **Intégration multi-modèles** :
   - Support de modèles alternatifs (Stability AI, Midjourney API)
   - Sélection automatique du meilleur modèle selon le type d'image

2. **Préréglages avancés** :
   - Styles photographiques personnalisables
   - Préréglages spécifiques par marque/agence

3. **IA locale** :
   - Modèles légers embarqués pour prétraitement
   - Réduction de la dépendance au cloud

### 10.3 Plan de version d'API

- Versionnement sémantique de l'intégration API
- Période de dépréciation pour les changements majeurs
- Documentation des modifications par version