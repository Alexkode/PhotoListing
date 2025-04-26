# Roadmap & Gestion de Version

## Résumé Exécutif

Ce document définit la stratégie de roadmap produit et la gestion des versions pour l'application PhotoListing. Il présente la vision à court, moyen et long terme du produit, établit les priorités de développement, et détaille les processus de planification et de livraison des nouvelles fonctionnalités.

## 1. Vision Produit & Objectifs Stratégiques

### 1.1 Vision à 3 Ans

PhotoListing vise à devenir **la référence incontournable en matière d'amélioration automatisée de photos immobilières** pour les agents immobiliers et hôtes de locations saisonnières. Notre plateforme permettra à tout professionnel de l'immobilier de créer des visuels de qualité professionnelle en quelques clics, sans nécessiter de compétences techniques en photographie ou en retouche d'image.

### 1.2 Objectifs Stratégiques

| Horizon | Objectif | KPI de Réussite |
|---------|----------|-----------------|
| 1 an | Établir la base utilisateurs | 100 000 utilisateurs actifs mensuels |
| 1 an | Démontrer la valeur | Taux de rétention à 30 jours > 40% |
| 2 ans | Expansion marché | Présence dans 10 pays clés |
| 2 ans | Monétisation efficace | LTV > 3x CAC |
| 3 ans | Intégration écosystème | Partenariats avec 5 plateformes immobilières majeures |
| 3 ans | Diversification | 30% des revenus hors retouche photo standard |

### 1.3 Proposition de Valeur

- **Pour les agents immobiliers**: Économisez des milliers d'euros en frais de photographe tout en proposant des visuels de qualité professionnelle qui accélèrent les ventes/locations.
- **Pour les hôtes Airbnb**: Augmentez vos taux de réservation de 30%+ grâce à des photos attractives et cohérentes sans investir dans un équipement coûteux.
- **Pour les gestionnaires multi-propriétés**: Traitez des centaines de photos rapidement avec une qualité constante et une identité visuelle uniforme.

## 2. Roadmap Produit

### 2.1 Structure de la Roadmap

Notre roadmap est organisée en quatre horizons:

- **Now** (trimestre en cours): Fonctionnalités en développement actif
- **Next** (trimestre suivant): Fonctionnalités planifiées et spécifiées
- **Later** (6-12 mois): Initiatives prioritaires à moyen terme
- **Future** (12+ mois): Vision à long terme

### 2.2 Roadmap Actuelle

#### Now (T3 2023)
- **Retouche IA avancée**
  - Correction automatique de perspective
  - Amélioration de luminosité HDR
  - Suppression intelligente d'objets indésirables
- **Performance et stabilité**
  - Optimisation du temps de traitement (-50%)
  - Réduction des crashs sur grands volumes
  - Mode hors-ligne pour édition basique
- **Analytics utilisateur**
  - Dashboard de performance des annonces
  - Statistiques d'engagement par photo
  - Recommandations d'amélioration

#### Next (T4 2023)
- **Visites virtuelles 360°**
  - Création à partir de photos standard
  - Édition et personnalisation
  - Export vers plateformes immobilières
- **Collaboration d'équipe**
  - Partage de projets et photos
  - Commentaires et annotations
  - Rôles et permissions
- **Intégration directe SeLoger/LeBonCoin**
  - Upload automatique vers les plateformes
  - Synchronisation des modifications
  - Suivi des performances par plateforme

#### Later (S1 2024)
- **Staging virtuel**
  - Ajout de meubles virtuels dans les pièces vides
  - Styles prédéfinis (moderne, classique, etc.)
  - Adaptation automatique à l'espace
- **IA générative pour descriptions**
  - Génération de textes descriptifs à partir des photos
  - Adaptation au style de l'agent
  - Multi-langues
- **Application desktop**
  - Traitement par lots
  - Intégration workflow pro
  - Performance native

#### Future (S2 2024+)
- **Plans 2D/3D automatiques**
  - Génération de plans d'étage à partir de photos
  - Mesures approximatives
  - Navigation interactive
- **Marketplace de prestataires**
  - Mise en relation avec photographes
  - Services de home staging
  - Création de contenu sur mesure
- **API pour intégration tierce**
  - Webhook pour automatisation
  - SDK pour développeurs
  - Marketplace d'extensions

### 2.3 Grille de Priorisation

Nos critères de priorisation avec leur poids relatif:

| Critère | Poids | Description |
|---------|-------|-------------|
| Impact utilisateur | 30% | Valeur ajoutée pour les utilisateurs existants |
| Potentiel d'acquisition | 25% | Capacité à attirer de nouveaux utilisateurs |
| Effort technique | 20% | Complexité et ressources nécessaires |
| Différenciation | 15% | Avantage concurrentiel créé |
| Monétisation | 10% | Potentiel de génération de revenus |

#### Matrice RICE

Pour chaque initiative, nous calculons un score RICE:

```
RICE = (Reach × Impact × Confidence) ÷ Effort
```

Où:
- **Reach**: Nombre d'utilisateurs impactés par trimestre
- **Impact**: Score de 1 (minimal) à 3 (transformationnel)
- **Confidence**: Pourcentage de certitude (0.5, 0.8, 1)
- **Effort**: Estimation en personne-semaines

## 3. Gestion des Versions

### 3.1 Stratégie de Versionnement

Nous utilisons le versionnement sémantique (SemVer) sous le format: `MAJEUR.MINEUR.CORRECTIF`

- **MAJEUR**: Changements incompatibles, refonte d'expérience
- **MINEUR**: Nouvelles fonctionnalités rétrocompatibles
- **CORRECTIF**: Corrections de bugs et améliorations mineures

### 3.2 Cycle de Release

![Cycle de Release](https://via.placeholder.com/800x300?text=Cycle+de+Release)

#### Planning de Releases

| Type de Release | Fréquence | Contenu | Validation |
|-----------------|-----------|---------|------------|
| Majeure (x.0.0) | Trimestrielle | Nouvelles fonctionnalités significatives | Beta complète + UAT |
| Mineure (x.y.0) | Mensuelle | Améliorations et fonctionnalités | Tests QA complets |
| Correction (x.y.z) | Bi-hebdomadaire | Bugs fixes et optimisations | Tests ciblés |
| Hotfix | Si nécessaire | Correction critique | Validation rapide |

### 3.3 Gestion des Branches

Notre workflow Git suit le modèle Gitflow:

```
main ──────────────────────────────────────────────────────
 │                         │                    │
 │                         │                    │
 ↓                         ↓                    ↓
release/1.0 ───────→ release/1.1 ───────→ release/2.0
 │       │            │       │            │       │
 │       │            │       │            │       │
 │       ↓            │       ↓            │       ↓
 │   hotfix/1.0.1     │   hotfix/1.1.1     │   hotfix/2.0.1
 │       │            │       │            │       │
 ↓       │            ↓       │            ↓       │
develop ←┘            │       │            │       │
 │ │ │                │       │            │       │
 │ │ │                │       │            │       │
 ↓ ↓ ↓                ↓       ↓            ↓       ↓
feature branches      │       │            │       │
                      ↓       ↓            ↓       ↓
                    main ─────────────────────────────────
```

#### Conventions de Nommage
- Feature branches: `feature/{jira-id}-{description-brève}`
- Release branches: `release/{version}`
- Hotfix branches: `hotfix/{version}-{description}`

#### Politique de Merge
- Feature → Develop: Pull Request + 1 revue
- Develop → Release: Après QA et stabilisation
- Release → Main: Après validation complète
- Hotfix → Main + Develop: Après validation d'urgence

### 3.4 Feature Flags

Utilisation de feature flags pour:
- Déploiement progressif de fonctionnalités
- Tests A/B
- Activation/désactivation d'urgence
- Personnalisation par segment d'utilisateurs

```javascript
// Exemple d'implémentation
const features = {
  ADVANCED_RETOUCHING: {
    enabled: true,
    rolloutPercentage: 100,
    enabledForGroups: ['premium', 'beta']
  },
  VIRTUAL_STAGING: {
    enabled: true,
    rolloutPercentage: 25,
    enabledForGroups: ['beta']
  }
};

function isFeatureEnabled(featureKey, user) {
  const feature = features[featureKey];
  if (!feature || !feature.enabled) return false;
  
  // Check user groups
  if (user.groups.some(g => feature.enabledForGroups.includes(g))) {
    return true;
  }
  
  // Check rollout percentage
  const userHash = hashUserId(user.id);
  return (userHash % 100) < feature.rolloutPercentage;
}
```

## 4. Processus de Planification

### 4.1 Rythme et Cérémonies

#### Planification Trimestrielle (Quarterly Planning)
- **Participants**: Direction produit, Leads tech, Marketing, CS
- **Durée**: 1 journée
- **Fréquence**: Trimestrielle
- **Livrables**: Objectifs du trimestre, Plan de release majeure

#### Planification de Sprint
- **Participants**: Équipe produit et développement
- **Durée**: 2-3 heures
- **Fréquence**: Toutes les 2 semaines
- **Livrables**: Sprint backlog, Estimations

#### Revue de Sprint
- **Participants**: Équipe produit, stakeholders
- **Durée**: 1 heure
- **Fréquence**: Toutes les 2 semaines
- **Livrables**: Démo des fonctionnalités, Feedback

#### Rétrospective
- **Participants**: Équipe produit et développement
- **Durée**: 1 heure
- **Fréquence**: Toutes les 2 semaines
- **Livrables**: Points d'amélioration, Action items

### 4.2 Processus d'Intake

![Processus d'Intake](https://via.placeholder.com/800x400?text=Processus+Intake)

1. **Collecte des idées**
   - Sources: Feedback utilisateurs, Équipe produit, Analyse concurrentielle
   - Outil: Jira/ProductBoard
   - Fréquence: Continue

2. **Qualification**
   - Critères: Alignement stratégique, Faisabilité, Intérêt utilisateur
   - Responsable: Product Manager
   - Output: Backlog priorisé

3. **Spécification**
   - Format: Product Requirements Document (PRD)
   - Contenu: User stories, Critères d'acceptation, Design
   - Validation: Équipe technique, Design, QA

4. **Planification**
   - Estimation: Planning poker
   - Affectation: Sprint planning
   - Suivi: Tableau Kanban

### 4.3 Framework de Décision

Pour les décisions produit importantes, nous utilisons le framework DACI:

- **Driver**: Responsable du processus de décision (Product Manager)
- **Approver**: Détient l'autorité finale (CPO/CTO)
- **Contributors**: Fournissent input et expertise (Design, Développement, Marketing)
- **Informed**: Informés de la décision (Équipe élargie)

Exemple de matrice DACI pour la fonctionnalité "Visite virtuelle 360°":

| Rôle | Personne(s) |
|------|-------------|
| Driver | Marie D. (PM) |
| Approver | Thomas L. (CPO) |
| Contributors | Sophie R. (Design), Lucas M. (Tech Lead), Emma F. (Marketing) |
| Informed | Équipe développement, CS, Ventes |

## 5. Développement et Livraison

### 5.1 Méthodologie de Développement

Nous suivons une approche Agile/Scrum avec:
- Sprints de 2 semaines
- Daily standup à 10h
- Développement basé sur les tâches (task-based)
- Intégration continue (CI/CD)

### 5.2 Definition of Ready (DoR)

Une User Story est prête à être développée quand:
- Elle est clairement définie et comprise par l'équipe
- Les critères d'acceptation sont spécifiés
- Les maquettes/designs sont prêts et validés
- Les dépendances techniques sont identifiées
- L'effort est estimé
- La valeur business est claire

### 5.3 Definition of Done (DoD)

Une User Story est considérée comme terminée quand:
- Le code est écrit et respecte les standards
- Les tests unitaires et d'intégration sont écrits et passants
- Le code a été revu (code review)
- La documentation est mise à jour
- Les critères d'acceptation sont validés par QA
- La fonctionnalité est déployable en production

### 5.4 Processus de Release

![Processus de Release](https://via.placeholder.com/800x300?text=Processus+Release)

#### Checklist de Release

**Pré-release**
- [ ] Tests de régression complétés
- [ ] Documentation utilisateur mise à jour
- [ ] Notes de release rédigées
- [ ] Marketing informé
- [ ] Support formé
- [ ] Analyse de performance de base

**Release**
- [ ] Déploiement progressif (par phases)
- [ ] Monitoring des métriques clés
- [ ] Astreinte technique organisée
- [ ] Communication utilisateurs

**Post-release**
- [ ] Analyse d'impact (24h/72h/7j)
- [ ] Collecte de feedback
- [ ] Résolution des problèmes identifiés
- [ ] Rétrospective de release

## 6. Suivi et Communication

### 6.1 Outils de Gestion

| Outil | Usage | Utilisateurs |
|-------|-------|--------------|
| Jira | Backlog, Sprints, Epics | Équipe produit/dev |
| ProductBoard | Roadmap, Feedback | Product, Management |
| Figma | Design, Prototypage | Design, Product |
| GitHub | Code, Pull Requests | Développement |
| Confluence | Documentation | Toute l'entreprise |
| Slack | Communication quotidienne | Toute l'entreprise |

### 6.2 Reporting et Métriques

#### Métriques Produit
- **Engagement**: DAU/MAU, sessions par utilisateur, temps passé
- **Adoption**: % utilisateurs par fonctionnalité
- **Performance**: temps de traitement, taux d'erreur
- **Satisfaction**: NPS, CSAT, App Store ratings

#### Communication du Progrès
- **Daily**: Mise à jour Slack automatique
- **Weekly**: Sprint progress report
- **Monthly**: Product metrics dashboard
- **Quarterly**: Business review, Roadmap update

### 6.3 Templates de Communication

#### Annonce de Nouvelle Fonctionnalité

```
📢 Nouvelle fonctionnalité: [Nom de la fonctionnalité]

Nous sommes ravis de vous présenter [Nom], disponible dès aujourd'hui dans PhotoListing v[X.Y.Z].

🔍 Ce que ça fait:
- Point clé 1
- Point clé 2
- Point clé 3

💡 Comment l'utiliser:
[Instructions simples ou lien vers documentation]

📈 Résultats attendus:
[Bénéfices pour l'utilisateur]

Nous avons hâte de connaître votre avis! Partagez vos retours via le bouton "Feedback" dans l'app.
```

#### Notes de Version (Release Notes)

```
# PhotoListing v2.1.0

## 🌟 Nouvelles fonctionnalités
- **Visites virtuelles 360°**: Créez des visites immersives en quelques clics
- **Export multi-plateformes**: Publiez directement sur Airbnb, Booking et Abritel
- **Analyses avancées**: Découvrez quelles photos génèrent le plus d'intérêt

## 🔧 Améliorations
- Temps de traitement réduit de 30%
- Interface de sélection de photos repensée
- Suggestions intelligentes basées sur le type de propriété

## 🐞 Corrections
- Résolution du problème de synchronisation sur iOS 16
- Correction des crashs lors du traitement de plus de 100 photos
- Amélioration de la stabilité en connexion lente

## 📝 Remarques
- Cette mise à jour nécessite iOS 14+ / Android 9+
- Pour profiter des visites virtuelles, un abonnement Premium est requis
```

## 7. Gestion du Feedback

### 7.1 Sources de Feedback

| Source | Type | Fréquence | Traitement |
|--------|------|-----------|------------|
| App Store / Play Store | Ratings & reviews | Quotidien | CS + Product |
| Support client | Tickets, chats | Continu | CS → Product |
| Interviews utilisateurs | Qualitatif | Bi-mensuel | Product |
| Sondages in-app | Quantitatif | Mensuel | Product + Data |
| Analytics | Comportemental | Continu | Data + Product |
| Partenaires | Stratégique | Trimestriel | Management |

### 7.2 Processus de Feedback Loop

```
Collecte → Analyse → Priorisation → Action → Validation → Communication
```

#### Collecte Centralisée
Tous les feedbacks sont centralisés dans ProductBoard avec tagging:
- Source (App Store, Support, etc.)
- Segment utilisateur (Free, Pro, Enterprise)
- Fonctionnalité concernée
- Sentiment (Positif, Négatif, Neutre)
- Urgence (Critique, Important, Nice-to-have)

#### Analyse et Action
- **Weekly**: Revue des feedbacks critiques
- **Bi-weekly**: Intégration dans le backlog sprint
- **Monthly**: Analyse des tendances
- **Quarterly**: Impact sur roadmap

### 7.3 Boucle d'Amélioration Continue

![Boucle d'Amélioration](https://via.placeholder.com/800x400?text=Boucle+Amelioration)

1. **Hypothèse**: Définir l'amélioration et le résultat attendu
2. **Build**: Développer l'amélioration (MVP)
3. **Mesure**: Collecter les données d'utilisation
4. **Apprentissage**: Analyser les résultats
5. **Itération**: Affiner ou pivoter

## 8. Stratégie à Long Terme

### 8.1 Innovations Futures

#### Intelligence Artificielle Avancée
- **2024**: IA générative pour compléter les espaces vides
- **2025**: Reconstruction 3D complète à partir de photos standard
- **2025**: Personnalisation basée sur les préférences du marché local

#### Expansion Produit
- **2024 Q3**: Version Web complète
- **2025 Q1**: API publique et marketplace d'extensions
- **2025 Q4**: Suite complète d'outils marketing immobilier

#### Expansion Marché
- **2024**: Adaptation aux marchés DACH et UK
- **2025**: Expansion Amérique du Nord
- **2026**: Marchés asiatiques clés (Japon, Singapour)

### 8.2 Acquisitions et Partenariats Stratégiques

**Cibles d'acquisition potentielles**:
- Startups de staging virtuel
- Solutions de plans 3D automatisés
- Technologies de mesure spatiale par smartphone

**Partenariats stratégiques**:
- Plateformes immobilières majeures (SeLoger, Zillow, etc.)
- Fournisseurs de CRM immobilier
- Associations professionnelles d'agents

### 8.3 Étapes de Croissance

| Phase | Période | Focus | KPIs Clés |
|-------|---------|-------|-----------|
| Foundation | 2023 | PMF, Retention | MAU, Rétention, NPS |
| Growth | 2024 | Acquisition, Engagement | CAC, LTV, Churn |
| Scale | 2025 | Monétisation, Expansion | ARPU, Marge, Int'l % |
| Domination | 2026+ | Leadership marché | Part de marché, EBITDA |

## 9. Gouvernance et Organisation

### 9.1 Équipes Produit

![Organisation Produit](https://via.placeholder.com/800x300?text=Organisation+Produit)

- **Core Experience** (7 personnes)
  - Interface utilisateur
  - Workflow d'édition
  - Performance & stabilité

- **Intelligence AI** (5 personnes)
  - Algorithmes de traitement
  - Intégration OpenAI
  - Modèles propriétaires

- **Business Enablement** (4 personnes)
  - Abonnements & paiements
  - Analytics & reporting
  - Intégrations tierces

### 9.2 Rituels de Gouvernance

| Cérémonie | Fréquence | Participants | Objectif |
|-----------|-----------|--------------|----------|
| Product Council | Mensuel | C-level, PMs, Tech Leads | Alignement stratégique |
| Tech Council | Bi-hebdo | CTO, Tech Leads, Arch | Décisions techniques |
| Design Review | Hebdo | CPO, PMs, Designers | Cohérence UX/UI |
| All-hands | Mensuel | Toute l'entreprise | Communication, Démos |
| Roadmap Review | Trimestriel | C-level, Leads | Ajustement priorités |

### 9.3 Matrice RACI Produit

| Activité | Product | Engineering | Design | QA | Marketing | CS |
|----------|---------|-------------|--------|-----|-----------|-----|
| Vision & roadmap | R/A | C | C | I | C | C |
| Priorisation | R/A | C | C | I | C | C |
| Spécifications | R | C | C | C | I | C |
| Design | A | I | R | I | C | I |
| Développement | A | R | C | C | I | I |
| Tests & QA | A | C | I | R | I | C |
| Documentation | A | C | C | C | C | R |
| Release | A | R | I | C | C | C |
| Marketing | C | I | C | I | R/A | C |
| Support | I | C | I | I | C | R/A |

R: Responsible, A: Accountable, C: Consulted, I: Informed

## 10. Gestion des Risques

### 10.1 Matrice des Risques

| Risque | Probabilité | Impact | Score | Mitigation |
|--------|-------------|--------|-------|------------|
| Concurrence majeure | Moyen | Élevé | 15 | Accélération innovation, USPs |
| Rupture technologique | Faible | Très élevé | 10 | Veille, partenariats R&D |
| Changements Apple/Google | Élevé | Moyen | 15 | Conformité proactive, alternatives |
| Limitations API OpenAI | Moyen | Élevé | 15 | Diversification fournisseurs, modèles propres |
| Adoption lente | Moyen | Élevé | 15 | Growth hacking, amélioration onboarding |
| Problèmes de performance | Moyen | Moyen | 9 | Monitoring, tests charge, architecture flexible |

### 10.2 Plan de Contingence

#### Risque: Limitations API OpenAI
**Plan B**:
1. Activation modèles de traitement local
2. Basculement vers alternatives (Anthropic, Stability AI)
3. Accélération développement modèles propriétaires

#### Risque: Changements App Store
**Plan B**:
1. Adaptation rapide aux nouvelles guidelines
2. Stratégie de distribution web progressive
3. Partenariats pour distribution alternative

### 10.3 Veille Technologique et Concurrentielle

- **Veille technologique**: Suivi hebdomadaire des avancées en IA/ML
- **Veille concurrentielle**: Analyse mensuelle des concurrents
- **Veille réglementaire**: Suivi des évolutions RGPD, droits d'auteur, IA

#### Responsables:
- Tech Lead: Veille technologique
- Product Manager: Veille concurrentielle
- Legal: Veille réglementaire

## Annexes

### A. Roadmap Visuelle

![Roadmap 2023-2024](https://via.placeholder.com/800x500?text=Roadmap+Visuelle+2023-2024)

### B. Backlog Priorisé (Top 20)

| ID | Fonctionnalité | Score RICE | Catégorie | Target Release |
|----|----------------|------------|-----------|----------------|
| PL-123 | Suppression objets intelligente | 320 | Core IA | v2.1 |
| PL-187 | Amélioration auto HDR | 280 | Core IA | v2.1 |
| PL-145 | Correction perspective | 275 | Core IA | v2.1 |
| PL-201 | Export multi-plateformes | 250 | Intégration | v2.1 |
| PL-156 | Visite virtuelle 360° | 245 | Innovation | v2.2 |
| PL-198 | Analytics utilisateur | 220 | Business | v2.1 |
| PL-210 | Mode hors-ligne | 210 | UX | v2.1 |
| PL-167 | Collaboration équipe | 195 | Collaboration | v2.2 |
| PL-189 | Uniformisation style | 190 | Core IA | v2.2 |
| PL-205 | Optimisation batch photos | 180 | Performance | v2.1 |
| PL-178 | Onboarding amélioré | 175 | UX | v2.1 |
| PL-223 | Staging virtuel basique | 160 | Innovation | v2.3 |
| PL-234 | IA génération textes | 155 | Innovation | v2.3 |
| PL-190 | Filtres pro immobilier | 150 | Core | v2.2 |
| PL-245 | Widget partage réseaux | 140 | Marketing | v2.2 |
| PL-256 | Abonnement équipe | 135 | Business | v2.2 |
| PL-213 | Suggestions automatiques | 130 | UX | v2.2 |
| PL-267 | Application desktop | 125 | Platform | v3.0 |
| PL-278 | Optimisation SEO photos | 120 | Marketing | v2.3 |
| PL-298 | Plan 2D automatique | 110 | Innovation | v3.0 |

### C. Modèle PRD (Product Requirements Document)

```markdown
# PRD: Visite Virtuelle 360°

## 1. Présentation
### 1.1 Problématique
Les agents immobiliers et hôtes Airbnb veulent offrir une expérience immersive sans investir dans des équipements coûteux.

### 1.2 Proposition
Permettre la création de visites virtuelles 360° à partir de photos standard.

## 2. Utilisateurs Cibles
- Agents immobiliers (priorité)
- Hôtes Airbnb/booking
- Gestionnaires multi-propriétés

## 3. User Stories
- En tant qu'agent, je veux créer une visite virtuelle 360° à partir de mes photos existantes
- En tant qu'utilisateur, je veux personnaliser ma visite avec des points d'intérêt
- En tant qu'utilisateur, je veux partager ma visite virtuelle facilement

## 4. Fonctionnalités & Spécifications
- Génération 360° à partir de min. 4 photos
- Éditeur de visite avec points d'intérêt
- Export formats standard (WebVR, MP4)
- Intégration directe plateformes immobilières

## 5. Métriques de Succès
- 30% d'adoption par les utilisateurs premium
- 25% d'augmentation du temps passé sur annonces
- NPS > 40 pour cette fonctionnalité

## 6. Risques & Limitations
- Qualité dépendant des photos source
- Temps de génération potentiellement long
- Compatibilité navigateurs anciens

## 7. Timeline
- Alpha: S45
- Beta: S47
- Release: S50

## 8. Ressources
- [Link maquettes Figma]
- [Link spécifications techniques]
- [Link recherche utilisateur]
```

### D. Lexique & Terminologie Produit

| Terme | Définition | Contexte |
|-------|------------|----------|
| Projet | Collection de photos pour une propriété | Organisation |
| Amélioration IA | Traitement automatisé d'une photo | Core feature |
| Batch | Traitement groupé de photos | Workflow |
| Export | Génération des fichiers finaux | Distribution |
| HDR | High Dynamic Range (amélioration luminosité) | Technique |
| Staging | Ajout virtuel de meubles/déco | Feature |
| Visite virtuelle | Expérience immersive 360° | Feature |
| Premium | Niveau d'abonnement payant | Business |