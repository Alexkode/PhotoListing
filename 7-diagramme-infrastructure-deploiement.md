# Diagramme d'Infrastructure & Déploiement - PhotoListing

Ce document détaille l'architecture d'infrastructure et la stratégie de déploiement pour l'application PhotoListing.

## 1. Vue d'ensemble de l'infrastructure

### 1.1 Architecture système globale

L'application PhotoListing s'appuie sur une architecture cloud moderne, orientée services, qui permet une mise à l'échelle efficace et une maintenance simplifiée.

```
┌───────────────────────────────────────────────────────────────────────────┐
│                                                                           │
│                         APPLICATIONS CLIENTES                             │
│                                                                           │
│  ┌───────────────┐            ┌───────────────┐            ┌──────────┐  │
│  │ Application   │            │ Application   │            │  Site    │  │
│  │ Mobile iOS    │            │ Mobile Android│            │  Web     │  │
│  └───────┬───────┘            └───────┬───────┘            └────┬─────┘  │
│          │                            │                          │       │
└──────────┼────────────────────────────┼──────────────────────────┼───────┘
           │                            │                          │
           │          HTTPS/REST        │                          │
           │                            │                          │
┌──────────▼────────────────────────────▼──────────────────────────▼───────┐
│                                                                           │
│                           COUCHE BACKEND                                  │
│                                                                           │
│  ┌─────────────────────┐        ┌─────────────────────┐                  │
│  │   API Gateway       │◄──────►│  Serveur Backend    │                  │
│  │  (AWS API Gateway)  │        │    (AWS Lambda)     │                  │
│  └─────────┬───────────┘        └─────────┬───────────┘                  │
│            │                              │                              │
│            │                              │                              │
│  ┌─────────▼───────────┐      ┌───────────▼───────────┐                  │
│  │  Service Auth       │      │  Service Traitement   │                  │
│  │ (Amazon Cognito)    │      │     (AWS Lambda)      │                  │
│  └─────────────────────┘      └───────────┬───────────┘                  │
│                                           │                              │
└───────────────────────────────────────────┼──────────────────────────────┘
                                            │
                                            │ API REST
                                            │
┌────────────────────────────────────────────▼─────────────────────────────┐
│                                                                           │
│                          SERVICES EXTERNES                                │
│                                                                           │
│  ┌─────────────────────┐        ┌─────────────────────┐                  │
│  │     OpenAI API      │        │   Services Tiers    │                  │
│  │   (DALL-E Images)   │        │ (Analytics, etc.)   │                  │
│  └─────────────────────┘        └─────────────────────┘                  │
│                                                                           │
└───────────────────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────────────────┐
│                                                                           │
│                         STOCKAGE DE DONNÉES                               │
│                                                                           │
│  ┌─────────────────────┐        ┌─────────────────────┐                  │
│  │   Base de données   │        │    Stockage         │                  │
│  │    (DynamoDB)       │        │   (Amazon S3)       │                  │
│  └─────────────────────┘        └─────────────────────┘                  │
│                                                                           │
└───────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Composants principaux

1. **Applications clientes** :
   - Applications mobiles natives iOS et Android
   - Site web administratif (pour gestion des utilisateurs et analytics)

2. **Couche Backend** :
   - API Gateway pour la gestion des requêtes
   - Services backend serverless (AWS Lambda)
   - Service d'authentification (Amazon Cognito)

3. **Services externes** :
   - API OpenAI DALL-E pour le traitement d'images
   - Services tiers (analytics, monitoring, etc.)

4. **Stockage de données** :
   - Base de données NoSQL (DynamoDB)
   - Stockage d'objets pour les images (Amazon S3)
   - CDN pour la distribution des images (CloudFront)

## 2. Architecture détaillée par composant

### 2.1 Applications clientes

#### 2.1.1 Applications mobiles (iOS/Android)

Les applications mobiles sont développées avec Flutter, ce qui permet de partager la majorité du code entre iOS et Android. Elles suivent l'architecture Clean Architecture + MVVM décrite dans le document d'architecture logicielle.

**Caractéristiques clés** :
- Code partagé à ~95% entre iOS et Android
- Stockage local avec SQLite/Hive pour le fonctionnement hors-ligne
- Compression et optimisation des images avant envoi au serveur
- Mise en cache intelligente des images traitées

#### 2.1.2 Interface d'administration Web

Une interface web est disponible pour les administrateurs système et les utilisateurs professionnels (forfait Agence).

**Caractéristiques clés** :
- Développée avec React et TypeScript
- Tableau de bord d'administration pour la gestion des utilisateurs
- Visualisation des statistiques d'utilisation
- Gestion des abonnements et des paramètres avancés

### 2.2 Infrastructure Backend

#### 2.2.1 API Gateway

AWS API Gateway sert de point d'entrée unique pour toutes les requêtes API, offrant :
- Gestion centralisée des requêtes
- Throttling pour limiter les abus
- Validation des requêtes
- Mise en cache des réponses fréquentes
- Logs et monitoring des appels API

#### 2.2.2 Services Backend (AWS Lambda)

Les services backend sont implémentés comme fonctions serverless sur AWS Lambda :

**Service Utilisateurs** :
- Gestion des profils utilisateurs
- Gestion des abonnements
- Vérification des quotas d'utilisation

**Service Projets** :
- Gestion des projets et dossiers
- Métadonnées des photos
- Organisation des collections

**Service Traitement d'Images** :
- Interface avec l'API OpenAI
- Prétraitement des images
- Application des préréglages
- Optimisation et post-traitement

**Service Analytics** :
- Collecte des métriques d'utilisation
- Reporting et dashboards
- Détection des anomalies

#### 2.2.3 Service d'authentification

Amazon Cognito est utilisé pour gérer l'authentification et l'autorisation :
- Inscription et connexion des utilisateurs
- Fédération d'identités (Google, Apple)
- Gestion des tokens JWT
- Contrôle des accès basé sur les rôles

### 2.3 Stockage de données

#### 2.3.1 Base de données

DynamoDB est utilisé comme base de données principale pour :
- Stockage des profils utilisateurs
- Métadonnées des projets et photos
- Configurations et préférences
- Suivi des limites d'utilisation

**Schéma simplifié** :
- Table `Users` : informations des utilisateurs
- Table `Projects` : organisation des projets
- Table `Photos` : métadonnées des photos
- Table `Subscriptions` : détails des abonnements

#### 2.3.2 Stockage d'objets

Amazon S3 est utilisé pour le stockage des fichiers :
- Bucket `original-photos` : photos originales
- Bucket `processed-photos` : photos traitées
- Bucket `thumbnails` : miniatures pour l'affichage rapide
- Bucket `exports` : exports haute résolution

**Cycle de vie des objets** :
- Suppression automatique des fichiers temporaires après 24h
- Archivage des photos non utilisées pendant 30 jours dans S3 Glacier
- Suppression des photos de comptes inactifs après notification

#### 2.3.3 CDN

Amazon CloudFront est utilisé comme CDN pour :
- Distribution globale des images traitées
- Réduction de la latence pour les utilisateurs internationaux
- Mise en cache des images fréquemment consultées
- Protection contre les attaques DDoS

## 3. Flux de données

### 3.1 Processus de traitement d'image

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

**Étapes détaillées** :
1. L'utilisateur sélectionne/prend une photo qui est compressée localement
2. La photo est envoyée au backend via l'API Gateway
3. Un service Lambda vérifie les droits et prépare l'image
4. La photo est envoyée à l'API OpenAI pour traitement
5. L'image améliorée est post-traitée et stockée dans S3
6. Des URLs signées sont générées pour l'accès via CloudFront
7. L'application affiche le résultat à l'utilisateur

### 3.2 Flux d'authentification

```
┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│ Application   │      │ API Gateway   │      │ Amazon        │
│ Mobile        │ ──► │               │ ──► │ Cognito       │
└───────┬───────┘      └───────────────┘      └───────┬───────┘
        │                                             │
        │ 1. Demande                                  │ 2. Vérification
        │    d'authentification                       │    identité
        │                                             │
        ▼                                             ▼
┌───────────────┐                            ┌───────────────┐
│ Application   │ ◄────────────────────────┐│ JWT Token     │
│ Mobile        │                           │ Généré         │
└───────┬───────┘                            └───────────────┘
        │
        │ 3. Stockage
        │    sécurisé du token
        │
        ▼
┌───────────────┐      ┌───────────────┐
│ Requêtes API  │ ──► │ Validation    │
│ avec token    │      │ du token      │
└───────────────┘      └───────────────┘
```

## 4. Sécurité de l'infrastructure

### 4.1 Sécurisation des données

- **En transit** : Toutes les communications utilisent TLS 1.3
- **Au repos** : Chiffrement des données dans S3 et DynamoDB
- **Clés API** : Stockage sécurisé dans AWS Secrets Manager
- **Accès applications** : Authentification multi-facteurs pour accès admin

### 4.2 Contrôles d'accès

- Principe du moindre privilège pour tous les rôles IAM
- Isolation des environnements (développement, test, production)
- Authentification via Cognito avec JWT pour toutes les API
- Autorisations basées sur les rôles (utilisateur, premium, admin)

### 4.3 Surveillance et logging

- Centralisation des logs dans CloudWatch
- Alertes configurées pour les comportements anormaux
- Audit trail pour toutes les actions administratives
- Scan de vulnérabilités automatisé sur les images de conteneurs

## 5. Haute disponibilité et reprise après sinistre

### 5.1 Stratégie de haute disponibilité

- Déploiement multi-AZ (zones de disponibilité) pour tous les services
- Équilibrage de charge automatique
- Mise à l'échelle automatique en fonction de la charge
- Surveillance proactive et auto-réparation

### 5.2 Plan de reprise après sinistre

| Composant | RPO (Objectif point de reprise) | RTO (Objectif temps de reprise) |
|-----------|----------------------------------|--------------------------------|
| Base de données | 15 minutes | 30 minutes |
| Stockage S3 | 0 (pas de perte) | Immédiat |
| Services backend | 0 (stateless) | 5 minutes |
| CDN | 0 (réplication) | Immédiat |

**Mesures implémentées** :
- Sauvegardes régulières multi-régions
- Réplication continue des données critiques
- Procédures de basculement automatisées
- Tests réguliers du plan de reprise

## 6. Environnements de déploiement

### 6.1 Environnements

L'infrastructure est déployée sur trois environnements distincts :

| Environnement | Objectif | Caractéristiques |
|---------------|----------|-----------------|
| Développement | Tests en cours de développement | Ressources minimales, données synthétiques |
| Pré-production | Tests d'intégration et UAT | Configuration identique à la production, données anonymisées |
| Production | Service aux utilisateurs réels | Haute disponibilité, sauvegardes, surveillance complète |

### 6.2 Stratégie de déploiement

PhotoListing utilise une approche CI/CD avec déploiement bleu-vert :

1. **Phase de construction** :
   - Déclenchée par push sur les branches principales
   - Tests automatisés (unitaires, intégration, e2e)
   - Création des packages d'application et images docker

2. **Phase de déploiement** :
   - Déploiement dans l'environnement cible
   - Tests de smoke post-déploiement
   - Basculement du trafic progressif (canary)

3. **Phase de validation** :
   - Surveillance des métriques post-déploiement
   - Procédure de rollback automatisé si anomalies
   - Validation manuelle finale pour production

```
┌───────────┐     ┌───────────┐     ┌───────────┐     ┌───────────┐
│  Commit   │ ──► │  Tests    │ ──► │  Build    │ ──► │ Deploy to │
│  Code     │     │  CI       │     │  Packages │     │ Dev/Test  │
└───────────┘     └───────────┘     └───────────┘     └─────┬─────┘
                                                            │
┌───────────┐     ┌───────────┐     ┌───────────┐     ┌─────▼─────┐
│ Analyse   │ ◄── │ Traffic   │ ◄── │ Canary    │ ◄── │ Deploy to │
│ Logs/Perf │     │ Shift 100%│     │ Release   │     │ Production│
└───────────┘     └───────────┘     └───────────┘     └───────────┘
```

## 7. Mise à l'échelle et performance

### 7.1 Stratégie de mise à l'échelle

- **Scaling horizontal** : Ajout automatique d'instances Lambda en fonction de la charge
- **Répartition régionale** : Points de présence CloudFront dans les régions principales
- **Optimisation des coûts** : Scaling à zéro pour les environnements hors production

### 7.2 Projections de charge

| Métrique | Charge attendue (lancement) | Charge maximale prévue |
|----------|---------------------------|------------------------|
| Utilisateurs actifs quotidiens | 1 000 | 50 000 |
| Photos traitées par jour | 5 000 | 250 000 |
| Stockage total (1ère année) | 500 GB | 10 TB |
| Requêtes API par seconde (pic) | 10 | 500 |

### 7.3 Optimisations de performance

- Mise en cache des images fréquemment consultées dans CloudFront
- Compression et optimisation systématique des images
- Génération de thumbnails pour affichage rapide des galeries
- Traitement par lots des requêtes OpenAI pendant les heures creuses

## 8. Coûts et optimisation des ressources

### 8.1 Estimation des coûts mensuels

| Composant | Coût estimé (lancement) | Coût estimé (échelle) |
|-----------|------------------------|----------------------|
| AWS Lambda | $50 - $100 | $500 - $1 000 |
| Amazon S3 | $20 - $50 | $200 - $500 |
| DynamoDB | $50 - $100 | $300 - $700 |
| CloudFront | $30 - $70 | $200 - $500 |
| API Gateway | $20 - $50 | $100 - $300 |
| OpenAI API | $500 - $1 000 | $5 000 - $10 000 |
| **Total** | **$670 - $1 370** | **$6 300 - $13 000** |

### 8.2 Stratégies d'optimisation des coûts

- Utilisation de Reserved Instances pour les services de base
- Compression agressive des images pour réduire les coûts de stockage
- Mise en cache intelligente pour réduire les appels API
- Politique de cycle de vie S3 pour archiver/supprimer les données anciennes
- Limites d'utilisation sur les forfaits gratuits

## 9. Outils de monitoring et observabilité

### 9.1 Monitoring de l'infrastructure

- **CloudWatch** : Surveillance des métriques des services AWS
- **X-Ray** : Traçage des requêtes distribuées
- **Datadog** : Monitoring complémentaire et tableaux de bord

### 9.2 Monitoring des applications

- **Firebase Crashlytics** : Suivi des crashs sur mobile
- **Sentry** : Détection et analyse des erreurs
- **AppDynamics** : Mesure des performances utilisateur

### 9.3 Alertes et notifications

- Alertes sur seuils de performance (latence, charge)
- Notifications d'erreurs critiques via email et Slack
- Rapports quotidiens sur l'utilisation des ressources
- Détection proactive des anomalies

## 10. Plan de déploiement et migration

### 10.1 Déploiement initial

1. **Phase 1** (Semaine 1-2) : Infrastructure de base
   - Configuration des comptes et permissions AWS
   - Déploiement des services basiques (S3, DynamoDB)
   - Mise en place des pipelines CI/CD

2. **Phase 2** (Semaine 3-4) : Services backend
   - Déploiement des fonctions Lambda
   - Configuration de l'API Gateway
   - Intégration avec OpenAI

3. **Phase 3** (Semaine 5-6) : Applications clientes
   - Déploiement des applications mobiles en bêta
   - Configuration des analytics et monitoring
   - Tests de charge

4. **Phase 4** (Semaine 7-8) : Go-live
   - Migration des données de test
   - Basculement de DNS
   - Activation des systèmes de paiement

### 10.2 Stratégie de mise à jour

- Déploiements automatisés via CI/CD
- Déploiements sans temps d'arrêt (zero-downtime)
- Versionnement sémantique des API
- Support de N-1 versions des applications clientes