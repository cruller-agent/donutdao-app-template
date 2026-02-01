# DonutDAO Design System 🍩

**Based on GlazeCorp's design system by @Heesho**

Sleek, modern, dark aesthetic with pink accents - perfect for DonutDAO apps.

---

## Color Palette

### Primary: Pink/Donut Theme

```
donut-50:  #fdf2f8  (lightest pink)
donut-100: #fce7f3
donut-200: #fbcfe8
donut-300: #f9a8d4
donut-400: #f472b6
donut-500: #ec4899  ← PRIMARY (use for CTAs, accents, branding)
donut-600: #db2777
donut-700: #be185d
donut-800: #9d174d
donut-900: #831843  (darkest pink)
```

### Grayscale: Corporate

```
corp-50:  #fafafa  (lightest gray - text)
corp-100: #f4f4f5
corp-200: #e4e4e7
corp-300: #d4d4d8
corp-400: #a1a1aa
corp-500: #71717a
corp-600: #52525b
corp-700: #3f3f46
corp-800: #27272a  (borders, inputs)
corp-900: #18181b  (cards, muted backgrounds)
corp-950: #09090b  ← BACKGROUND (primary dark)
```

### Semantic Colors

```
Background: corp-950 (#09090b) - almost black
Foreground: corp-50 (#fafafa) - almost white
Accent: donut-500 (#ec4899) - pink
Border: corp-800 (#27272a) - dark gray
Success: #22c55e (green)
Destructive: #ef4444 (red)
```

---

## Typography

### Font Stack

```css
/* Sans-serif (default) */
font-family: Inter, system-ui, sans-serif;

/* Monospace (code, numbers) */
font-family: JetBrains Mono, monospace;
```

### Heading Sizes

```
h1: 2.25rem (36px) - Hero titles
h2: 1.5rem (24px) - Section headers
h3: 1.25rem (20px) - Subsections
```

### Text Styles

```jsx
<h1 className="text-gradient">DonutDAO</h1>  // Pink gradient
<p className="text-glow">Important text</p>  // Pink glow
<span className="text-corp-400">Muted</span> // Gray
```

---

## Components

### Buttons

```jsx
// Primary (pink)
<button className="btn btn-primary">
  Connect Wallet
</button>

// Secondary (gray)
<button className="btn btn-secondary">
  Cancel
</button>

// Ghost (transparent)
<button className="btn btn-ghost">
  Settings
</button>
```

### Cards

```jsx
// Standard card
<div className="card-donut p-6">
  <h3>Card Title</h3>
  <p>Content...</p>
</div>

// Card with glow
<div className="card-donut-glow p-6">
  <h3>Featured Card</h3>
  <p>Premium content...</p>
</div>
```

### Inputs

```jsx
<input 
  className="input-donut" 
  placeholder="Enter amount..."
/>
```

---

## Backgrounds

### Solid Backgrounds

```jsx
// Primary dark background
<div className="bg-corp-950">...</div>

// Card background
<div className="bg-corp-900">...</div>

// Muted background
<div className="bg-corp-800">...</div>
```

### Gradient Backgrounds

```jsx
// DonutDAO branded gradient
<div className="bg-donutdao">
  // Subtle pink glow from top
</div>

// DonutDAO with stronger glow
<div className="bg-donutdao-glow">
  // Pink glows from multiple corners
</div>

// Glass effect (frosted glass)
<div className="bg-glass">
  // Blurred dark background
</div>
```

### Pattern Backgrounds

```jsx
// Small donut pattern
<div className="bg-donuts bg-corp-950">...</div>

// Large donut pattern
<div className="bg-donuts-large bg-corp-950">...</div>
```

---

## Layout Example

```jsx
export default function HomePage() {
  return (
    <div className="min-h-screen bg-donutdao-glow">
      {/* Header */}
      <header className="border-b border-corp-800 bg-glass">
        <div className="container mx-auto px-4 py-4 flex justify-between items-center">
          <h1 className="text-gradient text-2xl font-bold">DonutDAO</h1>
          <button className="btn btn-primary">Connect</button>
        </div>
      </header>

      {/* Hero */}
      <section className="container mx-auto px-4 py-20 text-center">
        <h1 className="text-5xl font-bold mb-4 text-glow">
          Build on DonutDAO
        </h1>
        <p className="text-corp-300 text-lg max-w-2xl mx-auto">
          Fair token distribution, revenue routing, and agent-first infrastructure
        </p>
      </section>

      {/* Features */}
      <section className="container mx-auto px-4 py-12 grid md:grid-cols-3 gap-6">
        <div className="card-donut p-6">
          <h3 className="font-semibold mb-2">LiquidSignal</h3>
          <p className="text-corp-400 text-sm">
            Route revenue to gDONUT holders
          </p>
        </div>

        <div className="card-donut-glow p-6">
          <h3 className="font-semibold mb-2">Farplace</h3>
          <p className="text-corp-400 text-sm">
            Fair token launches via mining
          </p>
        </div>

        <div className="card-donut p-6">
          <h3 className="font-semibold mb-2">DONUT Token</h3>
          <p className="text-corp-400 text-sm">
            Ecosystem currency on Base
          </p>
        </div>
      </section>
    </div>
  );
}
```

---

## Effects & Animations

### Text Effects

```jsx
<h1 className="text-gradient">Gradient Text</h1>
<p className="text-glow">Glowing Text</p>
```

### Animations

```jsx
<div className="animate-fade-in">Fades in</div>
<div className="animate-slide-up">Slides up</div>
<div className="animate-glow">Glowing pulse</div>
```

### Box Effects

```jsx
<div className="shadow-glow">Soft pink glow</div>
<div className="shadow-glow-lg">Strong pink glow</div>
```

---

## Best Practices

### Do's ✅

- Use `donut-500` for primary CTAs and accents
- Use `corp-950` as default background
- Use `corp-50` for primary text
- Use `corp-400` for muted/secondary text
- Add subtle glows to important elements
- Keep layouts clean with ample whitespace
- Use cards (`card-donut`) to group related content

### Don'ts ❌

- Don't use bright colors for large areas (overwhelming)
- Don't use pure white (#ffffff) - use `corp-50` instead
- Don't use pure black (#000000) - use `corp-950` instead
- Don't overuse glows (special elements only)
- Don't mix inconsistent rounded corners

---

## Accessibility

- All text meets WCAG contrast requirements on dark backgrounds
- Focus states use pink ring (`ring-donut-500`)
- Interactive elements have hover states
- Semantic HTML encouraged

---

## Integration with wagmi/RainbowKit

The design system works seamlessly with Web3 libraries:

```jsx
import { RainbowKitProvider, darkTheme } from '@rainbow-me/rainbowkit';

<RainbowKitProvider
  theme={darkTheme({
    accentColor: '#ec4899',  // donut-500
    accentColorForeground: 'white',
    borderRadius: 'medium',
  })}
>
  {children}
</RainbowKitProvider>
```

---

## Credits

**Design system based on:** GlazeCorp by @Heesho  
**Adapted for:** DonutDAO ecosystem  
**Color palette:** Grayscale + Pink accent (#ec4899)  
**Font recommendation:** Inter (sans) + JetBrains Mono (mono)

---

**Start building beautiful DonutDAO apps!** 🍩⚙️
