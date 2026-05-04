// lib/widgets/banner_carousel.dart
// ─────────────────────────────────────────────────────────────────────────────
// Promotional banner carousel using carousel_slider package.
// Features:
//   • Auto-play with configurable interval
//   • Smooth page indicator dots
//   • Gradient overlay for text legibility
//   • Hero-style large emoji illustration
// ─────────────────────────────────────────────────────────────────────────────

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/banner_model.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  // Track which slide is active for the page indicator
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Carousel slider ────────────────────────────────────────────────
        CarouselSlider.builder(
          itemCount: widget.banners.length,
          options: CarouselOptions(
            height: 180,
            viewportFraction: 0.92,  // Slight peek of adjacent slides
            enlargeCenterPage: true,
            enlargeFactor: 0.05,
            autoPlay: true,
            autoPlayInterval: AppConstants.bannerAutoPlayInterval,
            autoPlayAnimationDuration: AppConstants.bannerScrollDuration,
            autoPlayCurve: Curves.easeInOutCubic,
            onPageChanged: (index, _) {
              setState(() => _currentIndex = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return _BannerCard(banner: widget.banners[index]);
          },
        ),

        const SizedBox(height: AppConstants.spaceS),

        // ── Page indicator dots ────────────────────────────────────────────
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.banners.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3,
            spacing: 4,
            activeDotColor: Color(0xFF2ECC71),
            dotColor: Color(0xFFCCCCCC),
          ),
        ),
      ],
    );
  }
}

// ── Individual banner card ────────────────────────────────────────────────────
class _BannerCard extends StatelessWidget {
  final BannerModel banner;

  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: banner.backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        // Subtle inner shadow
        boxShadow: [
          BoxShadow(
            color: banner.backgroundColor.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Background decorative circle ───────────────────────────────
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // ── Main content row ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppConstants.spaceL),
            child: Row(
              children: [
                // Text column
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tag pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spaceS,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                        ),
                        child: Text(
                          banner.tag,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spaceXS),

                      // Title
                      Text(
                        banner.title,
                        style: AppTextStyles.headingMedium.copyWith(
                          color: banner.textColor,
                          fontSize: 17,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spaceXXS),

                      // Subtitle
                      Text(
                        banner.subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: banner.textColor.withOpacity(0.75),
                          fontSize: 11,
                        ),
                      ),

                      if (banner.actionLabel != null) ...[
                        const SizedBox(height: AppConstants.spaceS),
                        // CTA button
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spaceM,
                            vertical: AppConstants.spaceXXS + 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                          ),
                          child: Text(
                            banner.actionLabel!,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: banner.backgroundColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Emoji illustration
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      banner.emoji,
                      style: const TextStyle(fontSize: 72),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
