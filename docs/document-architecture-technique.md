# Document d'Architecture Technique et Spécifications - PhotoListing

Ce document définit l'architecture technique complète et les spécifications nécessaires pour développer le projet PhotoListing de A à Z, facilitant une implémentation autonome.

## Table des matières

1. [Vision produit et contexte](#1-vision-produit-et-contexte)
2. [Architecture système globale](#2-architecture-système-globale)
3. [Architecture logicielle](#3-architecture-logicielle)
4. [Technologies et frameworks](#4-technologies-et-frameworks)
5. [Schéma de base de données](#5-schéma-de-base-de-données)
6. [API et endpoints](#6-api-et-endpoints)
7. [Intégration OpenAI](#7-intégration-openai)
8. [Interface utilisateur](#8-interface-utilisateur)
9. [Sécurité et conformité](#9-sécurité-et-conformité)
10. [Infrastructure de déploiement](#10-infrastructure-de-déploiement)
11. [Configuration de l'environnement de développement](#11-configuration-de-lenvironnement-de-développement)
12. [Plan d'implémentation](#12-plan-dimplémentation)

## 1. Vision produit et contexte

PhotoListing est une application mobile dédiée aux professionnels de l'immobilier permettant d'améliorer automatiquement la qualité des photos de biens immobiliers grâce à l'IA. L'application transforme des photos ordinaires en images de qualité professionnelle pour valoriser les annonces immobilières.

### Objectifs principaux
- Améliorer la qualité visuelle des photos immobilières
- Simplifier le processus d'édition professionnelle des images
- Permettre l'organisation et la gestion de projets immobiliers
- Faciliter l'export et le partage des images optimisées

### Utilisateurs cibles
- Agents immobiliers indépendants
- Agences immobilières
- Photographes spécialisés en immobilier
- Particuliers vendant ou louant leur bien

## 2. Architecture système globale

PhotoListing adopte une architecture cloud moderne orientée services:

```
┌───────────────────────────────────────────────────────────────────────────┐
│                         APPLICATIONS CLIENTES                             │
│  ┌───────────────┐            ┌───────────────┐            ┌──────────┐  │
│  │ Application   │            │ Application   │            │  Site    │  │
│  │ Mobile iOS    │            │ Mobile Android│            │  Web     │  │
│  └───────┬───────┘            └───────┬───────┘            └────┬─────┘  │
└──────────┼────────────────────────────┼──────────────────────────┼───────┘
           │                            │                          │
           │          HTTPS/REST        │                          │
┌──────────▼────────────────────────────▼──────────────────────────▼───────┐
│                           COUCHE BACKEND                                  │
│  ┌─────────────────────┐        ┌─────────────────────┐                  │
│  │   API Gateway       │◄──────►│  Serveur Backend    │                  │
│  │  (AWS API Gateway)  │        │    (AWS Lambda)     │                  │
│  └─────────┬───────────┘        └─────────┬───────────┘                  │
│            │                              │                              │
│  ┌─────────▼───────────┐      ┌───────────▼───────────┐                  │
│  │  Service Auth       │      │  Service Traitement   │                  │
│  │ (Amazon Cognito)    │      │     (AWS Lambda)      │                  │
│  └─────────────────────┘      └───────────┬───────────┘                  │
└───────────────────────────────────────────┼──────────────────────────────┘
                                            │
                                            │ API REST
┌────────────────────────────────────────────▼─────────────────────────────┐
│                          SERVICES EXTERNES                                │
│  ┌─────────────────────┐        ┌─────────────────────┐                  │
│  │     OpenAI API      │        │   Services Tiers    │                  │
│  │   (DALL-E Images)   │        │ (Analytics, etc.)   │                  │
│  └─────────────────────┘        └─────────────────────┘                  │
└───────────────────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────────────────┐
│                         STOCKAGE DE DONNÉES                               │
│  ┌─────────────────────┐        ┌─────────────────────┐                  │
│  │   Base de données   │        │    Stockage         │                  │
│  │    (DynamoDB)       │        │   (Amazon S3)       │                  │
│  └─────────────────────┘        └─────────────────────┘                  │
└───────────────────────────────────────────────────────────────────────────┘
```

### Composants principaux

#### Applications clientes
- Applications mobiles iOS et Android développées avec Flutter
- Interface d'administration web (React/TypeScript)

#### Backend
- API Gateway pour la gestion des requêtes
- Services backend serverless (AWS Lambda)
- Authentification avec Amazon Cognito

#### Services externes
- OpenAI DALL-E 3 pour le traitement d'images
- Firebase pour analytics et notifications

#### Stockage
- DynamoDB pour les données structurées
- Amazon S3 pour le stockage d'images
- CloudFront pour la distribution d'images

## 3. Architecture logicielle

L'application mobile utilise une **Clean Architecture** combinée avec le pattern **MVVM** (Model-View-ViewModel):

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

### Modules principaux

1. **Module d'authentification**
   - Gestion des comptes utilisateurs
   - Niveaux d'abonnement et quotas

2. **Module de projets**
   - Création et gestion de projets immobiliers
   - Organisation des photos en dossiers
   - Métadonnées des biens immobiliers

3. **Module d'édition de photos**
   - Interface avec l'API OpenAI
   - Préréglages d'amélioration
   - Visualisation avant/après

4. **Module d'export et partage**
   - Export en différentes résolutions
   - Partage vers plateformes immobilières
   - Options de filigrane et branding

5. **Module de stockage local**
   - Cache des images
   - Synchronisation avec le cloud
   - Fonctionnement hors-ligne

## 4. Technologies et frameworks

### Frontend mobile

- **Framework principal**: Flutter 3.10+
- **Langage**: Dart 3.0+
- **Gestion d'état**: Riverpod 2.3+
- **Base de données locale**: Hive 2.2+ / SQLite (via drift 2.5+)
- **Networking**: Dio 5.0+
- **Gestion d'images**: flutter_image 4.0+, image_picker 0.8+
- **Analytics**: Firebase Analytics 10.0+
- **Authentification**: firebase_auth 4.6+, amazon_cognito_identity_dart_2 3.0+
- **Stockage local**: path_provider 2.0+, flutter_secure_storage 8.0+
- **Interface utilisateur**: google_fonts 4.0+, flutter_hooks 0.18+, flutter_svg 2.0+

### Backend

- **Framework**: AWS Lambda (Node.js 18+ / TypeScript 5.0+)
- **API Gateway**: Amazon API Gateway
- **Authentification**: Amazon Cognito
- **Base de données**: Amazon DynamoDB
- **Stockage**: Amazon S3
- **CDN**: Amazon CloudFront
- **Logging/Monitoring**: Amazon CloudWatch
- **Deployment**: AWS CDK / Serverless Framework 3.0+

### Interface d'administration web

- **Framework**: React 18.0+
- **Langage**: TypeScript 5.0+
- **State Management**: Redux Toolkit 1.9+
- **UI Library**: Material-UI (MUI) 5.0+
- **Graphiques**: Chart.js 4.0+
- **Authentification**: AWS Amplify 5.0+

## 5. Schéma de base de données

PhotoListing utilise DynamoDB comme base de données principale. Voici le schéma des principales tables:

### Table Users
| Attribut          | Type      | Description                                  |
|-------------------|-----------|----------------------------------------------|
| userId            | String    | Identifiant unique utilisateur (clé primaire)|
| email             | String    | Email de l'utilisateur                       |
| name              | String    | Nom complet                                  |
| subscriptionLevel | String    | Niveau d'abonnement (free, pro, agency)      |
| quotaTotal        | Number    | Quota total d'images par mois                |
| quotaUsed         | Number    | Quota utilisé ce mois                        |
| createdAt         | Timestamp | Date de création du compte                   |
| lastLogin         | Timestamp | Dernière connexion                           |
| settings          | Map       | Préférences utilisateur                      |

### Table Projects
| Attribut       | Type      | Description                                  |
|----------------|-----------|----------------------------------------------|
| projectId      | String    | Identifiant unique du projet (clé primaire)  |
| userId         | String    | Identifiant de l'utilisateur propriétaire    |
| name           | String    | Nom du projet                                |
| description    | String    | Description du projet                        |
| location       | String    | Adresse du bien immobilier                   |
| propertyType   | String    | Type de bien (appartement, maison, etc.)     |
| createdAt      | Timestamp | Date de création                             |
| updatedAt      | Timestamp | Dernière modification                        |
| photoCount     | Number    | Nombre de photos dans le projet              |
| folders        | List      | Liste des dossiers du projet                 |
| metadata       | Map       | Métadonnées supplémentaires                  |

### Table Photos
| Attribut       | Type      | Description                                  |
|----------------|-----------|----------------------------------------------|
| photoId        | String    | Identifiant unique de la photo (clé primaire)|
| projectId      | String    | Identifiant du projet associé                |
| userId         | String    | Identifiant de l'utilisateur propriétaire    |
| folderId       | String    | Identifiant du dossier (optionnel)           |
| originalKey    | String    | Clé S3 de l'image originale                  |
| processedKey   | String    | Clé S3 de l'image traitée                    |
| thumbnailKey   | String    | Clé S3 de la miniature                       |
| roomType       | String    | Type de pièce (salon, cuisine, etc.)         |
| enhancementType| String    | Type d'amélioration appliqué                 |
| status         | String    | Statut (pending, processing, completed, error)|
| createdAt      | Timestamp | Date d'ajout                                 |
| processedAt    | Timestamp | Date de traitement                           |
| metadata       | Map       | Métadonnées supplémentaires                  |

### Table Subscriptions
| Attribut           | Type      | Description                                  |
|--------------------|-----------|----------------------------------------------|
| subscriptionId     | String    | Identifiant de l'abonnement (clé primaire)   |
| userId             | String    | Identifiant de l'utilisateur                 |
| level              | String    | Niveau d'abonnement                          |
| status             | String    | Statut (active, canceled, etc.)              |
| startDate          | Timestamp | Date de début                                |
| endDate            | Timestamp | Date de fin                                  |
| paymentMethod      | String    | Méthode de paiement                          |
| autoRenew          | Boolean   | Renouvellement automatique                   |
| price              | Number    | Prix de l'abonnement                         |
| currency           | String    | Devise                                       |

## 6. API et endpoints

### API Gateway Structure

Base URL: `https://api.photolisting.com/v1`

#### Authentification & Utilisateurs
- `POST /auth/register` - Inscription utilisateur
- `POST /auth/login` - Connexion
- `POST /auth/refresh-token` - Rafraîchir token d'authentification
- `GET /users/me` - Obtenir profil utilisateur
- `PUT /users/me` - Mettre à jour profil
- `GET /users/me/quota` - Vérifier quota disponible
- `GET /users/me/subscription` - Infos abonnement

#### Projets
- `GET /projects` - Liste des projets
- `POST /projects` - Créer un projet
- `GET /projects/{projectId}` - Détails d'un projet
- `PUT /projects/{projectId}` - Mettre à jour un projet
- `DELETE /projects/{projectId}` - Supprimer un projet
- `GET /projects/{projectId}/photos` - Photos d'un projet
- `POST /projects/{projectId}/folders` - Créer un dossier
- `PUT /projects/{projectId}/folders/{folderId}` - Modifier un dossier
- `DELETE /projects/{projectId}/folders/{folderId}` - Supprimer un dossier

#### Photos
- `POST /photos/upload` - Uploader une photo
- `POST /photos/{photoId}/enhance` - Améliorer une photo
- `GET /photos/{photoId}` - Détails d'une photo
- `DELETE /photos/{photoId}` - Supprimer une photo
- `GET /photos/{photoId}/download` - Télécharger une photo
- `PUT /photos/{photoId}/metadata` - Mettre à jour métadonnées
- `POST /photos/batch-enhance` - Améliorer plusieurs photos

#### Export & Partage
- `POST /export/create` - Créer un export
- `GET /export/{exportId}` - Statut d'un export
- `POST /share/link` - Créer lien de partage
- `POST /share/platform` - Partager vers plateforme

### Exemple de schéma de requête/réponse

#### Amélioration d'une photo (POST /photos/{photoId}/enhance)

Requête:
```json
{
  "enhancementType": "moderate",
  "roomType": "living_room", 
  "preserveDetails": true,
  "adjustments": {
    "brightness": 0.2,
    "contrast": 0.1,
    "colorBalance": "warm"
  }
}
```

Réponse:
```json
{
  "status": "processing",
  "photoId": "photo-123456",
  "estimatedTimeSeconds": 15,
  "enhancementType": "moderate",
  "originalUrl": "https://cdn.photolisting.com/original/user123/photo-123456.jpg",
  "processingId": "proc-789012"
}
```

## 7. Intégration OpenAI

PhotoListing s'intègre avec l'API OpenAI DALL-E 3 pour l'amélioration des photos.

### Configuration de l'API
- **Endpoint**: `https://api.openai.com/v1/images/generations`
- **Modèle**: `dall-e-3`
- **Paramètres clés**:
  - `quality`: "hd" 
  - `style`: "natural" (pour un rendu réaliste)
  - `size`: "1024x1024", "1792x1024" ou "1024x1792" selon le ratio

### Structure des prompts

Template de base pour les prompts:
```
Améliore cette photo immobilière [type_de_pièce] tout en préservant sa disposition et ses caractéristiques exactes. 
[Instructions_spécifiques_pièce]
Ajuste subtilement l'éclairage pour [objectif_éclairage], corrige la balance des couleurs pour [objectif_couleur], 
et optimise la perspective pour mettre en valeur l'espace. 
Niveau d'amélioration : [intensité].
Important : l'image doit rester une représentation fidèle et authentique du bien immobilier.
```

### Types de pièces et préréglages

| Type de pièce | Instructions spécifiques |
|---------------|--------------------------|
| Salon | "Mets en valeur l'espace et le confort, améliore la luminosité ambiante et la chaleur des tons" |
| Cuisine | "Fais ressortir la propreté et la fonctionnalité, améliore la netteté des surfaces et la définition des appareils" |
| Chambre | "Crée une ambiance reposante, adoucis la lumière et optimise l'équilibre des couleurs pour une atmosphère apaisante" |
| Salle de bain | "Accentue la propreté et la luminosité, améliore la clarté des surfaces et le rendu des matériaux" |
| Extérieur | "Optimise le ciel et la verdure, équilibre les ombres et améliore la profondeur de l'image" |

### Flux de traitement d'image

```
┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│ Application   │      │ API Gateway   │      │ Service de    │
│ Mobile        │ ──► │               │ ──► │ Traitement    │
└───────┬───────┘      └───────┬───────┘      └───────┬───────┘
        │                      │                      │
        │ 1. Upload            │ 2. Transfert         │ 3. Prétraitement
        │    photo             │    au service        │    (redim., optim.)
        ▼                      ▼                      ▼
┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│ S3 Bucket     │      │ Lambda        │      │ OpenAI API    │
│ (original)    │ ◄── │ Optimization  │ ──► │ (DALL-E)      │
└───────┬───────┘      └───────────────┘      └───────┬───────┘
        │                                             │
        │                                             │ 4. Traitement
        │                                             │    IA
        │                                             ▼
┌───────▼───────┐      ┌───────────────┐      ┌───────────────┐
│ S3 Bucket     │ ◄── │ Lambda        │ ◄── │ Service Post-  │
│ (processed)   │      │ Post-Process. │      │ Traitement    │
└───────┬───────┘      └───────────────┘      └───────────────┘
        │
        │ 5. Stockage
        │    final
        ▼
┌───────────────┐      ┌───────────────┐
│ CloudFront    │ ──► │ Application   │
│ CDN           │      │ Mobile        │
└───────────────┘      └───────────────┘
                        6. Affichage à
                           l'utilisateur
```

### Prétraitement des images
1. Redimensionnement au format compatible avec DALL-E
2. Compression JPEG avec qualité 85-90%
3. Suppression des métadonnées EXIF non essentielles
4. Détection automatique du type de pièce 

### Post-traitement
1. Optimisation pour le web et mobile
2. Génération de miniatures
3. Application de corrections supplémentaires si nécessaire
4. Ajout de métadonnées et organisation dans S3

## 8. Interface utilisateur

### Écrans principaux

1. **Écran d'accueil / Tableau de bord**
   - Liste des projets récents
   - Statistiques d'utilisation
   - Accès rapide aux fonctionnalités

2. **Projets**
   - Liste des projets
   - Création/modification de projet
   - Organisation en dossiers
   - Vue grille/liste des photos

3. **Capture et sélection de photos**
   - Prise de photo en temps réel
   - Import depuis la galerie
   - Sélection multiple
   - Prévisualisation

4. **Éditeur de photos**
   - Interface d'amélioration
   - Préréglages par type de pièce
   - Ajustements manuels
   - Comparaison avant/après

5. **Export et partage**
   - Options de résolution et format
   - Ajout de filigrane/branding
   - Partage vers plateformes
   - Génération de lien de téléchargement

### Style d'interface

- Design épuré et professionnel
- Palette de couleurs: bleu professionnel, blanc, gris clair
- Typographie: Roboto pour le texte, Montserrat pour les titres
- Gestes intuitifs pour manipulation des photos
- Mode sombre/clair

### Wireframes clés

Pour les wireframes détaillés, voir le document "5-specification-ui-detaillee.md"

## 9. Sécurité et conformité

### Authentification et autorisation
- JWT (JSON Web Tokens) pour l'authentification
- OAuth 2.0 pour intégration avec Google/Apple
- Rafraîchissement automatique des tokens
- Authentification multi-facteurs pour comptes administrateurs

### Sécurité des données
- Chiffrement des données en transit (TLS 1.3)
- Chiffrement des données au repos (AES-256)
- Politique d'accès S3 restrictive
- Stockage sécurisé des clés API (AWS Secrets Manager)

### Conformité RGPD
- Politique de confidentialité claire
- Mécanisme de consentement utilisateur
- Capacité d'export et suppression des données
- Journalisation limitée aux données nécessaires
- Suppression automatique des données inactives

### Audit et monitoring
- Journalisation des accès et modifications
- Détection d'anomalies
- Alertes de sécurité
- Analyse régulière des vulnérabilités

## 10. Infrastructure de déploiement

### Environnements
- **Développement**: Pour tests en cours de développement
- **Staging**: Pour tests pré-production
- **Production**: Environnement client final

### AWS Architecture
- **Régions**: Multi-région (eu-west-1 principal, us-east-1 secondaire)
- **Redondance**: Architecture haute disponibilité
- **Auto-scaling**: Adaptation à la charge utilisateur
- **Backup**: Sauvegardes quotidiennes des données

### CI/CD Pipeline
- **Outil**: GitHub Actions
- **Processus**:
  1. Tests automatisés
  2. Analyse statique du code
  3. Build des artifacts
  4. Déploiement en staging
  5. Tests d'intégration
  6. Déploiement en production (manuel ou automatique)

### Monitoring et maintenance
- CloudWatch pour métriques et logs
- Alarmes sur métriques critiques
- Dashboard opérationnel
- Procédures de rollback

## 11. Configuration de l'environnement de développement

### Prérequis
- Flutter SDK 3.10+
- Dart SDK 3.0+
- Node.js 18+ (pour backend)
- AWS CLI 2.0+
- Android Studio / Xcode
- VS Code avec extensions Flutter/Dart

### Variables d'environnement
```
# Développement
PHOTOLISTING_ENV=development
OPENAI_API_KEY=sk-dev-xxx
AWS_REGION=eu-west-1
API_ENDPOINT=https://dev-api.photolisting.com/v1

# Production
PHOTOLISTING_ENV=production
OPENAI_API_KEY=sk-prod-xxx
AWS_REGION=eu-west-1
API_ENDPOINT=https://api.photolisting.com/v1
```

### Configuration locale
1. Cloner le dépôt: `git clone https://github.com/photolisting/app.git`
2. Installer les dépendances: `flutter pub get`
3. Configurer les variables d'environnement
4. Lancer en mode développement: `flutter run`

### Configuration backend
1. Cloner le dépôt: `git clone https://github.com/photolisting/backend.git`
2. Installer les dépendances: `npm install`
3. Configurer AWS credentials
4. Déployer en dev: `npx serverless deploy --stage dev`

## 12. Plan d'implémentation

### Phase 1: Fondations (4 semaines)
- Configuration de l'environnement de développement
- Mise en place de l'architecture de base
- Implémentation de l'authentification
- Création du modèle de données
- Setup de l'infrastructure AWS

### Phase 2: Fonctionnalités core (6 semaines)
- Gestion des projets et photos
- Upload et stockage des images
- Interface utilisateur de base
- Intégration initiale avec OpenAI

### Phase 3: Amélioration IA (4 semaines)
- Optimisation des prompts OpenAI
- Préréglages par type de pièce
- Interface d'édition complète
- Visualisation avant/après

### Phase 4: Export et partage (3 semaines)
- Fonctionnalités d'export
- Options de partage
- Intégration avec plateformes immobilières
- Gestion des résolutions et formats

### Phase 5: Finalisation (3 semaines)
- Tests complets
- Optimisation des performances
- Documentation utilisateur
- Préparation au déploiement

### Phase 6: Déploiement (2 semaines)
- Déploiement sur les stores
- Monitoring post-lancement
- Corrections de bugs
- Optimisations finales

## Conclusion

Ce document d'architecture technique et de spécifications fournit un guide complet pour le développement du projet PhotoListing. Il couvre tous les aspects nécessaires pour une implémentation autonome, de l'architecture système aux détails d'implémentation. 

En suivant ce guide et en utilisant les technologies recommandées, l'application peut être développée de manière efficace, évolutive et maintenable, tout en respectant les meilleures pratiques actuelles de développement mobile et cloud.