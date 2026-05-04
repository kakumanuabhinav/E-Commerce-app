# ShopEasy — Flutter E-Commerce App
### Internship Assignment Documentation
---

## 1. Overview

**ShopEasy** is a production-quality, mobile-first e-commerce application built with Flutter. It simulates a grocery/fresh-produce shopping experience with a clean, modern UI following Material Design 3 principles.

The app was designed to demonstrate real-world Flutter development skills: clean architecture, reactive state management with Provider, smooth animations, responsive layouts, and modular, beginner-friendly code.

### Key Screens
| Screen | Description |
|---|---|
| **Home Screen** | Promotional banners, category filters, and product grid |
| **Product Detail** | Full product info, Hero image transition, add-to-cart bar |
| **Cart Screen** | Line items with quantity steppers, order summary, checkout |

---

## 2. Folder Structure

```
lib/
├── main.dart                    # Entry point, MultiProvider root
│
├── models/
│   ├── product_model.dart       # Product data + computed fields (discount %)
│   ├── cart_item_model.dart     # Cart line-item wrapping a Product + quantity
│   ├── category_model.dart      # Category chip data (icon, color, name)
│   └── banner_model.dart        # Promotional banner data
│
├── providers/
│   ├── cart_provider.dart       # Cart CRUD, quantity management, totals
│   ├── products_provider.dart   # Product list, category filter, loading state
│   └── wishlist_provider.dart   # Favourite toggle state (BONUS)
│
├── screens/
│   ├── home_screen.dart         # Main home page (AppBar + Sliver layout)
│   ├── product_detail_screen.dart # Detail page with Hero transition
│   └── cart_screen.dart         # Shopping cart and order summary
│
├── widgets/
│   ├── banner_carousel.dart     # carousel_slider with page indicator dots
│   ├── category_row.dart        # Horizontal ListView of category chips
│   ├── product_card.dart        # Grid card: image, wishlist, stepper, price
│   ├── shimmer_product_grid.dart # Skeleton loading placeholders (BONUS)
│   ├── section_header.dart      # Reusable "Title + See all" header
│   └── cart_badge_icon.dart     # App bar cart icon with animated badge
│
├── services/
│   └── mock_data_service.dart   # Static mock data (products, categories, banners)
│
└── utils/
    ├── app_colors.dart          # Complete color palette with semantic names
    ├── app_text_styles.dart     # Typography scale (DM Sans via Google Fonts)
    ├── app_constants.dart       # Spacing, radii, breakpoints, durations
    └── app_theme.dart           # Material 3 ThemeData configuration
```

---

## 3. Packages Used

| Package | Version | Purpose |
|---|---|---|
| `provider` | ^6.1.2 | Reactive state management — cart, products, wishlist |
| `carousel_slider` | ^4.2.1 | Auto-playing banner carousel with configurable options |
| `google_fonts` | ^6.2.1 | DM Sans typeface for premium, readable typography |
| `shimmer` | ^3.0.0 | Skeleton loading animation while products fetch |
| `smooth_page_indicator` | ^1.1.0 | Animated expanding dots below the carousel |

---

## 4. Design Decisions

### Architecture
**Clean Architecture with Provider** was chosen because it strikes the right balance for a beginner-friendly yet production-realistic codebase. The separation into `models → services → providers → screens → widgets` mirrors how real teams structure medium-scale Flutter apps.

### State Management
Provider's `ChangeNotifier` is used over `setState` to avoid prop-drilling. `Consumer<T>` and `context.watch<T>()` are used where rebuild scope matters most (e.g., cart badge), while `context.read<T>()` is used in callbacks to avoid unnecessary rebuilds.

### Layout Strategy
A **CustomScrollView with Slivers** was chosen for the home screen rather than a simple `SingleChildScrollView + Column`. This allows the SliverAppBar to float/snap, the product grid to integrate natively as a `SliverGrid`, and the whole page to scroll as one fluid unit — exactly how production apps like BigBasket or Blinkit are built.

### Responsive Design
A `tabletBreakpoint` constant (`600px`) switches the product grid from 2 to 3 columns on tablets, tested via `MediaQuery.of(context).size.width`. The same approach applies to shimmer skeleton count.

### Typography
**DM Sans** (via Google Fonts) was chosen for its humanist geometric style — clean and modern without being sterile. A full typographic scale from `displayLarge` down to `bodySmall` ensures consistent hierarchy throughout the app.

### Color Palette
The primary palette is built around a **fresh green (#2ECC71)** to evoke freshness and trust for a grocery app. A **warm coral (#FF6B35)** provides the accent for call-to-action elements like discount badges. The off-white background (`#F8FAF9`) avoids pure-white harshness while keeping the UI bright.

---

## 5. Features Implemented

### Core Requirements ✅
- [x] AppBar with "ShopEasy" branding and cart icon
- [x] Auto-playing banner carousel (5 banners, 3-second interval)
- [x] Category horizontal scroll (7 categories with icons)
- [x] Product GridView (2 columns mobile, 3 tablet)
- [x] Product cards: image, name, price, Add to Cart button
- [x] Provider-based cart state (add, remove, increase, decrease)
- [x] Product Detail Page with full info
- [x] Responsive design (mobile + tablet)
- [x] Mock data service (12 products across 4 categories)

### Bonus Features ✅
- [x] **Wishlist** — heart toggle on each card with Provider state
- [x] **Hero animation** — product image seamlessly transitions to detail page
- [x] **Button animation** — spring scale animation on Add to Cart press
- [x] **Heart animation** — elastic scale animation on wishlist toggle
- [x] **Shimmer loading** — skeleton placeholders during 1.2s simulated load
- [x] **Smooth page indicator** — expanding dots for carousel navigation

---

## 6. Challenges Faced

### 1. Sliver + Non-Sliver Mixing
Placing the banner carousel and category row inside a `CustomScrollView` required wrapping them in `SliverToBoxAdapter`. Getting the grid to integrate as a native `SliverGrid` (rather than `shrinkWrap: true` — which is a performance anti-pattern) required restructuring the layout.

**Solution:** Used `SliverList` with a `SliverChildListDelegate` for the static sections, and a `SliverGrid` for the dynamic product grid. This gives smooth, performant scrolling across the entire page.

### 2. Hero Animation With Network Images
Hero animations work by matching tags between source and destination widgets. With network images, there's a brief flash when the image hasn't loaded on the detail screen yet.

**Solution:** The `Hero` widget wraps the `Image.network` with a loading builder that shows a shimmer-style colour placeholder until the image resolves.

### 3. Quantity Stepper State in Grid Cards
The quantity stepper inside each product card needs to reactively update without rebuilding the entire grid.

**Solution:** Used `context.watch<CartProvider>()` selectively inside `_PriceAndCartRow` with `context.select` on `CartBadgeIcon` for fine-grained rebuild control.

### 4. Preventing Duplicate Loads
If the user navigates away and back, `loadProducts()` should not fire again unnecessarily.

**Solution:** Added an `_isLoading` guard at the top of `loadProducts()` that returns early if a load is already in progress.

---

## 7. Future Improvements

| Improvement | Description |
|---|---|
| **Real API** | Replace `MockDataService` with `http`/`dio` HTTP calls to a backend |
| **Persistent Cart** | Use `shared_preferences` or `hive` to persist cart across app restarts |
| **Authentication** | Login/signup flow with Firebase Auth |
| **Search Delegate** | Full-screen search with real-time filtering using `SearchDelegate` |
| **Order History** | Track past orders in a Firestore collection |
| **Push Notifications** | `firebase_messaging` for deal alerts |
| **Dark Mode** | Add a `darkTheme` and a `ThemeProvider` toggle |
| **Image Caching** | `cached_network_image` for faster image loading and offline support |
| **Animations** | `flutter_animate` library for more polished micro-interactions |
| **Accessibility** | Add `Semantics` labels for screen reader support |

---

## 8. How to Run

```bash
# 1. Clone or unzip the project
cd shopeasy

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or emulator
flutter run

# 4. Run on specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome   # Web (experimental)
```

**Requirements:** Flutter ≥ 3.0.0, Dart ≥ 3.0.0

---

*Built with ❤️ as an internship assignment project demonstrating production Flutter development practices.*
