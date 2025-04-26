# Personas & Parcours Utilisateur - PhotoListing

## 1. Personas principaux

### Persona 1: Sophie, l'hôte Airbnb occasionnelle

**Profil démographique**
- 35 ans, consultante marketing
- Habite à Lyon
- Revenus: 55 000 € par an
- Propriétaire d'un appartement qu'elle loue partiellement pendant ses déplacements professionnels

**Caractéristiques**
- Utilise activement son smartphone (iPhone 12)
- À l'aise avec les applications mobiles mais pas experte en photographie
- Sensible à l'esthétique et soigne sa décoration intérieure
- Optimise son temps et cherche l'efficacité

**Objectifs**
- Maximiser son taux d'occupation et ses revenus Airbnb
- Mettre en valeur son appartement sans dépenser en photographe
- Gérer ses annonces efficacement entre ses déplacements
- Se démarquer des autres annonces dans son quartier

**Frustrations**
- Ses photos ne rendent pas justice à son appartement
- Manque de temps pour apprendre des logiciels d'édition photo complexes
- Déçue par la qualité de ses photos comparées à celles des annonces professionnelles
- Considère que faire appel à un photographe est trop cher pour son activité occasionnelle

**Comportement numérique**
- Utilise principalement l'application Airbnb sur mobile
- Consulte régulièrement ses statistiques de visites
- Prend ses photos à la hâte avec son iPhone
- Utilise Instagram et Pinterest pour trouver de l'inspiration déco

---

### Persona 2: Marc, le gérant d'agence de location saisonnière

**Profil démographique**
- 42 ans, entrepreneur
- Habite à Nice
- Revenus: 90 000 € par an
- Gère une agence avec 35 propriétés en location saisonnière

**Caractéristiques**
- Pragmatique et orienté résultats
- Technophile, adepte des solutions d'automatisation
- Attentif au ROI de chaque investissement
- Délègue beaucoup mais supervise la qualité

**Objectifs**
- Standardiser la qualité visuelle de toutes ses annonces
- Réduire les coûts opérationnels (notamment photographe)
- Accélérer la mise en ligne de nouvelles propriétés
- Augmenter les taux de conversion des visiteurs en réservations

**Frustrations**
- Coût élevé des photographes professionnels pour 35+ propriétés
- Délais de livraison des photos (2-5 jours) qui retardent la mise en ligne
- Qualité inégale des photos prises par son équipe
- Difficulté à maintenir une cohérence visuelle entre toutes les annonces

**Comportement numérique**
- Utilise un iPad Pro et un Android haut de gamme
- Travaille principalement sur les plateformes Booking et Airbnb
- Utilise des logiciels de gestion de propriétés (Smoobu, Lodgify)
- Partage les photos avec son équipe via Google Drive

---

### Persona 3: Nadia, l'agent immobilier traditionnelle

**Profil démographique**
- 48 ans, agent immobilier indépendante
- Habite à Paris
- Revenus: 70 000 € par an
- Spécialisée dans l'immobilier de luxe

**Caractéristiques**
- Méthodique et perfectionniste
- Soucieuse de l'image professionnelle qu'elle projette
- Valorise la qualité plutôt que la quantité
- Fidèle à ses habitudes mais ouverte aux innovations pertinentes

**Objectifs**
- Présenter les biens avec la meilleure qualité possible
- Réduire le temps entre la prise du mandat et la mise en ligne des annonces
- Conserver une image très professionnelle
- Respecter strictement la réalité des biens (aspect légal important)

**Frustrations**
- Dépendance vis-à-vis des photographes qui ont des plannings chargés
- Nécessité de revisiter les biens quand les photos initiales sont ratées
- Clients impatients de voir leur bien en ligne rapidement
- Modifications de dernière minute difficiles à gérer avec des photographes externes

**Comportement numérique**
- Utilise principalement un iPhone pour les photos
- Travaille sur des plateformes immobilières spécialisées
- Partage les annonces sur les réseaux sociaux professionnels
- Moins à l'aise avec les nouvelles applications, mais prête à apprendre si bénéfique

## 2. Parcours utilisateur - Diagrammes de flux

### Parcours 1: Première utilisation et traitement d'une photo (Sophie)

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Téléchargement │     │  Onboarding &   │     │   Autorisation  │     │   Création du   │
│  de l'app sur   │ ──> │   tutoriel de   │ ──> │   d'accès aux   │ ──> │    compte ou    │
│   App Store     │     │   bienvenue     │     │     photos      │     │ connexion Guest │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
          │                                                                       │
          │                                                                       ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Visualisation & │     │  Application du │     │  Sélection du   │     │  Importation    │
│  approbation du │ <── │   traitement    │ <── │  préréglage     │ <── │  d'une photo    │
│    résultat     │     │    par IA       │     │  "Salon"        │     │  depuis galerie │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
          │
          ▼
┌─────────────────┐     ┌─────────────────┐
│  Exportation    │     │  Partage direct │
│  vers galerie   │ ──> │  sur Airbnb     │
│  de l'appareil  │     │                 │
└─────────────────┘     └─────────────────┘
```

**Points d'attention :**
- L'onboarding doit être rapide (max 3 écrans) pour ne pas frustrer Sophie
- Préréglages clairs par type de pièce pour faciliter le choix
- Comparaison avant/après intuitive
- Option de partage direct vers Airbnb pour gagner du temps

---

### Parcours 2: Traitement par lot pour nouvelle propriété (Marc)

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Connexion     │     │  Création d'un  │     │  Importation    │     │  Sélection de   │
│   au compte     │ ──> │  nouveau dossier│ ──> │  photos (20+)   │ ──> │  toutes les     │
│   Premium       │     │  "Villa Azur"   │     │  depuis galerie │     │  photos         │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
          │                                                                       │
          │                                                                       ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Exportation   │     │  Révision et    │     │  Traitement     │     │  Configuration  │
│   batch vers    │ <── │  ajustements    │ <── │  par lot (file  │ <── │  des paramètres │
│   Google Drive  │     │  ponctuels      │     │  d'attente)     │     │  de traitement  │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
          │
          ▼
┌─────────────────┐
│  Partage du lien│
│  avec l'équipe  │
│  marketing      │
└─────────────────┘
```

**Points d'attention :**
- Gestion efficace du traitement par lot avec indicateur de progression
- Possibilité d'appliquer des paramètres cohérents à toutes les photos
- Système de notification une fois le traitement terminé
- Options d'export flexibles pour intégration avec outils existants

---

### Parcours 3: Retouche rapide avant visite (Nadia)

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Prise de photo│     │  Ouverture de   │     │  Sélection de   │     │  Traitement     │
│   sur place     │ ──> │  l'application  │ ──> │  la photo via   │ ──> │  rapide avec    │
│   (bien client) │     │  déjà installée │     │  la galerie     │     │  mode "Pro"     │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
                                                                                  │
                                                                                  ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Envoi des     │     │  Validation     │     │  Ajustement     │     │ Comparaison     │
│   photos au     │ <── │  et export      │ <── │  légère baisse  │ <── │ avant/après     │
│   client        │     │  en HD          │     │  d'intensité    │     │ sur écran       │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
```

**Points d'attention :**
- Accès rapide et direct au traitement depuis la prise de photo
- Contrôle précis de l'intensité pour préserver l'authenticité
- Interface de comparaison claire sur mobile
- Options d'export et de partage efficaces pour envoi client immédiat

## 3. Scénarios d'usage détaillés

### Scénario 1: Première expérience de Sophie

Sophie vient de mettre son appartement en location sur Airbnb. Après avoir pris quelques photos avec son iPhone, elle est déçue par leur qualité comparée aux annonces concurrentes. Une amie lui suggère d'essayer PhotoListing.

1. Sophie télécharge l'application depuis l'App Store
2. Elle parcourt rapidement les 3 écrans d'onboarding qui expliquent les fonctionnalités clés
3. Elle accorde les autorisations d'accès à sa galerie photo
4. Pour tester l'application, elle choisit de ne pas créer de compte tout de suite (mode invité)
5. Elle importe une photo de son salon, qui est sombre et mal cadrée
6. L'application lui suggère automatiquement le préréglage "Salon"
7. Elle lance le traitement et observe la progression (10 secondes)
8. L'écran de comparaison s'affiche, montrant la photo originale et la version améliorée
9. Impressionnée par le résultat (meilleure luminosité, couleurs plus vibrantes), elle l'approuve
10. Elle choisit d'exporter la photo dans sa galerie
11. Enthousiasmée, elle décide de créer un compte pour pouvoir traiter toutes ses photos
12. Elle s'abonne à l'offre "Particulier" pour 5,99€/mois

### Scénario 2: Travail quotidien de Marc

Marc vient d'ajouter une nouvelle villa à son portefeuille. Son assistant a pris 25 photos avec son smartphone, mais Marc souhaite les améliorer avant mise en ligne.

1. Marc se connecte à son compte Premium sur sa tablette
2. Il crée un nouveau dossier "Villa Azur - Juin 2023"
3. Il importe les 25 photos depuis son Drive où son assistant les a déposées
4. Il les organise rapidement par pièce à l'aide de l'interface glisser-déposer
5. Il sélectionne toutes les photos et choisit un traitement par lot
6. Il configure les paramètres généraux: intensité "Modérée" et style "Professionnel"
7. Il lance le traitement et reçoit une estimation de 6 minutes pour les 25 photos
8. Pendant ce temps, il continue de travailler sur d'autres tâches
9. Une notification l'informe que le traitement est terminé
10. Il passe rapidement en revue les résultats et ajuste manuellement 3 photos trop contrastées
11. Il exporte l'ensemble des photos en haute résolution vers son Google Drive
12. Il partage le lien du dossier avec son équipe marketing pour mise en ligne immédiate

### Scénario 3: Utilisation d'urgence par Nadia

Nadia a un rendez-vous avec un client potentiel dans 30 minutes. Elle reçoit un appel du propriétaire vendeur qui lui demande si l'annonce est en ligne. Les photos qu'elle a prises la veille ne sont pas encore retouchées.

1. Nadia ouvre PhotoListing sur son iPhone
2. Elle accède directement à sa galerie via le raccourci de l'application
3. Elle sélectionne les 8 photos du bien qu'elle a prises
4. Elle applique le préréglage "Immobilier Pro" avec intensité "Légère"
5. Elle lance le traitement par lot, qui prend 2 minutes
6. À travers l'écran de comparaison, elle vérifie que les améliorations respectent la réalité du bien
7. Pour une photo du salon, elle réduit encore l'intensité à "Très légère" pour rester fidèle à la réalité
8. Elle exporte toutes les photos en haute résolution
9. Directement depuis l'application, elle partage les photos via un lien temporaire
10. Elle envoie ce lien au client potentiel avant son rendez-vous
11. Sur place, elle peut montrer la propriété avec des visuels professionnels qui correspondent à la réalité