# Figma Design Analysis - Frame 57072:9958

## Overview
This Figma frame contains a comprehensive registration/email flow interface for a mobile application. The main frame (Frame 313432) contains multiple screens and workflow steps arranged horizontally.

## Frame Structure
- **Main Frame**: Frame 313432 (5294.0 x 2460.0)
- **Root Container**: Frame 313433 (5294.0 x 2460.0)
- **Content Container**: Frame 313431 (5294.0 x 2460.0)

## Design Components

### 1. Navigation Tags (Top Section)
Four horizontal navigation tags showing the user flow:

#### Tag 1: "Landing page"
- **Position**: (469, -93) 
- **Size**: 412 x 134
- **Background**: Light blue (#E6EEFE)
- **Text Color**: Purple (#483FA9)
- **Font**: Manrope SemiBold 48px
- **Padding**: 55px horizontal, 37px vertical
- **Corner Radius**: 100px (fully rounded)

#### Tag 2: "Register"
- **Position**: (1101, -93)
- **Size**: 301 x 134
- **Same styling as Tag 1**

#### Tag 3: "Verify E-Mail"
- **Position**: (2592, -93)
- **Size**: 387 x 134
- **Same styling as Tag 1**

#### Tag 4: "Set Password"
- **Position**: (4071, -93)
- **Size**: 415 x 134
- **Same styling as Tag 1**

### 2. Email Registration Screen (Main Content)
**Position**: (1101, 214) **Size**: 393 x 852

#### iPhone Status Bar
- **Background**: Purple (#483FA9)
- **Time**: "9:41" (SF Pro Text SemiBold 17px, White)
- **Signal/WiFi/Battery**: White icons
- **Height**: 47px

#### Header Section
- **Background**: Purple (#483FA9)
- **Height**: 44px
- **Layout**: Horizontal with 3 sections

**Left Action**:
- Close icon (24x24, White)
- "Zurück" text (Manrope SemiBold 16px, Dark)

**Center Title**:
- "Registrieren" (Manrope SemiBold 16px, White)

**Right Action**:
- Account icon (24x24)
- "Fertig" text (Manrope SemiBold 16px, Purple #4A2DE)

#### Main Content Area
**Background**: White
**Padding**: 16px top/bottom, 24px left/right
**Corner Radius**: 12px

**Step Indicator**:
- "1/2 Schritte" (Manrope SemiBold 16px, Dark)

**Question**:
- "Wie ist deine E-Mail Adresse?" (Manrope SemiBold 20px, Dark)

**Text Input Field**:
- **Size**: 329 x 56
- **Background**: White
- **Border**: Subtle light border
- **Corner Radius**: 12px
- **Padding**: 16px vertical, 8px horizontal
- **Label**: "E-Mail" (Manrope SemiBold 16px, Dark)
- **Placeholder**: "Content" (Manrope SemiBold 16px, Dark)
- **Icon**: Email icon (24x24, right-aligned)

**Checkbox Section**:
Two checkbox options:

1. **Terms & Conditions**:
   - Unchecked state (Light purple #F4F2FF background)
   - Text: "*Ich habe die Nutzungsbedingungen & Datenschutzrichtlinien gelesen und akzeptiere diese"
   - Font: Manrope Regular 14px, Dark

2. **Stay Logged In**:
   - Checked state (Purple #483FA9 background)
   - White checkmark icon
   - Text: "Angemeldet bleiben"
   - Font: Manrope Regular 14px, Dark

**Continue Button**:
- **Size**: 361 x 56
- **Background**: Disabled gray (#D4D2D1)
- **Corner Radius**: 12px
- **Text**: "Weiter" (Manrope SemiBold 16px, Dark gray)
- **Icon**: Right arrow (disabled state)
- **Padding**: 24px horizontal, 16px vertical

#### Bottom Section
**Home Indicator**:
- **Background**: Light beige (#FEF9F5)
- **Height**: 34px
- **Indicator**: White rounded rectangle (134x5, 100px radius)

### 3. Email Screen with Keyboard (Second State)
**Position**: (1534, 214) **Size**: 393 x 852

Same structure as the first email screen but with:
- **Keyboard**: iOS alphabetic keyboard at bottom
- **Keyboard Background**: Light gray (#D1D3D9)
- **Key Size**: Varies (32-34px width, 42px height)
- **Key Font**: SF Pro Display Light 26px
- **Key Background**: White with 4.6px corner radius

## Color Palette
- **Primary Purple**: #483FA9 (rgba(72, 63, 169, 1.0))
- **Light Purple**: #E6EEFE (rgba(230, 238, 254, 1.0))
- **Background White**: #FFFFFF
- **Text Dark**: #040506 (rgba(4, 5, 6, 1.0))
- **Disabled Gray**: #D4D2D1 (rgba(212, 210, 209, 1.0))
- **Light Gray**: #F4F2FF (rgba(244, 242, 255, 1.0))
- **Keyboard Gray**: #D1D3D9 (rgba(209, 211, 217, 1.0))

## Typography
- **Primary Font**: Manrope
- **Secondary Font**: SF Pro Text/Display
- **Font Weights**: 
  - Regular (400)
  - Medium (500)
  - SemiBold (600)
- **Font Sizes**:
  - Navigation Tags: 48px
  - Headers: 32px
  - Subheaders: 20px
  - Body: 16px
  - Small text: 14px
  - Status bar: 17px
  - Keyboard: 26px

## Layout Specifications
- **Screen Width**: 393px (iPhone standard)
- **Content Padding**: 24px horizontal, 16px vertical
- **Element Spacing**: 16px standard
- **Corner Radius**: 12px for cards/inputs, 100px for fully rounded elements
- **Status Bar Height**: 47px
- **Header Height**: 44px
- **Input Field Height**: 56px
- **Button Height**: 56px
- **Checkbox Size**: 24x24px
- **Icon Size**: 24x24px

## Interaction States
- **Button Disabled**: Gray background, gray text
- **Checkbox Unchecked**: Light purple background
- **Checkbox Checked**: Purple background with white checkmark
- **Input Field**: White background with subtle border
- **Navigation Tags**: Light blue background with purple text

## Screen Flow
1. Landing page → Register → Verify E-Mail → Set Password
2. Email registration form with two states:
   - Initial state (no keyboard)
   - Active input state (with keyboard)

This design follows iOS Human Interface Guidelines with custom branding and color scheme.