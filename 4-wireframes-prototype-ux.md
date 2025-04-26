# Wireframes & Prototype UX - PhotoListing

Ce document présente les maquettes basse fidélité (wireframes) de l'application PhotoListing et une description des écrans principaux. Ces wireframes serviront de référence pour le développement de l'interface utilisateur.

## 1. Structure de l'application

L'application est structurée autour de 5 sections principales, accessibles via une barre de navigation en bas de l'écran :

1. **Accueil** - Point d'entrée et résumé des activités récentes
2. **Projets** - Organisation des photos par propriétés/dossiers
3. **Traitement** - Interface de retouche et amélioration des photos
4. **Galerie** - Visualisation de toutes les photos traitées
5. **Profil** - Gestion du compte et des paramètres

## 2. Wireframes des écrans principaux

### 2.1 Écran d'accueil
```
┌─────────────────────────────────────┐
│ PhotoListing                [Stats] │
├─────────────────────────────────────┤
│                                     │
│  [Bouton "Améliorer une photo"]     │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Activité récente              │  │
│  │                               │  │
│  │ ┌─────┐ ┌─────┐ ┌─────┐      │  │
│  │ │ IMG │ │ IMG │ │ IMG │  >   │  │
│  │ └─────┘ └─────┘ └─────┘      │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Projets                       │  │
│  │                               │  │
│  │ ┌───────────┐  ┌───────────┐  │  │
│  │ │ Projet 1  │  │ Projet 2  │  │  │
│  │ └───────────┘  └───────────┘  │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Pro Tips                      │  │
│  │ Comment prendre de meilleures │  │
│  │ photos de votre intérieur     │  │
│  └───────────────────────────────┘  │
│                                     │
├─────────────────────────────────────┤
│ [Home] [Projets] [+] [Galerie] [Profil] │
└─────────────────────────────────────┘
```

**Éléments clés :**
- Bouton d'action principal "Améliorer une photo" en position centrale supérieure
- Section d'activité récente montrant les dernières photos traitées
- Accès rapide aux projets en cours
- Astuces pour aider les utilisateurs à prendre de meilleures photos

### 2.2 Écran d'importation et sélection de photos
```
┌─────────────────────────────────────┐
│ Nouvelle amélioration        [X]    │
├─────────────────────────────────────┤
│                                     │
│  Importer des photos                │
│                                     │
│  ┌─────────────┐  ┌─────────────┐   │
│  │             │  │             │   │
│  │   Galerie   │  │  Appareil   │   │
│  │             │  │    photo    │   │
│  │             │  │             │   │
│  └─────────────┘  └─────────────┘   │
│                                     │
│  ┌─────────────┐  ┌─────────────┐   │
│  │             │  │             │   │
│  │  Fichiers   │  │   Google    │   │
│  │             │  │    Drive    │   │
│  │             │  │             │   │
│  └─────────────┘  └─────────────┘   │
│                                     │
│  [Sélectionner un projet]           │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Projets récents               │  │
│  │                               │  │
│  │ • Appartement Montmartre      │  │
│  │ • Villa Côte d'Azur           │  │
│  │ • + Créer un nouveau projet   │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

**Éléments clés :**
- Options multiples d'importation (galerie, appareil photo, fichiers, cloud)
- Sélection ou création de projet avant importation
- Liste des projets récents pour un accès rapide

### 2.3 Écran de sélection du mode de traitement
```
┌─────────────────────────────────────┐
│ Amélioration              [Annuler] │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │                               │  │
│  │                               │  │
│  │         [Aperçu photo]        │  │
│  │                               │  │
│  │                               │  │
│  └───────────────────────────────┘  │
│                                     │
│  Mode d'amélioration               │
│                                     │
│  ┌─────────┐  ┌─────────┐          │
│  │Standard │  │   Pro   │          │
│  └─────────┘  └─────────┘          │
│                                     │
│  Type de pièce                      │
│                                     │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐│
│  │Salon│ │Cuis│ │Chbr│ │SdB │ │Ext ││
│  └────┘ └────┘ └────┘ └────┘ └────┘│
│                                     │
│  Intensité                          │
│  ○───●───○───○───○                  │
│  Légère    Modérée    Marquée       │
│                                     │
│  [      AMÉLIORER      ]            │
│                                     │
└─────────────────────────────────────┘
```

**Éléments clés :**
- Aperçu de la photo sélectionnée
- Sélection du mode d'amélioration (Standard/Pro)
- Préréglages par type de pièce pour des résultats optimisés
- Contrôle de l'intensité du traitement
- Bouton d'action principal en bas de l'écran

### 2.4 Écran de traitement en cours
```
┌─────────────────────────────────────┐
│ Traitement en cours...              │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │                               │  │
│  │                               │  │
│  │    [Animation de traitement]  │  │
│  │                               │  │
│  │                               │  │
│  └───────────────────────────────┘  │
│                                     │
│  Optimisation de votre photo...     │
│                                     │
│  ■■■■■■■■■□□□□□□  58%               │
│                                     │
│  Temps restant estimé: 7 secondes   │
│                                     │
│  [Mode Pro activé]                  │
│  [Type: Salon]                      │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Photo 1/3 en traitement...    │  │
│  │ File d'attente: 2 photos      │  │
│  └───────────────────────────────┘  │
│                                     │
│  [      ANNULER      ]              │
│                                     │
└─────────────────────────────────────┘
```

**Éléments clés :**
- Animation de traitement pour indiquer l'activité
- Barre de progression avec pourcentage
- Estimation du temps restant
- Résumé des paramètres appliqués
- Information sur la file d'attente pour le traitement par lot
- Option d'annulation

### 2.5 Écran de comparaison avant/après
```
┌─────────────────────────────────────┐
│ Résultat                 [1/3 >]    │
├─────────────────────────────────────┤
│  Avant │ Après                      │
│  ┌─────┼─────┐                      │
│  │     │     │                      │
│  │     │     │                      │
│  │     │     │                      │
│  │     │     │                      │
│  └─────┴─────┘                      │
│  <─── Glisser pour comparer ───>    │
│                                     │
│  Améliorations appliquées:          │
│  • Éclairage optimisé               │
│  • Couleurs améliorées              │
│  • Perspective corrigée             │
│  • Netteté augmentée                │
│                                     │
│  Ajuster (optionnel)                │
│                                     │
│  Luminosité    ○───●───○───○        │
│  Contraste     ○───○───●───○        │
│                                     │
│  [ RÉESSAYER ]    [ APPROUVER ]     │
│                                     │
└─────────────────────────────────────┘
```

**Éléments clés :**
- Affichage côte à côte des versions avant/après
- Curseur de superposition pour une comparaison précise
- Liste des améliorations appliquées
- Options d'ajustement fin post-traitement
- Boutons pour réessayer avec d'autres paramètres ou approuver

### 2.6 Écran d'exportation et partage
```
┌─────────────────────────────────────┐
│ Exporter                 [Fermer]   │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │                               │  │
│  │                               │  │
│  │         [Photo finale]        │  │
│  │                               │  │
│  │                               │  │
│  └───────────────────────────────┘  │
│                                     │
│  Options d'exportation              │
│                                     │
│  Format:   ○ JPG  ● PNG  ○ HEIF     │
│                                     │
│  Qualité:  ○───○───●───○            │
│            Basse    Haute           │
│                                     │
│  Taille:   ● Originale  ○ Optimisée │
│                                     │
│  Métadonnées: ● Conserver ○ Supprimer│
│                                     │
│  [ EXPORTER ]    [ PARTAGER ]       │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ WhatsApp  Email  Drive  Airbnb │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

**Éléments clés :**
- Aperçu de la photo finale
- Options de format d'exportation
- Contrôle de la qualité et de la taille
- Gestion des métadonnées
- Boutons d'action pour exporter ou partager
- Accès rapide aux options de partage courantes

### 2.7 Écran de gestion des projets
```
┌─────────────────────────────────────┐
│ Mes projets           [+ Nouveau]   │
├─────────────────────────────────────┤
│  [Rechercher...]                    │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌─────┐  Appartement Paris    │  │
│  │ │ IMG │  15 photos • 12 juin  │  │
│  │ └─────┘  [...]                │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌─────┐  Villa Saint-Tropez   │  │
│  │ │ IMG │  27 photos • 5 juin   │  │
│  │ └─────┘  [...]                │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ ┌─────┐  Studio Montmartre    │  │
│  │ │ IMG │  8 photos • 29 mai    │  │
│  │ └─────┘  [...]                │  │
│  └───────────────────────────────┘  │
│                                     │
│  Filtrer par:                       │
│  [Tous] [Récents] [Favoris]         │
│                                     │
│  Trier par:                         │
│  [Date ▼] [Nom] [Taille]            │
│                                     │
├─────────────────────────────────────┤
│ [Home] [Projets] [+] [Galerie] [Profil] │
└─────────────────────────────────────┘
```

**Éléments clés :**
- Liste des projets avec image de couverture
- Informations résumées (nombre de photos, date)
- Fonction de recherche
- Filtres et options de tri
- Bouton pour créer un nouveau projet

### 2.8 Écran de compte et abonnement
```
┌─────────────────────────────────────┐
│ Mon compte                          │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │            [Avatar]           │  │
│  │       sophie@example.com      │  │
│  │         Modifier profil       │  │
│  └───────────────────────────────┘  │
│                                     │
│  Abonnement actuel                  │
│  ┌───────────────────────────────┐  │
│  │ Plan Particulier               │  │
│  │ 5,99€/mois • Renouvellement 15/07│
│  │ 23/50 photos ce mois-ci        │  │
│  │ [Gérer l'abonnement]           │  │
│  └───────────────────────────────┘  │
│                                     │
│  Paramètres                         │
│  ┌───────────────────────────────┐  │
│  │ Notifications            [>]  │  │
│  │ Langue & Région          [>]  │  │
│  │ Stockage & Données       [>]  │  │
│  │ Confidentialité          [>]  │  │
│  │ Aide & Support           [>]  │  │
│  └───────────────────────────────┘  │
│                                     │
│  [   DÉCONNEXION   ]                │
│                                     │
├─────────────────────────────────────┤
│ [Home] [Projets] [+] [Galerie] [Profil] │
└─────────────────────────────────────┘
```

**Éléments clés :**
- Informations de profil de base
- Détails sur l'abonnement actuel et l'utilisation
- Accès aux paramètres de l'application
- Option de déconnexion

## 3. Interface de traitement par lot

### 3.1 Sélection de photos pour traitement par lot
```
┌─────────────────────────────────────┐
│ Sélection de photos    [3 sélectionnées] │
├─────────────────────────────────────┤
│                                     │
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐ │
│  │ ✓   │  │     │  │ ✓   │  │     │ │
│  │ IMG │  │ IMG │  │ IMG │  │ IMG │ │
│  └─────┘  └─────┘  └─────┘  └─────┘ │
│                                     │
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐ │
│  │     │  │ ✓   │  │     │  │     │ │
│  │ IMG │  │ IMG │  │ IMG │  │ IMG │ │
│  └─────┘  └─────┘  └─────┘  └─────┘ │
│                                     │
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐ │
│  │     │  │     │  │     │  │     │ │
│  │ IMG │  │ IMG │  │ IMG │  │ IMG │ │
│  └─────┘  └─────┘  └─────┘  └─────┘ │
│                                     │
│  Actions:                           │
│  [Tout sélectionner] [Inverser]     │
│                                     │
│  [ ANNULER ]    [ CONTINUER ]       │
│                                     │
└─────────────────────────────────────┘
```

**Éléments clés :**
- Grille de sélection multiple avec indication visuelle
- Compteur de photos sélectionnées
- Actions rapides (tout sélectionner, inverser)
- Navigation claire (annuler, continuer)

### 3.2 Configuration du traitement par lot
```
┌─────────────────────────────────────┐
│ Traitement par lot       [Annuler]  │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 3 photos sélectionnées        │  │
│  │ ┌─────┐ ┌─────┐ ┌─────┐       │  │
│  │ │ IMG │ │ IMG │ │ IMG │       │  │
│  │ └─────┘ └─────┘ └─────┘       │  │
│  └───────────────────────────────┘  │
│                                     │
│  Paramètres communs                 │
│                                     │
│  Mode: ○ Standard   ● Professionnel │
│                                     │
│  Appliquer des préréglages par type:│
│                                     │
│  ○ Automatique (détection)          │
│  ● Manuel par photo                 │
│  ○ Même préréglage pour toutes      │
│     [Salon ▼]                       │
│                                     │
│  Intensité                          │
│  ○───○───●───○───○                  │
│  Légère    Modérée    Marquée       │
│                                     │
│  Temps estimé: ~45 secondes         │
│                                     │
│  [  LANCER LE TRAITEMENT  ]         │
│                                     │
└─────────────────────────────────────┘
```

**Éléments clés :**
- Aperçu des photos sélectionnées
- Options de configuration communes
- Choix entre détection automatique ou manuel
- Estimation du temps de traitement
- Bouton d'action principal

### 3.3 Suivi du traitement par lot
```
┌─────────────────────────────────────┐
│ Traitement en cours...              │
├─────────────────────────────────────┤
│                                     │
│  Progression globale                │
│  ■■■■■■■□□□□□□□  42%                │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Photo 2/5                     │  │
│  │ ┌─────┐                       │  │
│  │ │ IMG │ [Animation loading]   │  │
│  │ └─────┘                       │  │
│  │ Temps restant: ~27 sec        │  │
│  └───────────────────────────────┘  │
│                                     │
│  File d'attente:                    │
│  ┌───────────────────────────────┐  │
│  │ ✓ Photo 1 - Terminée          │  │
│  │ → Photo 2 - En cours          │  │
│  │ ○ Photo 3 - En attente        │  │
│  │ ○ Photo 4 - En attente        │  │
│  │ ○ Photo 5 - En attente        │  │
│  └───────────────────────────────┘  │
│                                     │
│  [Traiter en arrière-plan]          │
│                                     │
│  [      ANNULER      ]              │
│                                     │
└─────────────────────────────────────┘
```

**Éléments clés :**
- Barre de progression globale
- Affichage détaillé de la photo en cours de traitement
- File d'attente avec statut de chaque photo
- Option pour continuer le traitement en arrière-plan
- Possibilité d'annuler le traitement

## 4. Prototype interactif

Un prototype interactif a été développé avec Figma pour permettre de tester les interactions principales. Ce prototype est accessible via le lien suivant:

[Prototype Figma PhotoListing](https://figma.com/prototypes/photolisting)

Le prototype couvre les parcours utilisateurs suivants:
1. Onboarding et première utilisation
2. Importation et amélioration d'une seule photo
3. Création d'un projet et traitement par lot
4. Navigation entre les différentes sections de l'application

## 5. Notes sur l'accessibilité et l'ergonomie

### 5.1 Principes d'accessibilité
- Contraste élevé entre texte et fond pour lisibilité optimale
- Taille de texte ajustable
- Support des technologies d'assistance (VoiceOver, TalkBack)
- Boutons et zones tactiles suffisamment grands (min. 44x44pt)
- Libellés explicites sur tous les contrôles interactifs

### 5.2 Considérations ergonomiques
- Positionnement des boutons d'action principaux dans la zone accessible au pouce
- Limitation du nombre d'étapes pour les actions fréquentes
- Feedback visuel et haptique sur les actions importantes
- Possibilité d'utilisation en mode portrait et paysage (tablettes)
- Persistance des données en cas d'interruption (appel, notification)

## 6. Prochaines étapes

- Tests utilisateurs sur les wireframes pour valider les flux
- Développement des maquettes haute-fidélité avec charte graphique
- Ajout des animations et micro-interactions
- Test d'utilisabilité avec prototypes sur appareils réels
- Finalisation des spécifications UI détaillées pour le développement