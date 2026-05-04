// lib/utils/app_constants.dart
// ─────────────────────────────────────────────────────────────────────────────
// Global constants: spacing, border radii, animation durations, etc.
// Keeping magic numbers in one place prevents inconsistency.
// ─────────────────────────────────────────────────────────────────────────────

class AppConstants {
  AppConstants._();

  // ── Spacing scale (4pt grid) ──────────────────────────────────────────────
  static const double spaceXXS = 4.0;
  static const double spaceXS  = 8.0;
  static const double spaceS   = 12.0;
  static const double spaceM   = 16.0;
  static const double spaceL   = 20.0;
  static const double spaceXL  = 24.0;
  static const double spaceXXL = 32.0;
  static const double spaceXXXL = 48.0;

  // ── Border radii ──────────────────────────────────────────────────────────
  static const double radiusS  = 8.0;
  static const double radiusM  = 12.0;
  static const double radiusL  = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 100.0; // Pill / circle

  // ── Elevation / shadow depth ──────────────────────────────────────────────
  static const double elevationCard = 2.0;
  static const double elevationModal = 8.0;

  // ── Animation durations ───────────────────────────────────────────────────
  static const Duration animFast   = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow   = Duration(milliseconds: 500);

  // ── Banner carousel settings ──────────────────────────────────────────────
  static const Duration bannerAutoPlayInterval = Duration(seconds: 3);
  static const Duration bannerScrollDuration   = Duration(milliseconds: 600);

  // ── Layout breakpoints ────────────────────────────────────────────────────
  static const double tabletBreakpoint = 600.0; // Switch to 3-col grid on tablets

  // ── Product grid ──────────────────────────────────────────────────────────
  static const int gridColumnsMobile = 2;
  static const int gridColumnsTablet = 3;
  static const double gridAspectRatio = 0.72; // height / width
  static const double gridSpacing = 12.0;

  // ── Category row ──────────────────────────────────────────────────────────
  static const double categoryItemWidth  = 80.0;
  static const double categoryIconSize   = 32.0;
  static const double categoryCircleSize = 64.0;

  // ── App bar ───────────────────────────────────────────────────────────────
  static const double appBarHeight = 60.0;
}
