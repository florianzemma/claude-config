# Frontend Design Principles - Anti "AI Slop" Aesthetic

**⚠️ RÈGLE CRITIQUE : Éviter l'esthétique générique "AI slop" à tout prix**

Ce document définit les principes de design pour créer des interfaces **distinctives**, **surprenantes** et **délicieuses** qui se démarquent des outputs génériques d'IA.

## 🎯 Objectif Principal

Créer des frontends qui ont une **personnalité forte** et sont **contextuellement appropriés**, jamais génériques ou prévisibles.

---

## 1. 🔤 Typographie - Beautiful & Unique

### ❌ Fonts Génériques à ÉVITER ABSOLUMENT

**Ces fonts créent l'esthétique "AI slop" - NE JAMAIS les utiliser :**

- ❌ Inter (trop surexploitée par l'IA)
- ❌ Roboto (générique)
- ❌ Arial (sans personnalité)
- ❌ Helvetica (ennuyeux)
- ❌ System fonts (trop basique)
- ❌ Space Grotesk (devenue clichée - anciennement bonne mais maintenant overused)

### ✅ Fonts Recommandées (Exemples)

**Varier entre ces familles selon le contexte du projet :**

#### Serif (élégance, autorité)
```css
/* Élégant, éditorial */
font-family: 'Fraunces', serif;
font-family: 'Crimson Pro', serif;
font-family: 'Lora', serif;
font-family: 'Spectral', serif;

/* Moderne, tech */
font-family: 'Sora', serif;
font-family: 'Newsreader', serif;
```

#### Sans-Serif (modernité, clarté)
```css
/* Distinctif, géométrique */
font-family: 'Outfit', sans-serif;
font-family: 'Plus Jakarta Sans', sans-serif;
font-family: 'Manrope', sans-serif;
font-family: 'Archivo', sans-serif;

/* Humaniste, chaleureux */
font-family: 'Red Hat Display', sans-serif;
font-family: 'DM Sans', sans-serif;
font-family: 'Lexend', sans-serif;
```

#### Monospace (technique, code)
```css
/* Caractère fort */
font-family: 'JetBrains Mono', monospace;
font-family: 'Fira Code', monospace;
font-family: 'IBM Plex Mono', monospace;
font-family: 'Inconsolata', monospace;
```

#### Display (titres, impact)
```css
/* Attention-grabbing */
font-family: 'Clash Display', sans-serif;
font-family: 'Cabinet Grotesk', sans-serif;
font-family: 'General Sans', sans-serif;
font-family: 'Satoshi', sans-serif;
```

### 📋 Principe de Sélection

**Pour chaque projet, CHOISIR en fonction du contexte :**

| Type de Projet | Style | Font Suggestion |
|----------------|-------|-----------------|
| SaaS B2B | Professionnel, moderne | Outfit, Manrope, Red Hat Display |
| E-commerce | Élégant, accessible | DM Sans, Lexend, Crimson Pro |
| Blog/Magazine | Éditorial, lisible | Lora, Spectral, Newsreader |
| Developer Tool | Technique, précis | JetBrains Mono, IBM Plex Mono |
| Créatif/Agency | Bold, unique | Clash Display, Cabinet Grotesk |
| Fintech | Sérieux, fiable | Sora, Archivo, Plus Jakarta Sans |

### 🎨 Hiérarchie Typographique

```typescript
// Exemple de système typographique distinctif
const typography = {
  // Display - titres hero (font différente du body)
  display: {
    fontFamily: "'Clash Display', sans-serif",
    fontSize: '4rem',
    fontWeight: 600,
    lineHeight: 1.1,
  },

  // Headings - titres sections (peut être la même que display)
  h1: {
    fontFamily: "'Clash Display', sans-serif",
    fontSize: '3rem',
    fontWeight: 600,
    lineHeight: 1.2,
  },

  // Body - texte principal (font lisible)
  body: {
    fontFamily: "'DM Sans', sans-serif",
    fontSize: '1rem',
    fontWeight: 400,
    lineHeight: 1.6,
  },

  // Code/Mono - données techniques
  code: {
    fontFamily: "'JetBrains Mono', monospace",
    fontSize: '0.875rem',
    fontWeight: 400,
    lineHeight: 1.5,
  },
};
```

**✅ BON : Combiner 2-3 fonts avec rôles distincts**
```css
/* Titres : Font display avec personnalité */
h1, h2 { font-family: 'Clash Display', sans-serif; }

/* Corps : Font lisible et moderne */
body { font-family: 'DM Sans', sans-serif; }

/* Code : Monospace distinctif */
code { font-family: 'JetBrains Mono', monospace; }
```

**❌ MAUVAIS : Une seule font générique partout**
```css
* { font-family: 'Inter', sans-serif; } /* Trop uniforme, sans caractère */
```

---

## 2. 🎨 Color & Theme - Cohesive Aesthetics

### ❌ Palettes Génériques à ÉVITER

**Ces combinaisons créent l'esthétique "AI slop" :**

- ❌ Purple gradients sur fond blanc (ultra-cliché)
- ❌ Bleu ciel + gris clair (trop entreprise générique)
- ❌ Couleurs pastel équi-distribuées (sans dominance)
- ❌ Dégradés arc-en-ciel (trop prévisible)

### ✅ Approches Recommandées

#### Principe 1 : Dominant Color Strategy

**UNE couleur dominante (70%) + accents tranchants (20% + 10%)**

```typescript
// ✅ BON : Dominance claire
const theme = {
  // Couleur dominante (70% de l'interface)
  dominant: {
    bg: '#0A0E27',      // Bleu nuit profond
    text: '#E4E7EB',    // Gris très clair
  },

  // Accent primaire (20%)
  accent1: {
    primary: '#00FFA3',  // Vert néon - tranche avec le fond
    hover: '#00CC82',
  },

  // Accent secondaire (10%)
  accent2: {
    warning: '#FF6B35',  // Orange vif
    success: '#00FFA3',
  },
};
```

#### Principe 2 : Theme Inspiration Sources

**S'inspirer de sources distinctives, PAS de Material Design ou Bootstrap :**

```typescript
// Exemples de palettes inspirées de IDE themes
const inspirations = {
  // Tokyo Night (IDE theme)
  tokyoNight: {
    bg: '#1a1b26',
    fg: '#c0caf5',
    accent: '#7aa2f7',
    accent2: '#bb9af7',
  },

  // Catppuccin Mocha
  catppuccin: {
    bg: '#1e1e2e',
    fg: '#cdd6f4',
    accent: '#89b4fa',
    accent2: '#f5c2e7',
  },

  // Dracula
  dracula: {
    bg: '#282a36',
    fg: '#f8f8f2',
    accent: '#ff79c6',
    accent2: '#8be9fd',
  },

  // Nordic (inspiration scandinave)
  nordic: {
    bg: '#2e3440',
    fg: '#eceff4',
    accent: '#88c0d0',
    accent2: '#a3be8c',
  },
};
```

#### Principe 3 : Cultural & Contextual Aesthetics

```typescript
// S'adapter au contexte culturel/métier du projet
const contextualThemes = {
  // Fintech - Sérieux, fiable (verts/bleus profonds)
  fintech: {
    bg: '#0D1B2A',
    primary: '#1B998B',
    accent: '#00D9FF',
  },

  // Gaming - Vibrant, énergique (néons)
  gaming: {
    bg: '#0A0E27',
    primary: '#00FFA3',
    accent: '#FF006E',
  },

  // Health - Apaisant, accessible (bleus doux, verts)
  health: {
    bg: '#F0F4F8',
    primary: '#2C5F2D',
    accent: '#00A8E8',
  },

  // Creative Agency - Bold, inattendu
  creative: {
    bg: '#FFFAEB',
    primary: '#FF006E',
    accent: '#3A86FF',
  },
};
```

### 🎨 CSS Variables Strategy

**TOUJOURS utiliser CSS variables pour cohérence :**

```css
:root {
  /* Base colors - dominante */
  --color-bg-primary: #0A0E27;
  --color-bg-secondary: #151A35;
  --color-text-primary: #E4E7EB;
  --color-text-secondary: #9CA3AF;

  /* Accents - tranchants */
  --color-accent-primary: #00FFA3;
  --color-accent-secondary: #FF6B35;

  /* Functional */
  --color-success: #00FFA3;
  --color-error: #FF6B6B;
  --color-warning: #FFB703;
  --color-info: #3A86FF;

  /* Surfaces */
  --color-surface-raised: rgba(255, 255, 255, 0.05);
  --color-surface-overlay: rgba(0, 0, 0, 0.8);
}

[data-theme="light"] {
  --color-bg-primary: #FAFAFA;
  --color-bg-secondary: #FFFFFF;
  --color-text-primary: #1A1A1A;
  --color-text-secondary: #6B7280;
  /* ... */
}
```

### ❌ Anti-Patterns

```css
/* ❌ MAUVAIS : Palette équi-distribuée sans dominance */
.button-primary { background: #6366F1; }
.button-secondary { background: #10B981; }
.button-tertiary { background: #F59E0B; }
.button-quaternary { background: #EF4444; }
/* Trop de couleurs égales = pas de hiérarchie visuelle */

/* ❌ MAUVAIS : Dégradé purple générique */
.hero {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
/* Ultra-cliché "AI slop" */

/* ✅ BON : Dominance + accents */
.button-primary {
  background: var(--color-accent-primary);
}
.button-secondary {
  background: transparent;
  border: 1px solid var(--color-accent-primary);
}
```

---

## 3. ⚡ Motion - Animation & Micro-interactions

### Principe : High-Impact Moments

**Une animation orchestrée > multiples micro-interactions dispersées**

### ✅ CSS-Only Solutions (Priorité)

```css
/* Animation de page load avec staggered reveals */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Délais échelonnés pour effet cascade */
.hero-title {
  animation: fadeInUp 0.6s ease-out;
}

.hero-subtitle {
  animation: fadeInUp 0.6s ease-out;
  animation-delay: 0.1s;
  opacity: 0;
  animation-fill-mode: forwards;
}

.hero-cta {
  animation: fadeInUp 0.6s ease-out;
  animation-delay: 0.2s;
  opacity: 0;
  animation-fill-mode: forwards;
}

/* Respect prefers-reduced-motion */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

### ✅ React + Framer Motion (High-Impact)

**Utiliser Motion library pour animations complexes en React :**

```typescript
import { motion } from 'framer-motion';

// Orchestration d'entrée de page
const pageVariants = {
  initial: { opacity: 0 },
  animate: { opacity: 1 },
  exit: { opacity: 0 },
};

const itemVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: (i: number) => ({
    opacity: 1,
    y: 0,
    transition: {
      delay: i * 0.1,
      duration: 0.6,
      ease: 'easeOut',
    },
  }),
};

export function HeroSection() {
  return (
    <motion.div
      variants={pageVariants}
      initial="initial"
      animate="animate"
      exit="exit"
    >
      <motion.h1
        custom={0}
        variants={itemVariants}
        initial="hidden"
        animate="visible"
      >
        Welcome
      </motion.h1>
      <motion.p
        custom={1}
        variants={itemVariants}
        initial="hidden"
        animate="visible"
      >
        Discover our platform
      </motion.p>
      <motion.button
        custom={2}
        variants={itemVariants}
        initial="hidden"
        animate="visible"
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
      >
        Get Started
      </motion.button>
    </motion.div>
  );
}
```

### 🎯 Animation Guidelines

```typescript
const animationPrinciples = {
  // Durées recommandées
  durations: {
    micro: '0.15s',        // Hover, focus
    short: '0.3s',         // Transitions simples
    medium: '0.6s',        // Entrées/sorties
    long: '1s',            // Animations complexes
  },

  // Easing functions (éviter linear)
  easings: {
    default: 'cubic-bezier(0.4, 0.0, 0.2, 1)',      // easeInOut
    entrance: 'cubic-bezier(0.0, 0.0, 0.2, 1)',     // easeOut
    exit: 'cubic-bezier(0.4, 0.0, 1, 1)',           // easeIn
    spring: 'cubic-bezier(0.34, 1.56, 0.64, 1)',    // overshoot
  },

  // Moments clés à animer
  moments: [
    'Page load (staggered reveal)',
    'Modal open/close',
    'Form submission success',
    'Data loading → success',
    'Critical errors',
  ],

  // À éviter
  avoid: [
    'Animations sur chaque hover (trop)',
    'Transitions > 1s (trop lent)',
    'Animations bloquantes',
    'Ignorer prefers-reduced-motion',
  ],
};
```

### ❌ Anti-Patterns

```typescript
// ❌ MAUVAIS : Animations partout sans raison
<Button
  whileHover={{ rotate: 360, scale: 1.5 }}  // Trop
  transition={{ duration: 2 }}              // Trop lent
>
  Click me
</Button>

// ❌ MAUVAIS : Transition lente sans raison
.card {
  transition: all 1.5s linear;  // Trop lent + linear = mauvais
}

// ✅ BON : Animation ciblée, rapide, avec bon easing
.card {
  transition: transform 0.3s cubic-bezier(0.4, 0.0, 0.2, 1);
}

.card:hover {
  transform: translateY(-4px);
}
```

---

## 4. 🌄 Backgrounds - Atmosphere & Depth

### ❌ À ÉVITER

- ❌ Fonds blancs/gris unis (trop plat)
- ❌ Dégradés génériques (purple gradient)
- ❌ Patterns répétitifs sans subtilité

### ✅ Approaches Recommandées

#### Layered CSS Gradients

```css
/* Gradients multicouches pour profondeur */
.hero-background {
  background:
    /* Noise texture subtle */
    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='200' height='200'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' /%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.05'/%3E%3C/svg%3E"),

    /* Gradient radial pour focus */
    radial-gradient(
      circle at 20% 50%,
      rgba(0, 255, 163, 0.15) 0%,
      transparent 50%
    ),

    /* Gradient de base */
    linear-gradient(
      135deg,
      #0A0E27 0%,
      #151A35 100%
    );
}
```

#### Geometric Patterns

```css
/* Grille subtile */
.background-grid {
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.03) 1px, transparent 1px);
  background-size: 50px 50px;
  background-color: #0A0E27;
}

/* Dots pattern */
.background-dots {
  background-image: radial-gradient(
    circle,
    rgba(255, 255, 255, 0.1) 1px,
    transparent 1px
  );
  background-size: 24px 24px;
  background-color: #0A0E27;
}
```

#### Context-Specific Effects

```typescript
// Effets contextuels selon le type de page
const backgroundEffects = {
  // Landing page - Dramatic
  landing: `
    background:
      radial-gradient(circle at top right, rgba(0, 255, 163, 0.1), transparent),
      radial-gradient(circle at bottom left, rgba(255, 107, 53, 0.1), transparent),
      #0A0E27;
  `,

  // Dashboard - Subtle, fonctionnel
  dashboard: `
    background:
      linear-gradient(rgba(255, 255, 255, 0.02) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255, 255, 255, 0.02) 1px, transparent 1px),
      #0A0E27;
    background-size: 40px 40px;
  `,

  // Auth pages - Clean avec focal point
  auth: `
    background:
      radial-gradient(ellipse at center, rgba(0, 255, 163, 0.05), transparent 70%),
      #0A0E27;
  `,
};
```

#### Animated Backgrounds (Subtil)

```css
/* Gradient animé subtil */
@keyframes gradientShift {
  0%, 100% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
}

.animated-background {
  background: linear-gradient(
    270deg,
    #0A0E27,
    #151A35,
    #0A0E27
  );
  background-size: 400% 400%;
  animation: gradientShift 15s ease infinite;
}
```

---

## 5. 🚫 Anti "AI Slop" Checklist

### Checklist de Validation (OBLIGATOIRE)

Avant de livrer un design, vérifier :

```
TYPOGRAPHIE
□ Aucune font générique (Inter, Roboto, Arial, Space Grotesk) utilisée ?
□ Au moins 2 fonts différentes (display + body) ?
□ Fonts choisies en fonction du contexte projet ?
□ Hiérarchie typographique claire (3+ niveaux) ?

COULEURS
□ Évite purple gradient sur blanc ?
□ Palette a une couleur DOMINANTE (70%) claire ?
□ Accents tranchants (pas pastel équi-distribué) ?
□ Inspiration contextuelle (pas Material/Bootstrap) ?
□ CSS variables utilisées partout ?
□ Dark mode ET light mode considérés ?

MOTION
□ Animations ciblées sur moments clés (pas partout) ?
□ CSS-only privilégié pour HTML simple ?
□ Framer Motion utilisé pour React complexe ?
□ Staggered reveals sur page load ?
□ prefers-reduced-motion respecté ?
□ Durées < 1s (sauf animations complexes justifiées) ?

BACKGROUNDS
□ Évite fonds unis blancs/gris ?
□ Utilise layered gradients OU patterns ?
□ Crée profondeur/atmosphère ?
□ Contextuellement approprié ?

GÉNÉRAL
□ Design a une PERSONNALITÉ distincte ?
□ Surprise et délice l'utilisateur ?
□ N'est PAS prévisible/générique ?
□ Adapté au contexte métier du projet ?
□ Aucun pattern "cookie-cutter" ?
```

### ❌ Red Flags "AI Slop"

**Si un design a ces caractéristiques, LE REJETER :**

```
🚨 RED FLAGS
□ Utilise Inter ou Space Grotesk
□ Purple gradient sur fond blanc
□ Layout prévisible (header, hero centré, 3 cards, footer)
□ Couleurs pastel équi-distribuées
□ Aucune animation / micro-interactions
□ Fonds unis sans texture
□ Ressemble à un template Tailwind UI générique
□ Pourrait être n'importe quel SaaS
□ Aucune personnalité visuelle
```

---

## 6. 📚 Sources d'Inspiration (Recommandées)

### Design Systems à Étudier (PAS copier)

- **Linear** : Typographie exceptionnelle, animations subtiles
- **Vercel** : Minimalisme avec caractère
- **Stripe** : Gradients contextuels, motion design
- **Resend** : Couleurs bold, layouts uniques
- **Railway** : Dark theme référence

### IDE Themes pour Palettes

- Tokyo Night
- Catppuccin
- Dracula
- Nord/Nordic
- Gruvbox
- One Dark Pro

### Ressources

```typescript
const resources = {
  fonts: [
    'https://fonts.google.com',
    'https://fontsource.org',
  ],
  colors: [
    'https://uicolors.app',
    'https://colorhunt.co',
  ],
  gradients: [
    'https://cssgradient.io',
    'https://www.gradientmagic.com',
  ],
  patterns: [
    'https://heropatterns.com',
    'https://www.magicpattern.design/tools/css-backgrounds',
  ],
};
```

---

## 7. 🎯 Examples Concrets

### ✅ EXEMPLE BON : SaaS Dashboard

```typescript
// Theme distinctif inspiré de Tokyo Night
const theme = {
  colors: {
    // Dominance : Dark blue profond
    bg: '#1a1b26',
    bgSecondary: '#24283b',

    // Accents tranchants
    primary: '#7aa2f7',    // Bleu vif
    accent: '#bb9af7',     // Purple unique
    success: '#9ece6a',
    error: '#f7768e',

    // Text
    text: '#c0caf5',
    textMuted: '#565f89',
  },

  fonts: {
    display: "'Clash Display', sans-serif",
    body: "'DM Sans', sans-serif",
    mono: "'JetBrains Mono', monospace",
  },

  animations: {
    // Page load staggered
    pageEnter: {
      duration: 0.6,
      stagger: 0.1,
      ease: 'easeOut',
    },
  },
};

// Composant avec animations orchestrées
export function Dashboard() {
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      className="min-h-screen bg-[#1a1b26]"
      style={{
        backgroundImage: `
          linear-gradient(rgba(122, 162, 247, 0.03) 1px, transparent 1px),
          linear-gradient(90deg, rgba(122, 162, 247, 0.03) 1px, transparent 1px)
        `,
        backgroundSize: '40px 40px',
      }}
    >
      <motion.h1
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1, duration: 0.6 }}
        style={{ fontFamily: "'Clash Display', sans-serif" }}
        className="text-4xl font-semibold text-[#c0caf5]"
      >
        Analytics Dashboard
      </motion.h1>

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2, duration: 0.6 }}
        className="grid grid-cols-3 gap-4"
      >
        {/* Cards avec hover subtil */}
        <Card />
      </motion.div>
    </motion.div>
  );
}
```

### ❌ EXEMPLE MAUVAIS : SaaS Generic

```typescript
// ❌ Theme générique "AI slop"
const badTheme = {
  colors: {
    bg: '#ffffff',           // Blanc pur sans caractère
    primary: '#6366F1',      // Indigo générique
    secondary: '#8B5CF6',    // Purple cliché
  },

  fonts: {
    all: "'Inter', sans-serif",  // Inter partout = générique
  },

  // Pas d'animations = plat
};

// Composant sans personnalité
export function Dashboard() {
  return (
    <div className="min-h-screen bg-white">  {/* Fond blanc plat */}
      <h1 className="text-4xl font-bold" style={{ fontFamily: 'Inter' }}>
        {/* Inter = générique */}
        Analytics Dashboard
      </h1>

      <div className="grid grid-cols-3 gap-4">
        {/* Layout prévisible */}
        <Card />
      </div>
    </div>
  );
}
```

---

## 8. 🎨 Implementation Workflow

### Processus DESIGNER

```
1. ANALYSE DU CONTEXTE
   □ Type de projet ? (SaaS, e-commerce, blog, etc.)
   □ Audience cible ? (B2B, B2C, dev, etc.)
   □ Émotion recherchée ? (sérieux, playful, élégant, etc.)

2. SÉLECTION FONTS
   □ Choisir 2-3 fonts en fonction du contexte
   □ ❌ JAMAIS Inter, Roboto, Arial, Space Grotesk
   □ Tester lisibilité + personnalité

3. CRÉATION PALETTE
   □ Déterminer couleur DOMINANTE (70%)
   □ Choisir 1-2 accents tranchants
   □ S'inspirer de IDE themes ou contexte culturel
   □ ❌ ÉVITER purple gradients génériques

4. DESIGN MOTION
   □ Identifier moments clés (page load, modal, success)
   □ Créer orchestration staggered pour page load
   □ CSS-only si HTML, Framer Motion si React

5. BACKGROUNDS
   □ Créer profondeur (layered gradients, patterns)
   □ Adapter au contexte (landing vs dashboard)
   □ ❌ ÉVITER fonds unis

6. VALIDATION ANTI-SLOP
   □ Checker la checklist section 5
   □ Si 1 seul red flag → REVOIR
```

---

## 9. ⚙️ Configuration Technique

### Installation Fonts (Google Fonts)

```typescript
// next.config.js - Next.js avec next/font
import { Plus_Jakarta_Sans, Clash_Display, JetBrains_Mono } from 'next/font/google';

const jakarta = Plus_Jakarta_Sans({
  subsets: ['latin'],
  variable: '--font-jakarta',
});

const clash = Clash_Display({
  subsets: ['latin'],
  variable: '--font-clash',
  display: 'swap',
});

const jetbrains = JetBrains_Mono({
  subsets: ['latin'],
  variable: '--font-mono',
});

// Utiliser dans layout
<body className={`${jakarta.variable} ${clash.variable} ${jetbrains.variable}`}>
```

### CSS Variables pour Fonts

```css
:root {
  --font-display: 'Clash Display', sans-serif;
  --font-body: 'DM Sans', sans-serif;
  --font-mono: 'JetBrains Mono', monospace;
}

h1, h2, h3 {
  font-family: var(--font-display);
}

body {
  font-family: var(--font-body);
}

code, pre {
  font-family: var(--font-mono);
}
```

### Tailwind Config

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        display: ['var(--font-clash)', 'sans-serif'],
        body: ['var(--font-jakarta)', 'sans-serif'],
        mono: ['var(--font-jetbrains)', 'monospace'],
      },
      colors: {
        // Tokyo Night inspired
        'primary-bg': '#1a1b26',
        'secondary-bg': '#24283b',
        'accent-blue': '#7aa2f7',
        'accent-purple': '#bb9af7',
        'accent-green': '#9ece6a',
        'text-primary': '#c0caf5',
        'text-muted': '#565f89',
      },
      animation: {
        'fade-in-up': 'fadeInUp 0.6s ease-out',
        'stagger-1': 'fadeInUp 0.6s ease-out 0.1s both',
        'stagger-2': 'fadeInUp 0.6s ease-out 0.2s both',
        'stagger-3': 'fadeInUp 0.6s ease-out 0.3s both',
      },
      keyframes: {
        fadeInUp: {
          '0%': { opacity: '0', transform: 'translateY(20px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
      },
    },
  },
};
```

---

## 10. 📋 Responsabilités des Agents

### DESIGNER

**DOIT systématiquement :**
- ✅ Choisir fonts distinctives (JAMAIS Inter/Roboto/Arial/Space Grotesk)
- ✅ Créer palette avec dominance claire
- ✅ Designer animations orchestrées (staggered page load)
- ✅ Créer backgrounds avec profondeur
- ✅ Valider contre checklist anti-slop (section 5)
- ✅ Documenter choix de design dans code comments

**DOIT BLOQUER si :**
- ❌ Font générique détectée
- ❌ Purple gradient sur blanc
- ❌ Aucune animation prévue
- ❌ Fond uni sans texture
- ❌ Design générique sans personnalité

### FULLSTACK_DEV

**DOIT :**
- ✅ Implémenter exactement les fonts spécifiées par DESIGNER
- ✅ Utiliser CSS variables pour couleurs
- ✅ Implémenter animations (CSS ou Framer Motion)
- ✅ Respecter prefers-reduced-motion
- ✅ Ne JAMAIS remplacer par Inter "pour aller plus vite"

### REVIEWER

**DOIT vérifier :**
- ✅ Fonts != Inter/Roboto/Arial/Space Grotesk
- ✅ Palette a dominance claire (pas équi-distribuée)
- ✅ Animations présentes et fluides
- ✅ Backgrounds créent atmosphère
- ✅ Design a personnalité contextuelle

**DOIT REJETER si :**
- ❌ Font générique utilisée
- ❌ Esthétique "AI slop" détectée
- ❌ Design prévisible/cookie-cutter

### ARCHITECT

**DOIT :**
- ✅ Approuver setup fonts (next/font, etc.)
- ✅ Valider stratégie CSS variables
- ✅ Vérifier performance (font loading)
- ✅ Approuver choix Framer Motion si justifié

---

## ✅ Conclusion

**L'objectif : Créer des frontends qui ont du CARACTÈRE et sont MÉMORABLES.**

### Règles d'Or

1. **Fonts** : JAMAIS Inter/Roboto/Arial/Space Grotesk → Choisir avec intention
2. **Couleurs** : Dominance 70% + accents tranchants → Pas équi-distribution
3. **Motion** : Moments clés orchestrés → Pas animations partout
4. **Backgrounds** : Profondeur et atmosphère → Pas fonds unis
5. **Contexte** : Adapter au projet → Pas design générique

### Checklist Rapide

```
□ Fonts distinctives choisies ?
□ Palette dominante claire ?
□ Animations orchestrées (page load) ?
□ Backgrounds avec profondeur ?
□ Design contextuel et mémorable ?
□ AUCUN red flag "AI slop" ?
```

**Si tout ✅ → Le design est prêt à implémenter.**
**Si 1 seul ❌ → REVOIR le design.**

---

**Pour questions/exemples supplémentaires, consulter DESIGNER ou ARCHITECT.**
