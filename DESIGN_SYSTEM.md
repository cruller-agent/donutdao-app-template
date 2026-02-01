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

---

## Typography (from GlazeCorp)

### Fonts

Heesho uses **Google Fonts**:

```typescript
import { Inter, JetBrains_Mono } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-inter',
});

const jetbrainsMono = JetBrains_Mono({
  subsets: ['latin'],
  variable: '--font-jetbrains-mono',
});
```

**Apply in layout:**
```jsx
<body className={`${inter.variable} ${jetbrainsMono.variable} font-sans`}>
```

**Usage:**
- **Inter** - Default sans-serif for all UI text
- **JetBrains Mono** - Monospace for code, addresses, numbers

---

## UI Components (from GlazeCorp)

### Icons: Lucide React

```bash
npm install lucide-react@0.309.0
```

```jsx
import { Wallet, Users, BarChart3, Search } from "lucide-react";

<Wallet size={20} className="text-donut-400" />
```

**Why Lucide:**
- Beautiful, consistent icon set
- Tree-shakeable (import only what you need)
- Perfect stroke width for modern UI
- Matches GlazeCorp aesthetic

### Button Component

```tsx
// components/ui/Button.tsx
"use client";

import React from "react";

type ButtonVariant = "primary" | "secondary" | "ghost" | "cyber";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  fullWidth?: boolean;
}

const baseStyles =
  "relative flex items-center justify-center font-medium uppercase tracking-wider transition-all duration-200 active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed outline-none focus:ring-2 focus:ring-donut-500/50 focus:ring-offset-2 focus:ring-offset-corp-950";

const variantStyles: Record<ButtonVariant, string> = {
  primary:
    "bg-donut-500 text-white hover:bg-donut-600 shadow-lg shadow-donut-500/25 hover:shadow-donut-500/40 border border-transparent rounded-lg",
  secondary:
    "bg-corp-800 border border-corp-700 text-corp-200 hover:border-donut-500/40 hover:text-corp-50 rounded-lg hover:shadow-[0_0_10px_rgba(236,72,153,0.1)]",
  ghost:
    "bg-transparent text-corp-400 hover:text-corp-50 hover:bg-corp-800 rounded-lg",
  cyber:
    "bg-corp-900 border border-donut-500/50 text-donut-400 hover:bg-donut-500 hover:text-white rounded-lg shadow-[0_0_10px_rgba(236,72,153,0.15)] hover:shadow-[0_0_20px_rgba(236,72,153,0.4)]",
};

export function Button({
  children,
  variant = "primary",
  fullWidth = false,
  className = "",
  disabled,
  ...props
}: ButtonProps) {
  const widthClass = fullWidth ? "w-full py-3.5 text-base" : "px-4 py-2 text-sm";

  return (
    <button
      className={`${baseStyles} ${variantStyles[variant]} ${widthClass} ${className}`}
      disabled={disabled}
      {...props}
    >
      {children}
    </button>
  );
}
```

**Usage:**
```jsx
<Button variant="primary">Connect Wallet</Button>
<Button variant="secondary">Cancel</Button>
<Button variant="ghost">Settings</Button>
<Button variant="cyber">Launch 🚀</Button>
```

### Card Component

```tsx
// components/ui/Card.tsx
"use client";

import React from "react";

interface CardProps {
  children: React.ReactNode;
  className?: string;
  title?: string;
  icon?: React.ReactNode;
  rightHeader?: React.ReactNode;
  noPadding?: boolean;
  size?: "sm" | "default" | "lg";
}

export function Card({
  children,
  className = "",
  title,
  icon,
  rightHeader,
  noPadding = false,
  size = "default",
}: CardProps) {
  const paddingClass = noPadding ? "" : size === "sm" ? "p-3" : size === "lg" ? "p-5" : "p-4";

  return (
    <div
      className={`
        relative flex flex-col overflow-hidden
        bg-[#131313] rounded-xl
        ${className}
      `}
    >
      {/* Header */}
      {(title || rightHeader) && (
        <div className="flex items-center justify-between px-4 py-2.5 border-b border-white/5">
          <div className="flex items-center gap-2">
            {icon && <span className="text-donut-400">{icon}</span>}
            {title && (
              <span className="text-sm font-medium text-corp-300">
                {title}
              </span>
            )}
          </div>
          {rightHeader && <div>{rightHeader}</div>}
        </div>
      )}

      {/* Content */}
      <div className={`flex-1 flex flex-col min-h-0 ${paddingClass}`}>
        {children}
      </div>
    </div>
  );
}
```

**Usage:**
```jsx
<Card title="Your Balance" icon={<Wallet size={16} />}>
  <p>1,234 DONUT</p>
</Card>

<Card 
  title="Stats" 
  rightHeader={<button>Refresh</button>}
  size="lg"
>
  <div>Content...</div>
</Card>
```

### Input Component

```tsx
// components/ui/Input.tsx
"use client";

import * as React from "react";
import { Search } from "lucide-react";

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  icon?: React.ReactNode;
}

export const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className = "", icon, ...props }, ref) => {
    return (
      <div className="relative">
        {icon && (
          <div className="absolute left-3 top-1/2 -translate-y-1/2 text-corp-500">
            {icon}
          </div>
        )}
        <input
          ref={ref}
          className={`w-full bg-[#232323] rounded-xl px-4 py-3 text-sm text-corp-50 placeholder:text-corp-500 focus:outline-none transition-colors ${
            icon ? "pl-10" : ""
          } ${className}`}
          {...props}
        />
      </div>
    );
  }
);

Input.displayName = "Input";

export function SearchInput(props: Omit<InputProps, "icon">) {
  return <Input icon={<Search size={18} />} {...props} />;
}
```

**Usage:**
```jsx
<Input placeholder="Enter amount..." />
<Input icon={<Wallet size={18} />} placeholder="Wallet address..." />
<SearchInput placeholder="Search tokens..." />
```

---

## Complete Example App

```tsx
// app/page.tsx
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { Input } from "@/components/ui/Input";
import { Wallet, TrendingUp, Users } from "lucide-react";

export default function HomePage() {
  return (
    <div className="min-h-screen bg-donutdao-glow">
      {/* Hero */}
      <section className="container mx-auto px-4 py-20">
        <h1 className="text-5xl font-bold text-gradient mb-6 text-center">
          DonutDAO
        </h1>
        <p className="text-corp-400 text-center text-lg mb-8 max-w-2xl mx-auto">
          Build fair, transparent apps with revenue routing to gDONUT holders
        </p>
        
        <div className="flex justify-center gap-4">
          <Button variant="primary">
            <Wallet size={18} />
            Connect Wallet
          </Button>
          <Button variant="secondary">Learn More</Button>
        </div>
      </section>

      {/* Features Grid */}
      <section className="container mx-auto px-4 py-12">
        <div className="grid md:grid-cols-3 gap-6">
          <Card 
            title="Total Value Locked" 
            icon={<TrendingUp size={16} />}
            size="lg"
          >
            <p className="text-3xl font-bold text-donut-400 mt-2">$1.2M</p>
            <p className="text-corp-500 text-sm mt-1">+12.5% this week</p>
          </Card>

          <Card 
            title="DONUT Holders" 
            icon={<Users size={16} />}
            size="lg"
          >
            <p className="text-3xl font-bold text-corp-50 mt-2">3,421</p>
            <p className="text-corp-500 text-sm mt-1">Across Base</p>
          </Card>

          <Card 
            title="Staked DONUT" 
            icon={<Wallet size={16} />}
            size="lg"
          >
            <p className="text-3xl font-bold text-corp-50 mt-2">456K</p>
            <p className="text-corp-500 text-sm mt-1">Earning rewards</p>
          </Card>
        </div>
      </section>

      {/* Interactive Section */}
      <section className="container mx-auto px-4 py-12">
        <Card title="Stake Your DONUT" size="lg" className="max-w-md mx-auto">
          <div className="space-y-4">
            <div>
              <label className="text-sm text-corp-400 mb-2 block">Amount</label>
              <Input placeholder="0.00" type="number" />
            </div>
            
            <div className="flex justify-between text-sm">
              <span className="text-corp-500">Available:</span>
              <span className="text-corp-50">1,234 DONUT</span>
            </div>

            <Button variant="cyber" fullWidth>
              Stake & Earn 🍩
            </Button>
          </div>
        </Card>
      </section>
    </div>
  );
}
```

---

## Summary: Heesho's Stack

**Typography:**
- Inter (sans-serif)
- JetBrains Mono (monospace)

**Icons:**
- lucide-react@0.309.0

**Components:**
- Custom Button (4 variants: primary, secondary, ghost, cyber)
- Custom Card (with optional header, icon, sizes)
- Custom Input (with optional icon)

**Design:**
- Dark grayscale (#131313, #232323)
- Pink accent (#ec4899)
- Rounded-xl borders (12px)
- Subtle shadows and glows
- Uppercase tracking on buttons
- Focus rings on all interactive elements

**The vibe:**
Clean, modern, slightly futuristic. "Evil megacorp aesthetic" with a donut twist. 🍩
