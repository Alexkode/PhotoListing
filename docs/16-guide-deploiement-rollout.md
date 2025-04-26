# Guide de Déploiement & Roll-out

## Résumé Exécutif

Ce document définit la stratégie de déploiement et de mise en production de l'application PhotoListing. Il couvre les procédures pour garantir une livraison fiable, sécurisée et contrôlée des nouvelles versions de l'application sur les plateformes Android et iOS.

## 1. Cycle de Vie du Déploiement

### 1.1 Vue d'Ensemble du Processus

```
[Développement] → [Test Interne] → [Alpha] → [Beta] → [Production Limitée] → [Production Complète]
```

### 1.2 Environnements et Phases

| Phase | Environnement | Audience | Durée | Objectifs |
|-------|---------------|----------|-------|-----------|
| Développement | DEV | Équipe technique | Continu | Implémentation des fonctionnalités |
| Test Interne | TEST | QA + Équipe produit | 1-3 jours | Tests fonctionnels, stabilité |
| Alpha | STAGING | Équipe élargie | 2-5 jours | Tests utilisateurs internes |
| Beta | PRE-PROD | Utilisateurs externes (limité) | 1-2 semaines | Feedback, tests réels |
| Production Limitée | PROD | 5-10% des utilisateurs | 1-3 jours | Monitoring, impact réel |
| Production Complète | PROD | 100% des utilisateurs | - | Distribution générale |

### 1.3 Critères de Progression

| Transition | Critères |
|------------|----------|
| DEV → TEST | • Code review complété<br>• Tests unitaires passants<br>• Build stable |
| TEST → ALPHA | • Tests fonctionnels passants<br>• Aucun bug bloquant<br>• Validation QA |
| ALPHA → BETA | • Validation produit<br>• Tests de non-régression réussis<br>• Documentation mise à jour |
| BETA → PROD LIMITÉE | • Métriques de stabilité acceptables<br>• Feedback beta positif<br>• Go de l'équipe produit |
| PROD LIMITÉE → PROD COMPLÈTE | • Aucune régression observée<br>• Métriques de performance stables<br>• Taux d'erreur < 0.5% |

## 2. Stratégie de Versionnement

### 2.1 Numérotation Sémantique (SemVer)

Format: `MAJEUR.MINEUR.CORRECTIF` (e.g., 1.2.3)

- **MAJEUR**: Changements incompatibles avec les versions précédentes
- **MINEUR**: Nouvelles fonctionnalités rétro-compatibles
- **CORRECTIF**: Corrections de bugs rétro-compatibles

### 2.2 Numéros de Build

- Android: `versionCode` incrémenté à chaque build
- iOS: `CFBundleVersion` incrémenté à chaque build
- Format: `<VERSION>.<TIMESTAMP>.<COMMIT_HASH>` (e.g., 1.2.3.20230615.a3b4c5)

### 2.3 Branches et Tags

| Type | Convention | Exemple |
|------|------------|---------|
| Feature | feature/JIRA-ID-description | feature/PL-123-photo-filters |
| Release | release/VERSION | release/1.2.0 |
| Hotfix | hotfix/VERSION-description | hotfix/1.2.1-crash-fix |
| Tag | v{VERSION} | v1.2.3 |

## 3. Infrastructures de Déploiement

### 3.1 Plateformes de Distribution

#### Android
- **Test Interne**: Firebase App Distribution
- **Alpha/Beta**: Google Play Console (Track interne/alpha/beta)
- **Production**: Google Play Store

#### iOS
- **Test Interne**: TestFlight (Builds internes)
- **Alpha/Beta**: TestFlight (Groupes externes)
- **Production**: App Store

### 3.2 Outils de CI/CD

- **Intégration Continue**: GitHub Actions / Bitrise
- **Livraison Continue**: Fastlane
- **Gestion des Certificats**: Fastlane Match
- **Monitoring de Déploiement**: Firebase Crashlytics

### 3.3 Infrastructure Cloud

- **Hébergement API**: Google Cloud Run / AWS ECS
- **Stockage Images**: Google Cloud Storage / AWS S3
- **CDN**: Cloudflare / Akamai
- **Base de Données**: MongoDB Atlas / Firebase Firestore

## 4. Procédures de Déploiement Mobile

### 4.1 Préparation du Release

#### Checklist pré-release
- [ ] Vérification du numéro de version
- [ ] Mise à jour des notes de version
- [ ] Validation du changelog
- [ ] Revue des analytics et feature flags
- [ ] Mise à jour des assets marketing (screenshots, vidéos)
- [ ] Tests de régression complétés
- [ ] Validation des endpoints API

#### Scripts de build

```bash
# Exemple Fastlane pour iOS
lane :beta do
  increment_build_number
  build_app(scheme: "PhotoListing")
  upload_to_testflight
end

# Exemple Fastlane pour Android
lane :beta do
  increment_version_code
  gradle(task: "clean assembleRelease")
  upload_to_play_store(track: 'beta')
end
```

### 4.2 Signatures et Certificats

#### Android
- Keystore pour signature d'app stocké dans un coffre-fort sécurisé
- Rotation du keystore chaque année
- Google Play App Signing activé

#### iOS
- Certificats gérés via Fastlane Match
- Distribution via profil de provisionnement Enterprise
- Stockage sécurisé des certificats dans un gestionnaire de secrets

### 4.3 Déploiement Progressif (Phased Rollout)

#### Android
```
Play Store: 5% → 20% → 50% → 100%
```

- Phases de 24-48h selon les métriques
- Surveillance active entre les phases
- Possibilité de pause/rollback à chaque phase

#### iOS
```
App Store: "Manual Release" → "Phased Release" (1 semaine)
```

- TestFlight pour validation pré-App Store
- Soumission manuelle pour revue Apple
- Release progressif sur 7 jours (automatique)

## 5. Déploiement des Services Backend

### 5.1 Procédure de Déploiement API

#### Stratégie Blue-Green
1. Déploiement de la nouvelle version (Green)
2. Tests santé et smoke tests
3. Bascule progressive du trafic (10% → 50% → 100%) 
4. Surveillance, puis décommissionnement de l'ancienne version (Blue)

```bash
# Exemple avec Google Cloud Run
gcloud run deploy photolisting-api \
  --image gcr.io/photolisting/api:v1.2.3 \
  --platform managed \
  --region europe-west1 \
  --tag v1-2-3 \
  --no-traffic
  
# Bascule progressive du trafic
gcloud run services update-traffic photolisting-api \
  --to-tags v1-2-3=10
```

### 5.2 Migration de Base de Données

1. Backup complet pré-migration
2. Scripts de migration versionnés et testés
3. Application des modifications en mode maintenance réduite
4. Validation post-migration (data integrity)
5. Période d'observation avec rollback possible

```javascript
// Exemple de script de migration MongoDB
db.photos.updateMany(
  { processed: { $exists: false } },
  { $set: { processed: false, processingVersion: "1.2.3" } }
)
```

### 5.3 CDN et Assets Statiques

- Versionnement des assets dans les URLs
- Cache-busting via query parameters ou hashes
- Invalidation sélective du cache CDN
- Pré-réchauffage du cache pour les assets critiques

```bash
# Invalidation CloudFront
aws cloudfront create-invalidation \
  --distribution-id EDFDVBD6EXAMPLE \
  --paths "/static/js/*" "/static/css/*"
```

## 6. Feature Flags et Déploiement Conditionnel

### 6.1 Architecture des Feature Flags

- Système centralisé (Firebase Remote Config / LaunchDarkly)
- Segmentation par groupe d'utilisateurs
- Override possible pour le debugging
- TTL et nettoyage automatique des flags obsolètes

```kotlin
// Exemple d'implémentation Android
class FeatureFlagManager {
    private val remoteConfig = FirebaseRemoteConfig.getInstance()
    
    fun isFeatureEnabled(feature: Feature, defaultValue: Boolean = false): Boolean {
        return remoteConfig.getBoolean(feature.key) || defaultValue
    }
    
    fun refreshFlags(onComplete: () -> Unit) {
        remoteConfig.fetchAndActivate().addOnCompleteListener {
            onComplete()
        }
    }
}

enum class Feature(val key: String) {
    NEW_PHOTO_FILTERS("feature_new_photo_filters"),
    AI_ENHANCEMENT("feature_ai_enhancement"),
    VIRTUAL_STAGING("feature_virtual_staging")
}
```

### 6.2 Tests A/B

- Configuration via Firebase A/B Testing
- Métriques de conversion définies par feature
- Durée des tests entre 2-4 semaines
- Analyse statistique des résultats avant généralisation

### 6.3 Killswitch d'Urgence

- Mécanisme de désactivation rapide des fonctionnalités
- Configuration côté serveur avec cache local
- Vérification au démarrage et via polling
- Circuit breaker pour les services instables

```swift
// Exemple d'implémentation iOS
class FeatureKillswitch {
    static let shared = FeatureKillswitch()
    private var disabledFeatures: Set<String> = []
    
    func refreshKillswitches() {
        apiClient.getKillswitches { [weak self] response in
            guard let self = self else { return }
            self.disabledFeatures = Set(response.disabledFeatures)
        }
    }
    
    func isFeatureDisabled(_ feature: Feature) -> Bool {
        return disabledFeatures.contains(feature.rawValue)
    }
}
```

## 7. Tests et Validation

### 7.1 Tests Pré-déploiement

| Type de Test | Environnement | Responsable | Fréquence |
|--------------|---------------|-------------|-----------|
| Tests Unitaires | CI | Développeurs | Chaque commit |
| Tests d'Intégration | CI/TEST | QA | Chaque PR |
| Tests E2E | TEST | QA | Chaque release |
| Tests de Régression | TEST/ALPHA | QA | Chaque release |
| Tests de Performance | TEST | SRE | Chaque release majeure |
| Tests de Sécurité | TEST | Sécurité | Mensuel + release majeure |

### 7.2 Smoke Tests Post-déploiement

Vérification rapide des fonctionnalités critiques après déploiement:

1. Inscription/Connexion
2. Import de photos
3. Traitement d'image
4. Partage et export
5. Paiements et abonnements

### 7.3 Canary Testing

- Déploiement sur un sous-ensemble d'utilisateurs (1%)
- Monitoring intensif pendant 24-48h
- Seuils de rollback prédéfinis
- Promotion automatique si métriques acceptables

## 8. Monitoring et Alerting

### 8.1 Métriques Critiques

| Métrique | Seuil | Action |
|----------|-------|--------|
| Crash Rate | > 1% | Rollback |
| ANR Rate | > 0.5% | Investigation |
| API Error Rate | > 2% | Alerte |
| Processing Time | > 5s | Alerte |
| Upload Success | < 95% | Investigation |
| DAU Drop | > 10% | Alerte |

### 8.2 Dashboard de Déploiement

- Vue temps réel des KPIs
- Comparaison avec version précédente
- Distribution des versions actives
- Alertes et incidents en cours
- Historique des déploiements

### 8.3 Intégration Slack/Teams

- Notifications automatiques de déploiement
- Alertes sur seuils dépassés
- Rapport quotidien de stabilité
- Canal dédié aux incidents

```bash
# Exemple d'intégration Slack dans GitHub Actions
- name: Notify Slack on Release
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    fields: repo,message,commit,author,action,eventName,workflow
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
  if: always()
```

## 9. Rollback et Gestion des Incidents

### 9.1 Procédure de Rollback

#### Mobile (Android)
1. Halte de la distribution dans Play Console
2. Retour à la version précédente (promotion de version)
3. Communication aux utilisateurs si nécessaire
4. Post-mortem et correctifs

#### Mobile (iOS)
1. Halte de la distribution dans App Store Connect
2. Soumission d'une nouvelle build (version ancienne)
3. Demande d'expedited review à Apple
4. Communication aux utilisateurs

#### Backend
1. Bascule du trafic vers la version stable
2. Vérification des données et migrations
3. Restauration des données si nécessaire
4. Post-mortem et correctifs

### 9.2 Gestion des Incidents

#### Niveaux de Sévérité
- **P0**: Application inutilisable pour tous les utilisateurs
- **P1**: Fonctionnalité critique inutilisable pour tous
- **P2**: Fonctionnalité importante dégradée
- **P3**: Problème mineur affectant certains utilisateurs

#### Workflow d'Incident
1. **Détection**: Alertes automatiques ou signalement
2. **Triage**: Évaluation d'impact et classification
3. **Communication**: Notification des parties prenantes
4. **Mitigation**: Mesures temporaires
5. **Résolution**: Correction permanente
6. **Post-mortem**: Analyse et prévention

### 9.3 Communication en Cas d'Incident

| Sévérité | Canaux | Fréquence | Responsable |
|----------|--------|-----------|-------------|
| P0 | Slack, Email, In-App | 1h | CTO |
| P1 | Slack, Email, In-App | 2h | Lead Dev |
| P2 | Slack, Dashboard | 4h | PM |
| P3 | Dashboard | Daily | QA |

## 10. Déploiement des Mises à Jour Critiques

### 10.1 Hotfixes

- Branche depuis le tag de production
- Tests ciblés sur la correction
- CI/CD accélérée
- Revue de code par 2 seniors minimum
- Déploiement prioritaire

```bash
# Workflow Git pour hotfix
git checkout -b hotfix/1.2.1-crash-fix v1.2.0
# Correctifs...
git commit -m "fix: résolution du crash lors du traitement d'image #PL-500"
git tag v1.2.1
git push origin v1.2.1
```

### 10.2 Mises à Jour de Sécurité

- Procédure accélérée de validation
- Documentation précise des vulnérabilités (CVE)
- Notification aux partenaires si nécessaire
- Rapport post-déploiement

### 10.3 Force Update

Implementation de mécanismes pour forcer la mise à jour:

#### Android
```kotlin
// Vérification de version minimale requise
class MinimumVersionChecker {
    suspend fun checkMinimumVersion(): UpdateStatus {
        val minVersion = apiClient.getMinimumAppVersion()
        val currentVersion = BuildConfig.VERSION_CODE
        
        return when {
            currentVersion < minVersion.critical -> UpdateStatus.MANDATORY
            currentVersion < minVersion.recommended -> UpdateStatus.RECOMMENDED
            else -> UpdateStatus.UP_TO_DATE
        }
    }
}
```

#### iOS
```swift
// Vérification de version minimale requise
class MinimumVersionChecker {
    func checkMinimumVersion(completion: @escaping (UpdateStatus) -> Void) {
        apiClient.getMinimumAppVersion { [weak self] result in
            guard let minVersion = try? result.get() else {
                completion(.UP_TO_DATE)
                return
            }
            
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
            
            if self?.compareVersions(currentVersion, minVersion.critical) == .orderedAscending {
                completion(.MANDATORY)
            } else if self?.compareVersions(currentVersion, minVersion.recommended) == .orderedAscending {
                completion(.RECOMMENDED)
            } else {
                completion(.UP_TO_DATE)
            }
        }
    }
    
    private func compareVersions(_ v1: String, _ v2: String) -> ComparisonResult {
        return v1.compare(v2, options: .numeric)
    }
}
```

## 11. Documentation et Apprentissage

### 11.1 Documentation de Déploiement

- Runbook détaillé pour chaque environnement
- Diagrammes d'architecture de déploiement
- Procédures de rollback documentées
- Matrice RACI pour les décisions de déploiement

### 11.2 Post-mortems

Format structuré:
1. Chronologie de l'incident
2. Impact utilisateur et technique
3. Cause racine
4. Résolution
5. Leçons apprises
6. Actions préventives

### 11.3 Knowledge Base

- Wiki technique maintenu à jour
- Historique des incidents et résolutions
- FAQ pour les problèmes courants
- Procédures de troubleshooting

## 12. Roadmap d'Amélioration Continue

### 12.1 Court Terme (1-3 mois)

- Automatisation des smoke tests post-déploiement
- Amélioration des dashboards de surveillance
- Documentation complète des procédures de rollback

### 12.2 Moyen Terme (3-6 mois)

- Migration vers une infrastructure GitOps
- Implémentation de déploiements canary automatisés
- Amélioration des mécanismes de feature flags

### 12.3 Long Terme (6-12 mois)

- CI/CD entièrement automatisée jusqu'à la production
- Tests de chaos pour la résilience
- Observabilité complète de l'infrastructure

## Annexes

### A. Checklist de Déploiement

#### Pré-déploiement
- [ ] Revue de code complétée
- [ ] Tests automatisés passants
- [ ] Numéro de version incrémenté
- [ ] Notes de version rédigées
- [ ] Assets mis à jour
- [ ] Feature flags configurés
- [ ] Documentation technique mise à jour

#### Déploiement
- [ ] Notification de début de déploiement
- [ ] Backup des données critiques
- [ ] Exécution des scripts de déploiement
- [ ] Vérification des logs de déploiement
- [ ] Lancement des smoke tests

#### Post-déploiement
- [ ] Vérification des métriques de santé
- [ ] Confirmation de fonctionnement des features clés
- [ ] Notification de fin de déploiement
- [ ] Monitoring sur 24h
- [ ] Rétroaction de l'équipe produit

### B. Modèles de Communication

#### Notification de Déploiement
```
📱 DÉPLOIEMENT v1.2.3 - PhotoListing

Timing: 2023-06-15 14:00-16:00 CEST
Impact: Indisponibilité possible de 5-10 minutes
Nouvelles fonctionnalités:
- Filtres AI pour photos intérieures
- Amélioration de la compression des images
- Performance upload optimisée

Contact: @tech-lead (Slack)
```

#### Notification d'Incident
```
🚨 INCIDENT #123 - P1 - PhotoListing

Statut: En cours d'investigation
Impact: Processing des photos échoue (30% des utilisateurs)
Actions: Analyse logs + rollback en préparation
ETA: ~60 minutes
Updates: Canal #incidents / 30min

Contact: @on-call (Slack)