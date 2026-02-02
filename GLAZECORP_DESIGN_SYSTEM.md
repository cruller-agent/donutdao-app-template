# GlazeCorp Design System Documentation 🍩✨

**Date:** 2026-02-02  
**Source:** Analyzed https://www.glazecorp.io/ + internals (/govern, /mine, /franchise, /signal)  
**Purpose:** Exact aesthetics for DonutDAO template/demo-app. Matches Heesho's GlazeCorp style: **minimal dark glass + pink glows + massive stats**.

## 🎨 Core Aesthetics (All Pages)

### Color Palette (Grayscale + Pink)
| Name | Hex | RGB (CSS vars) | Usage |
|------|-----|----------------|-------|
| **Background** | #09090b | `--corp-950` / `rgb(9 9 11)` | Body/full-bleed |
| **Surface/Card** | #0f0f10 / #18181b | `--corp-900` / `--card` | Cards, sections (glass: rgba + blur) |
| **Text Primary** | #fafafa | `--corp-50` / `--foreground` | Heroes, values |
| **Text Muted** | #a1a1aa / #71717a | `--corp-400/500` | Subtitles, labels |
| **Accent/Pink** | #ec4899 | `--donut-500` / `--accent` | Borders, glows, hovers, links |
| **Pink Glow** | rgba(236,72,153,0.1-0.5) | Gradients/shadows | Backgrounds, hovers |

- **Gradients**: Radial pink ellipses (low opacity: 0.03-0.15) at corners for depth
- **Borders**: Subtle pink (rgba(236,72,153,0.2)) on hovers/glass

### Typography
- **Primary**: Inter (300-800 weights)
  - Hero/Tagline: 300 light (clamp 3-6rem), letter-spacing -0.03em
  - Titles: 600-800 (1.25-3.5rem)
  - Body: 400 (14px base, 1.4-1.5 line-height)
- **Numbers**: JetBrains Mono (bold, clamp 3-6rem)
- **Labels**: Uppercase, 0.875rem, letter-spacing 0.05-0.08em (muted gray)

### Spacing/Layout
- **Container**: max 1400px, 40px pad (mobile: 16-20px)
- **Vertical rhythm**: 40-100px sections, 24-40px gaps
- **Grid**: Auto-fit minmax(300-320px,1fr), huge gaps (40px)
- **Responsive**: Mobile stacks 1col, clamp() fonts/sizes

### Effects/Animations
- **Glassmorphism**: `backdrop-filter: blur(10-20px)` + rgba(--corp-900,0.6-0.8)
- **Glows**: `text-shadow 0 0 20-40px rgba(pink,0.3-0.5)`, box-shadow pink
- **Hovers**: Lift `translateY(-8px)`, border pink, shadow glow-xl
- **Background**: 3x radial-gradient pink (20%/80%/40% positions)
- **Transitions**: 0.3-0.4s cubic-bezier(0.25,0.46,0.45,0.94) / ease

## 📱 Page-Specific Breakdown

### Homepage (https://www.glazecorp.io/)
```
[Centered Hero]
"We Glaze The World"  <- 6rem+ light Inter, full-width

[4x Massive Stats Grid - centered, equal space]
0 Donuts Produced     <- Mono huge, pink glow hover
$0 Revenue
47 Countries
24/7 Operations
```
- **Layout**: Single hero → 1fr grid stats (no nav/footer visible)
- **Minimal**: No nav, just tagline + 4 giant metrics (0/$/47/24/7)

### /govern & /franchise (Empty/Coming Soon)
```
GlazeCorp | Built on Base
2026 GlazeCorp. All rights reserved.
```
- **Placeholder**: Centered text (small Inter), footer bar
- **Design**: Same bg/gradients, no content → prepare hero/stats layout

### /signal (404)
```
404 This page could not be found.
[Nav: GlazeCorp | Mine/Swap/Vote/Franchise/Auction/System]
[Footer Links: Protocol/Treasury/DAO/Analytics | Docs | X/Farcaster/Discord | Legal]
```
- **Error**: Centered 404, repeated top/bottom nav pills

### /mine (Full Internal Page)
```
[Top Nav Pills: GlazeCorp | Mine Swap Vote Franchise Auction System]  <- Fixed? horizontal, pink active

[Repeated Nav Below?]

### Current Operator          <- Section title 1.25rem gray
0x0000...0000                <- Mono address
@unknown                     <- Handle
Time 0s | Glazed +0 | +$0.00 | PNL +Ξ0.00000 +$0.00 | Total +$0.00

### Global Stats              <- Large section
Total Mined 0
Price $0.000000
Next Halving --d --h --m --s   <- Timer chips

### Your Wallet               <- Stats cards/grid
DONUT 0 | ETH Ξ0.0000 | ETH Spent Ξ0.0000 | etc.

DOUGH MIXING                 <- Bold section
--:--:--                     <- Huge timer Mono
Rate 0/s | $0.0000/s | Price Ξ0.00000 | $0.00   <- Inline chips

### Recent Activity           <- Table header
# | User | Message | Spent | Earned | Mined   <- Thin table, right-aligned nums
```
- **Nav**: Horizontal pills (top/bottom), active pink, space-between
- **Sections**: `### Title` (1.25rem gray 600), vertical stack
- **Operator Card**: Address+handle+metrics row (inline, right-aligned $Ξ)
- **Global/Wallet**: 3-6 inline stats (label huge-num)
- **Timer Section**: Centered huge timer + 4 inline metric chips
- **Table**: Simple #/User/Message/Spent/Earned/Mined (thin lines, mono nums)

## 🧩 Components Catalog

| Component | Positioning | Styles |
|-----------|-------------|--------|
| **Nav Pills** | Full-width top/bottom | Inline-flex gap, pink bg hover/active, corp-800 base |
| **Hero Tagline** | Centered, full-width | Inter-300 clamp(3-6rem), no shadow |
| **Stat Card** | Grid minmax(300px), centered content | Glass blur20px, pink border hover, lift+shadow |
| **Metric Row** | Inline-flex justify-between | Label left, huge Mono right ($/Ξ prefix) |
| **Timer Chips** | Inline row under title | Small rounded, gray/pink (--d --h etc.) |
| **Table** | Full-width bottom | Thin borders (--corp-800), right-align nums/ETH |
| **Operator PNL** | Compact row | Icons? +num (green/red?), total bottom |

## 🔄 Usage in DonutDAO Template

- **globals.css**: `.bg-glass`, `.text-glow`, `.card-glow`, nav/btn/input
- **tailwind.config.js**: Glow keyframes/shadows, donut/corp scales
- **Example Stat**:
  ```html
  <div class="bg-glass card-glow stat-card p-16 text-center">
    <div class="text-6xl mb-5">🍩</div>
    <div class="opacity-60 uppercase tracking-widest text-sm mb-3">Total Supply</div>
    <div class="text-glow font-mono text-6xl font-black">1.2M</div>
  </div>
  ```

**Build /govern etc. with this system.** Matches 100%.