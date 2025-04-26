# Spécification UI détaillée - PhotoListing

Ce document définit les standards visuels et d'interaction qui seront appliqués à l'application PhotoListing sur iOS et Android. Il servira de référence pour maintenir une cohérence visuelle tout au long du développement.

## 1. Système de design et principes généraux

### 1.1 Philosophie UI/UX
L'interface de PhotoListing respecte les principes suivants :
- **Simplicité** : Interfaces minimalistes avec focus sur le contenu photographique
- **Accessibilité** : Application utilisable par tous, y compris personnes à mobilité réduite
- **Cohérence** : Expérience fluide et prévisible sur l'ensemble de l'application
- **Réactivité** : Feedback instantané suite aux actions utilisateur
- **Contexte** : Interface adaptée au contexte immobilier et photographique

### 1.2 Conformité aux standards des plateformes
L'application suit :
- Les [Human Interface Guidelines d'Apple](https://developer.apple.com/design/human-interface-guidelines/) pour iOS
- Les [Material Design Guidelines de Google](https://material.io/design) pour Android

Des adaptations spécifiques seront faites pour chaque plateforme tout en maintenant une identité visuelle cohérente.

## 2. Palette de couleurs

### 2.1 Couleurs principales
- **Couleur primaire** : `#3B82F6` (Bleu vif)
  - Variations claires : `#93C5FD`, `#DBEAFE`
  - Variations foncées : `#2563EB`, `#1D4ED8`
- **Couleur secondaire** : `#10B981` (Vert émeraude)
  - Variations claires : `#6EE7B7`, `#D1FAE5`
  - Variations foncées : `#059669`, `#047857`

### 2.2 Couleurs neutres
- **Fond clair** : `#FFFFFF` (Blanc)
- **Fond alternatif** : `#F8FAFC` (Gris très clair)
- **Fond d'accent** : `#F1F5F9` (Gris clair)
- **Texte principal** : `#1E293B` (Gris foncé)
- **Texte secondaire** : `#64748B` (Gris moyen)
- **Bordures** : `#E2E8F0` (Gris clair)

### 2.3 Couleurs fonctionnelles
- **Succès** : `#10B981` (Vert)
- **Avertissement** : `#F59E0B` (Orange)
- **Erreur** : `#EF4444` (Rouge)
- **Information** : `#3B82F6` (Bleu)

### 2.4 Mode sombre
Version sombre de la palette, avec inversions appropriées :
- **Fond sombre** : `#0F172A` (Bleu-noir)
- **Fond alternatif** : `#1E293B` (Bleu-gris foncé)
- **Texte principal** : `#F8FAFC` (Blanc cassé)
- **Texte secondaire** : `#CBD5E1` (Gris clair)
- **Bordures** : `#334155` (Gris foncé)

Les couleurs primaires et secondaires conservent leur teinte mais sont ajustées en luminosité pour le mode sombre.

## 3. Typographie

### 3.1 Famille de polices
- **iOS** : SF Pro Text / SF Pro Display
- **Android** : Roboto / Google Sans

### 3.2 Échelle typographique
- **Titres principaux** : 24pt, gras
- **Titres secondaires** : 20pt, semi-gras
- **Titres de section** : 18pt, semi-gras
- **Corps de texte** : 16pt, normal
- **Texte secondaire** : 14pt, normal
- **Légendes** : 12pt, normal
- **Micro-texte** : 10pt, normal (utilisé parcimonieusement)

### 3.3 Règles typographiques
- Alignement à gauche par défaut pour toutes les langues LTR
- Interlignage de 1.4 pour une meilleure lisibilité
- Titres en sentence case (première lettre en majuscule)
- Contraste minimum WCAG AA (4.5:1) entre texte et fond

## 4. Iconographie et illustrations

### 4.1 Style d'icônes
- Icônes linéaires avec épaisseur de trait constante (1.5pt)
- Style arrondi, coins avec rayon de 2pt
- Taille standard de 24x24pt
- Remplissage pour états actifs/sélectionnés

### 4.2 Bibliothèque d'icônes
L'application utilise :
- Le jeu d'icônes personnalisé PhotoListing pour les fonctionnalités spécifiques
- [SF Symbols](https://developer.apple.com/sf-symbols/) pour iOS
- [Material Icons](https://material.io/resources/icons/) pour Android

### 4.3 Illustrations
- Style simple et épuré avec palette limitée
- Illustrations de concept pour les écrans vides ou d'onboarding
- Utilisation d'illustrations contextuelles pour expliciter des fonctionnalités spécifiques

## 5. Composants UI

### 5.1 Boutons

#### 5.1.1 Boutons primaires
- Hauteur : 48pt
- Rayon de bordure : 8pt
- Couleur de fond : Couleur primaire
- Texte : Blanc, 16pt, semi-gras
- Padding horizontal : 16pt
- États :
  - Normal : `#3B82F6`
  - Appuyé : `#2563EB`
  - Désactivé : `#93C5FD` (opacité 50%)

```
┌────────────────────┐
│      BOUTON        │
└────────────────────┘
```

#### 5.1.2 Boutons secondaires
- Hauteur : 48pt
- Rayon de bordure : 8pt
- Bordure : 1.5pt, couleur primaire
- Fond : Transparent
- Texte : Couleur primaire, 16pt, semi-gras
- États :
  - Normal : Bordure `#3B82F6`, texte `#3B82F6`
  - Appuyé : Fond `#DBEAFE`, bordure `#2563EB`, texte `#2563EB`
  - Désactivé : Opacité 50%

```
┌────────────────────┐
│      BOUTON        │
└────────────────────┘
```

#### 5.1.3 Boutons tertiaires
- Hauteur : 40pt
- Texte : Couleur primaire, 14pt, semi-gras
- Fond : Transparent
- États :
  - Normal : Texte `#3B82F6`
  - Appuyé : Fond `#DBEAFE`, texte `#2563EB`
  - Désactivé : Opacité 50%

```
    BOUTON TEXTE
```

#### 5.1.4 Boutons d'action flottants
- Diamètre : 56pt
- Ombre : Y=2pt, Flou=8pt, Opacité=15%
- Couleur : Primaire
- Icône : 24pt, blanc
- Position : Coin inférieur droit, marge de 16pt

```
    ┌───┐
    │ + │
    └───┘
```

### 5.2 Champs de saisie

#### 5.2.1 Champs texte
- Hauteur : 48pt
- Rayon de bordure : 8pt
- Bordure : 1pt, `#E2E8F0`
- Fond : `#FFFFFF`
- Étiquette : 14pt, `#64748B`, positionnée au-dessus
- Texte : 16pt, `#1E293B`
- Placeholder : 16pt, `#CBD5E1`
- États :
  - Repos : Bordure `#E2E8F0`
  - Focus : Bordure 2pt `#3B82F6`
  - Erreur : Bordure 1.5pt `#EF4444`
  - Désactivé : Fond `#F1F5F9`, opacité 50%

```
Label
┌────────────────────┐
│ Texte              │
└────────────────────┘
Message d'aide ou d'erreur
```

#### 5.2.2 Zones de texte multilignes
- Hauteur minimale : 96pt
- Autres propriétés identiques aux champs texte

#### 5.2.3 Champs de recherche
- Hauteur : 40pt
- Icône de recherche à gauche : 20pt, `#64748B`
- Autres propriétés identiques aux champs texte

```
┌─────────────────────────┐
│ 🔍 Rechercher...        │
└─────────────────────────┘
```

### 5.3 Contrôles de sélection

#### 5.3.1 Cases à cocher
- Taille : 20pt x 20pt
- Rayon de bordure : 4pt
- États :
  - Non cochée : Bordure 1.5pt, `#64748B`
  - Cochée : Fond `#3B82F6`, icône check blanche
  - Désactivée : Opacité 50%

```
☐ Option non sélectionnée
☑ Option sélectionnée
```

#### 5.3.2 Boutons radio
- Taille : 20pt x 20pt
- Forme : Circulaire
- États :
  - Non sélectionné : Bordure 1.5pt, `#64748B`
  - Sélectionné : Bordure 1.5pt `#3B82F6`, cercle intérieur 8pt `#3B82F6`
  - Désactivé : Opacité 50%

```
○ Option non sélectionnée
● Option sélectionnée
```

#### 5.3.3 Interrupteurs (switches)
- Taille : 36pt x 20pt
- Rayon : 10pt (complet)
- États :
  - Désactivé : Fond `#CBD5E1`, curseur blanc
  - Activé : Fond `#3B82F6`, curseur blanc
  - En cours de changement : Animation de transition fluide

```
○─── Off
───○ On
```

#### 5.3.4 Curseurs (sliders)
- Hauteur de la piste : 4pt
- Diamètre du curseur : 20pt
- Couleurs :
  - Piste inactive : `#E2E8F0`
  - Piste active : `#3B82F6`
  - Curseur : Blanc avec ombre légère
- Comportement : Retour haptique lors des changements de valeur

```
○───────────
```

### 5.4 Composants de navigation

#### 5.4.1 Barre de navigation supérieure
- Hauteur : 56pt
- Fond : `#FFFFFF` (iOS), `#3B82F6` (Android)
- Titre : 18pt, semi-gras, centré (iOS), aligné à gauche (Android)
- Boutons : Icônes 24pt
- Ombre subtile : Y=1pt, Flou=3pt, Opacité=5%

```
┌─────────────────────────┐
│ ← Titre         Action  │
└─────────────────────────┘
```

#### 5.4.2 Barre d'onglets inférieure
- Hauteur : 56pt
- Fond : `#FFFFFF`
- Icônes : 24pt
- Étiquettes : 12pt
- Indicateur de sélection : Couleur primaire
- Comportement : Animation lors des changements d'onglet

```
┌─────────────────────────┐
│ ○     ○     ●     ○     │
│Home Projets  +  Galerie │
└─────────────────────────┘
```

#### 5.4.3 Tiroirs de navigation latéraux
- Largeur : 80% de la largeur de l'écran
- Fond : `#FFFFFF`
- Entête : 172pt de hauteur avec image de profil et informations utilisateur
- Items : 56pt de hauteur, icône 24pt, texte 16pt
- Séparateurs : Ligne 1pt, `#E2E8F0`

#### 5.4.4 Modals et Bottom Sheets
- Rayon de bordure supérieur : 16pt (bottom sheets)
- Rayon de bordure : 16pt (modals)
- Fond : `#FFFFFF`
- Ombre : Y=5pt, Flou=15pt, Opacité=10%
- Barre de poignée : 4pt x 32pt, `#CBD5E1` (bottom sheets uniquement)
- Animation : Entrée du bas avec courbe d'accélération naturelle

### 5.5 Composants de présentation

#### 5.5.1 Cartes (cards)
- Rayon de bordure : 12pt
- Fond : `#FFFFFF`
- Ombre : Y=1pt, Flou=5pt, Opacité=5%
- Padding interne : 16pt
- États :
  - Normal : Ombre standard
  - Appuyé : Ombre réduite, fond `#F1F5F9`

```
┌─────────────────────────┐
│                         │
│  Contenu de la carte    │
│                         │
└─────────────────────────┘
```

#### 5.5.2 Listes
- Hauteur des items : 64pt
- Séparateurs : Ligne 1pt, `#E2E8F0`
- Padding horizontal : 16pt
- Structure :
  - Icône/image à gauche (optionnel)
  - Texte principal et secondaire
  - Indicateur d'action à droite (optionnel)

```
┌─────────────────────────┐
│ ●  Titre principal     >│
│    Texte secondaire     │
└─────────────────────────┘
```

#### 5.5.3 Grilles
- Espacement : 8pt
- Ratio des images : 1:1, 4:3 ou 16:9 selon contexte
- Rayon de bordure des images : 8pt

#### 5.5.4 Tableaux
- En-têtes : Fond `#F1F5F9`, texte `#64748B`, 14pt, semi-gras
- Rangées : Alternance de `#FFFFFF` et `#F8FAFC`
- Bordures : 1pt, `#E2E8F0`

### 5.6 Composants de feedback

#### 5.6.1 Messages toast
- Durée : 3 secondes
- Position : Bas de l'écran, marge de 16pt
- Rayon de bordure : 8pt
- Fond : `#1E293B` (opacité 90%)
- Texte : `#FFFFFF`, 14pt
- Icône : 20pt, selon type (succès, erreur, etc.)
- Comportement : Entrée par le bas, possibilité de balayer pour fermer

```
┌─────────────────────────┐
│ ✓ Message de succès     │
└─────────────────────────┘
```

#### 5.6.2 Boîtes de dialogue
- Rayon de bordure : 16pt
- Fond : `#FFFFFF`
- Titre : 18pt, semi-gras
- Corps : 16pt
- Boutons d'action : Alignés horizontalement (iOS), empilés (Android)
- Overlay : Fond noir, opacité 50%

```
┌─────────────────────────┐
│ Titre                   │
│                         │
│ Contenu du message sur  │
│ plusieurs lignes si     │
│ nécessaire.             │
│                         │
│ [ Annuler ]  [ OK ]     │
└─────────────────────────┘
```

#### 5.6.3 Indicateurs de chargement
- Spinner iOS : Taille standard de la plateforme
- Spinner Android : Circulaire, couleur primaire
- Barre de progression : Hauteur 4pt, animation fluide
- Placeholder de contenu : Animation de pulse subtile

### 5.7 Composants spécifiques à PhotoListing

#### 5.7.1 Visionneuse de comparaison avant/après
- Contrôle par glissement horizontal
- Ligne de séparation : 2pt, blanc avec ombre subtile
- Indicateur de position : Cercle 24pt, blanc avec ombre
- Animation fluide au toucher et relâchement

#### 5.7.2 Sélecteur de préréglages
- Format : Carrousel horizontal
- Taille des items : 80pt x 80pt
- Aperçu : Miniature représentative de l'effet
- Étiquette : 12pt, sous l'aperçu
- Indication de sélection : Bordure 2pt, couleur primaire

#### 5.7.3 Contrôle d'intensité
- Type : Slider personnalisé
- Étiquettes textuelles aux extrémités
- Valeurs prédéfinies : 5 niveaux (très léger, léger, modéré, marqué, fort)
- Retour haptique à chaque niveau

## 6. Adaptations par plateforme

### 6.1 Spécificités iOS
- Respect du safe area pour les dispositifs avec encoche
- Support des gestes de retour par balayage depuis le bord gauche
- Force Touch pour les aperçus rapides
- Support des actions contextuelles (3D Touch/Haptic Touch)
- Utilisation des contrôles natifs iOS lorsque possible

### 6.2 Spécificités Android
- Respect des thèmes système (clair/sombre)
- Adaptation aux différentes densités d'écran
- Support du bouton de retour matériel
- Gestion des permissions Android 11+
- Animations Material Design

### 6.3 Optimisations pour tablettes
- Layout adaptatif avec colonnes multiples en mode paysage
- Tiroirs latéraux permanents (non modaux)
- Utilisation optimisée de l'espace écran supplémentaire
- Split view pour la comparaison avant/après

## 7. Accessibilité

### 7.1 Contrastes et lisibilité
- Respect des ratios de contraste WCAG 2.1 niveau AA minimum
- Texte redimensionnable jusqu'à 200% sans perte de fonctionnalité
- Aucune information transmise uniquement par la couleur

### 7.2 Support des technologies d'assistance
- Libellés d'accessibilité pour tous les contrôles interactifs
- Structure hiérarchique logique pour VoiceOver/TalkBack
- Support de la navigation au clavier
- Descriptions alternatives pour toutes les images fonctionnelles

### 7.3 Interactions alternatives
- Cibles tactiles minimum de 44x44pt
- Délais ajustables pour les actions minutées
- Alternatives aux gestes complexes
- Support du mode sans animation

## 8. Transitions et animations

### 8.1 Transitions de page
- Durée : 300ms
- Courbe d'accélération : Ease-in-out naturelle
- Types selon contexte :
  - Horizontale pour navigation hiérarchique
  - Verticale pour modals et bottom sheets
  - Fade pour les changements de section majeurs

### 8.2 Micro-interactions
- Durée : 150-200ms
- Subtiles mais perceptibles
- Exemples :
  - Ripple effect sur les éléments tactiles (Android)
  - Scale+opacity pour feedback de toucher
  - Rotation et morphing des icônes lors des changements d'état

### 8.3 Animations fonctionnelles
- Indicateurs de chargement
- Transformations avant/après des photos
- Animation du curseur de comparaison
- Déplacement des éléments lors du réordonnancement

## 9. Ressources et exportation

### 9.1 Formats de ressources
- Images : SVG pour icônes, PNG 1x/2x/3x pour illustrations complexes
- Polices : Formats standards (.ttf, .otf)
- Animations : Lottie JSON pour animations complexes

### 9.2 Conventions de nommage
- Pattern : `composant_variation_état_taille`
- Exemple : `button_primary_pressed_large`
- Utilisation de tirets bas pour séparer les segments

### 9.3 Organisation des assets
- Structure par composant puis par plateforme
- Répertoires séparés pour icônes, illustrations et animations
- Versionning clair avec numérotation sémantique

## 10. Implémentation technique

### 10.1 Frameworks UI
- iOS : SwiftUI avec UIKit pour les composants complexes
- Android : Jetpack Compose avec support Material Design
- Partagé : Flutter pour les composants communs

### 10.2 Stratégie des thèmes
- Centralisation des styles dans des fichiers thèmes
- Variables pour tous les attributs visuels
- Support du mode sombre et clair avec basculement automatique
- Préparation pour futurs thèmes personnalisés

### 10.3 Considérations de performance
- Utilisation judicieuse des ombres et effets de flou
- Compression optimisée des ressources
- Chargement différé des images haute résolution
- Recyclage des vues pour les listes longues