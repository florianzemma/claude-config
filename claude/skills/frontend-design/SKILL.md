---
name: frontend-design
description: Anti "AI slop" design principles for distinctive UIs. Use when choosing fonts, colors, animations, or reviewing frontend designs. Prevents generic-looking interfaces.
---

# Frontend Design - Anti "AI Slop" Principles

## Goal
Create frontends with **strong personality** that are **contextually appropriate**, never generic or predictable.

## 1. Typography

### Fonts to AVOID (Creates "AI slop")

- Inter (overused by AI)
- Roboto (generic)
- Arial, Helvetica (no personality)
- Space Grotesk (became cliché)

### Recommended Fonts

**Serif (elegance):**
- Fraunces, Crimson Pro, Lora, Spectral

**Sans-Serif (modern):**
- Outfit, Plus Jakarta Sans, Manrope, DM Sans, Red Hat Display

**Monospace (technical):**
- JetBrains Mono, Fira Code, IBM Plex Mono

**Display (impact):**
- Clash Display, Cabinet Grotesk, Satoshi

### Font Selection by Context

| Project Type | Font Suggestion |
|--------------|-----------------|
| SaaS B2B | Outfit, Manrope, Red Hat Display |
| E-commerce | DM Sans, Lexend, Crimson Pro |
| Blog/Magazine | Lora, Spectral, Newsreader |
| Dev Tool | JetBrains Mono, IBM Plex Mono |
| Creative Agency | Clash Display, Cabinet Grotesk |
| Fintech | Sora, Archivo, Plus Jakarta Sans |

### Typography Hierarchy

```css
/* Display + Body + Mono = 3 distinct roles */
h1, h2 { font-family: 'Clash Display', sans-serif; }
body { font-family: 'DM Sans', sans-serif; }
code { font-family: 'JetBrains Mono', monospace; }
```

## 2. Colors

### Palettes to AVOID

- Purple gradients on white (ultra-cliché)
- Light blue + light gray (generic corporate)
- Equally distributed pastels (no hierarchy)
- Rainbow gradients

### Dominant Color Strategy

**ONE dominant color (70%) + accent (20%) + secondary (10%)**

```typescript
const theme = {
  dominant: { bg: '#0A0E27', text: '#E4E7EB' },  // 70%
  accent1: { primary: '#00FFA3', hover: '#00CC82' },  // 20%
  accent2: { warning: '#FF6B35' },  // 10%
};
```

### Inspiration Sources (NOT Material/Bootstrap)

```typescript
// IDE themes for palettes
const tokyoNight = { bg: '#1a1b26', fg: '#c0caf5', accent: '#7aa2f7' };
const catppuccin = { bg: '#1e1e2e', fg: '#cdd6f4', accent: '#89b4fa' };
const dracula = { bg: '#282a36', fg: '#f8f8f2', accent: '#ff79c6' };
const nordic = { bg: '#2e3440', fg: '#eceff4', accent: '#88c0d0' };
```

### Contextual Themes

```typescript
const themes = {
  fintech: { bg: '#0D1B2A', primary: '#1B998B', accent: '#00D9FF' },
  gaming: { bg: '#0A0E27', primary: '#00FFA3', accent: '#FF006E' },
  health: { bg: '#F0F4F8', primary: '#2C5F2D', accent: '#00A8E8' },
  creative: { bg: '#FFFAEB', primary: '#FF006E', accent: '#3A86FF' },
};
```

## 3. Motion & Animation

### Principle: High-Impact Moments

One orchestrated animation > multiple scattered micro-interactions

### CSS-Only (Priority)

```css
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.hero-title { animation: fadeInUp 0.6s ease-out; }
.hero-subtitle { animation: fadeInUp 0.6s ease-out 0.1s both; }
.hero-cta { animation: fadeInUp 0.6s ease-out 0.2s both; }

/* Respect user preference */
@media (prefers-reduced-motion: reduce) {
  * { animation-duration: 0.01ms !important; }
}
```

### Framer Motion (React)

```tsx
const itemVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: (i: number) => ({
    opacity: 1, y: 0,
    transition: { delay: i * 0.1, duration: 0.6, ease: 'easeOut' },
  }),
};

<motion.h1 custom={0} variants={itemVariants} initial="hidden" animate="visible">
  Welcome
</motion.h1>
```

### Animation Guidelines

- **Durations**: micro 0.15s, short 0.3s, medium 0.6s, long 1s
- **Easing**: Never linear. Use `cubic-bezier(0.4, 0.0, 0.2, 1)`
- **When**: Page load, modal open/close, form success, data loading
- **Avoid**: Animation on every hover, transitions > 1s

## 4. Backgrounds

### Avoid
- Plain white/gray (too flat)
- Generic gradients
- Repetitive patterns without subtlety

### Layered Gradients

```css
.hero-background {
  background:
    radial-gradient(circle at 20% 50%, rgba(0, 255, 163, 0.15) 0%, transparent 50%),
    linear-gradient(135deg, #0A0E27 0%, #151A35 100%);
}
```

### Geometric Patterns

```css
/* Subtle grid */
.background-grid {
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.03) 1px, transparent 1px);
  background-size: 50px 50px;
  background-color: #0A0E27;
}
```

## 5. Anti-Slop Checklist

### Must Check

```
TYPOGRAPHY
[] No generic fonts (Inter, Roboto, Arial)?
[] 2+ fonts with distinct roles (display + body)?
[] Clear hierarchy (3+ levels)?

COLORS
[] No purple gradient on white?
[] Clear dominant color (70%)?
[] Sharp accents (not pastel rainbow)?
[] CSS variables everywhere?

MOTION
[] Animations on key moments only?
[] Staggered page load reveals?
[] prefers-reduced-motion respected?
[] Durations < 1s?

BACKGROUNDS
[] No plain white/gray?
[] Layered gradients or patterns?
[] Creates atmosphere?

GENERAL
[] Design has distinct PERSONALITY?
[] Contextually appropriate?
[] Not predictable/generic?
```

### Red Flags (REJECT if present)

- Uses Inter or Space Grotesk
- Purple gradient on white background
- Predictable layout (header, centered hero, 3 cards, footer)
- Equally distributed pastel colors
- No animations
- Plain backgrounds
- Looks like generic Tailwind UI template
- Could be any SaaS

## 6. Implementation

### Next.js Font Setup

```typescript
import { Plus_Jakarta_Sans, JetBrains_Mono } from 'next/font/google';

const jakarta = Plus_Jakarta_Sans({ subsets: ['latin'], variable: '--font-jakarta' });
const jetbrains = JetBrains_Mono({ subsets: ['latin'], variable: '--font-mono' });

// In layout
<body className={`${jakarta.variable} ${jetbrains.variable}`}>
```

### Tailwind Config

```javascript
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        display: ['var(--font-clash)', 'sans-serif'],
        body: ['var(--font-jakarta)', 'sans-serif'],
        mono: ['var(--font-jetbrains)', 'monospace'],
      },
      colors: {
        'primary-bg': '#1a1b26',
        'accent-blue': '#7aa2f7',
        'text-primary': '#c0caf5',
      },
    },
  },
};
```

## Design Inspirations

**Study (don't copy):**
- Linear (typography, subtle animations)
- Vercel (minimalism with character)
- Stripe (contextual gradients, motion)
- Resend (bold colors, unique layouts)
- Railway (dark theme reference)
