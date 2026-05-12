---
name: Electus Design System
colors:
  surface: '#10141a'
  surface-dim: '#10141a'
  surface-bright: '#353940'
  surface-container-lowest: '#0a0e14'
  surface-container-low: '#181c22'
  surface-container: '#1c2026'
  surface-container-high: '#262a31'
  surface-container-highest: '#31353c'
  on-surface: '#dfe2eb'
  on-surface-variant: '#b9cacb'
  inverse-surface: '#dfe2eb'
  inverse-on-surface: '#2d3137'
  outline: '#849495'
  outline-variant: '#3a494b'
  surface-tint: '#00dbe7'
  primary: '#e1fdff'
  on-primary: '#00363a'
  primary-container: '#00f2ff'
  on-primary-container: '#006a71'
  inverse-primary: '#00696f'
  secondary: '#ffffff'
  on-secondary: '#1f3700'
  secondary-container: '#a0fb00'
  on-secondary-container: '#457000'
  tertiary: '#fef5ff'
  on-tertiary: '#480081'
  tertiary-container: '#ead2ff'
  on-tertiary-container: '#8624de'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#74f5ff'
  primary-fixed-dim: '#00dbe7'
  on-primary-fixed: '#002022'
  on-primary-fixed-variant: '#004f54'
  secondary-fixed: '#a0fb00'
  secondary-fixed-dim: '#8cdc00'
  on-secondary-fixed: '#102000'
  on-secondary-fixed-variant: '#304f00'
  tertiary-fixed: '#efdbff'
  tertiary-fixed-dim: '#dcb8ff'
  on-tertiary-fixed: '#2c0051'
  on-tertiary-fixed-variant: '#6700b5'
  background: '#10141a'
  on-background: '#dfe2eb'
  surface-variant: '#31353c'
typography:
  display:
    fontFamily: Geist
    fontSize: 64px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.04em
  h1:
    fontFamily: Geist
    fontSize: 40px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  h2:
    fontFamily: Geist
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Geist
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Geist
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1'
    letterSpacing: 0.1em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 16px
  md: 24px
  lg: 48px
  xl: 80px
  gutter: 24px
  hit-box-mobile: 48px
---

## Brand & Style

This design system is built on the intersection of **Futuristic High-Tech** and **Executive Professionalism**. It visualizes the speed and precision of artificial intelligence within the recruitment space. The aesthetic leans heavily into a "Command Center" feel—clean, data-dense, yet ethereal.

The primary style combines **Glassmorphism** and **Minimalism**. By using translucent layers and vibrant light-trail accents against a void-black background, the UI suggests depth and intelligence. The emotional response should be one of "effortless power"—a tool that feels advanced enough to predict talent needs while remaining simple enough to navigate without friction.

## Colors

The palette is anchored in absolute blacks and deep charcoals to maximize the luminosity of the neon accents. 

- **Core Neutrals:** Use `#000000` for primary backgrounds to create a "bottomless" feel. Use `#0d1117` for elevated surfaces and containers.
- **Neon Accents:** Electric Blue (`#00f2ff`) is the primary action color. Lime Green is reserved for success states and growth metrics, while Soft Purple is used for AI-specific features and deep gradients.
- **Light Trails:** Gradients should mimic the motion of light, moving from Purple to Cyan to Lime. These are used sparingly for dividers, progress bars, and high-impact hover states.

## Typography

This design system utilizes **Geist** for its technical precision and readability in dark environments. 

Headings must maintain high contrast against the background; use pure white (`#ffffff`) and tight letter-spacing to evoke a modern, editorial feel. For data points and technical metadata (like candidate IDs or timestamps), **JetBrains Mono** or a similar monospaced font is used to reinforce the high-tech, developer-adjacent nature of the platform. Secondary text should use a lowered opacity or the grey-blue neutral to maintain a clear hierarchy.

## Layout & Spacing

The layout follows a **Fluid 12-column grid** with generous margins to prevent the UI from feeling cluttered. 

A strict 8px rhythmic scale is used for all internal component spacing. For mobile views, hit-boxes must never drop below 48px in height to ensure accessibility and ease of use in fast-paced recruitment environments. Spacing between major sections should be expansive (48px+) to allow the "light trail" accents room to breathe and guide the eye.

## Elevation & Depth

Depth is achieved through **Glassmorphism** rather than traditional drop shadows. 

1.  **Backdrop Blur:** Surfaces use a `blur(12px)` or `blur(20px)` effect with a semi-transparent background (`rgba(13, 17, 23, 0.7)`).
2.  **Subtle Borders:** All elevated containers must have a 1px solid border using a low-opacity white or a faint gradient that mimics a light source hitting the edge of a glass pane.
3.  **Luminous Glow:** Instead of black shadows, "AI-active" elements may use a soft, colored outer glow (box-shadow) in Cyan or Purple with a very high spread and low opacity (e.g., `0px 0px 30px rgba(0, 242, 255, 0.15)`).

## Shapes

The design system maintains a consistent **0.75rem (12px)** corner radius for almost all UI elements, including cards, input fields, and buttons. This "Rounded" approach balances the sharp, technical aesthetic with a sense of approachability. 

Small badges and status indicators may use a **Pill-shape** to differentiate them from interactive buttons. Avoid sharp corners entirely to maintain the fluid, "organic intelligence" feel of the brand.

## Components

### Buttons
- **Primary:** Solid Cyan (`#00f2ff`) background with black text. On hover, add a 10px outer glow.
- **Secondary:** Transparent background with a 1px Cyan border.
- **Ghost:** Text only, shifting to 10% Cyan background on hover.

### Input Fields
- Backgrounds should be deep charcoal (`#0d1117`) with a 1px subtle border. 
- Upon focus, the border transitions to a Cyan-to-Purple gradient, and the label floats with a slight glow.

### Cards
- Utilize the Glassmorphism specification. 
- Header areas of cards should have a subtle 5% white overlay to separate them from the card body.

### Chips & Badges
- Used for candidate "Skills" or "Status." 
- These should be low-contrast (grey background) until hovered, at which point they illuminate in the primary accent color.

### AI Indicators
- Any AI-generated content (summaries, scores) should be encased in a card with a "light trail" border—a thin, moving gradient that circulates the perimeter of the component.