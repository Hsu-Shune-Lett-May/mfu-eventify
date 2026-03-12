import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/navigation/app_routes.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _pulseController;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _chipsFade;
  late final Animation<double> _btnFade;
  late final Animation<Offset> _btnSlide;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Staggered entry
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.35, curve: Curves.elasticOut),
      ),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    ));
    _chipsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.45, 0.7, curve: Curves.easeOut),
      ),
    );
    _btnFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.65, 0.9, curve: Curves.easeOut),
      ),
    );
    _btnSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.65, 0.9, curve: Curves.easeOut),
    ));

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToWelcome() {
    Navigator.pushReplacementNamed(context, AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;
    final isCompact = w < 600;
    final isMedium = w >= 600 && w < 960;
    final padding = isCompact ? 28.0 : (isMedium ? 48.0 : 72.0);
    final maxW = isCompact ? w : (isMedium ? 640.0 : 860.0);
    final logoSize = isCompact ? (h < 640 ? 64.0 : 76.0) : (isMedium ? 88.0 : 96.0);
    final titleSize = isCompact ? (h < 640 ? 28.0 : 34.0) : (isMedium ? 40.0 : 46.0);

    return Scaffold(
      body: Stack(
        children: [
          // ═══ Background gradient ═══
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFFBFB),
                  Color(0xFFFFF0F0),
                  Color(0xFFFDE8E8),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // ═══ Decorative blurred circles ═══
          Positioned(
            top: -h * 0.12,
            right: -w * 0.15,
            child: _GlowOrb(
              size: isCompact ? 220 : 320,
              color: AppColors.primary.withOpacity(0.06),
            ),
          ),
          Positioned(
            bottom: -h * 0.08,
            left: -w * 0.12,
            child: _GlowOrb(
              size: isCompact ? 200 : 280,
              color: const Color(0xFF2563EB).withOpacity(0.05),
            ),
          ),
          Positioned(
            top: h * 0.4,
            left: -40,
            child: _GlowOrb(
              size: isCompact ? 120 : 160,
              color: const Color(0xFFD97706).withOpacity(0.05),
            ),
          ),

          // ═══ Dot grid pattern (top-right) ═══
          if (!isCompact)
            Positioned(
              top: 40,
              right: 40,
              child: Opacity(
                opacity: 0.25,
                child: _DotGrid(rows: 4, cols: 5, spacing: 18, dotSize: 3),
              ),
            ),

          // ═══ Main content ═══
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    children: [
                      const Spacer(flex: 3),

                      // ── Animated Logo ──
                      ScaleTransition(
                        scale: _logoScale,
                        child: AnimatedBuilder(
                          animation: _pulse,
                          builder: (_, child) => Transform.scale(
                            scale: _pulse.value,
                            child: child,
                          ),
                          child: Container(
                            width: logoSize,
                            height: logoSize,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF9B0000),
                                  Color(0xFF5C0000),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(logoSize * 0.28),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.35),
                                  blurRadius: 32,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 12),
                                ),
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.15),
                                  blurRadius: 60,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  LucideIcons.calendar,
                                  size: logoSize * 0.46,
                                  color: Colors.white.withOpacity(0.95),
                                ),
                                // Small bell badge
                                Positioned(
                                  top: logoSize * 0.1,
                                  right: logoSize * 0.1,
                                  child: Container(
                                    width: logoSize * 0.22,
                                    height: logoSize * 0.22,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF4444),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      LucideIcons.bell,
                                      size: logoSize * 0.11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: isCompact ? 22 : 28),

                      // ── Title + tagline ──
                      FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFF9B0000),
                                    Color(0xFF5C0000),
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'MFU Eventify',
                                  style: TextStyle(
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.8,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              SizedBox(height: isCompact ? 10 : 14),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 380),
                                child: Text(
                                  'Discover, create, and never miss\ncampus events again.',
                                  style: TextStyle(
                                    fontSize: isCompact ? 15 : 18,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // ── Feature cards ──
                      FadeTransition(
                        opacity: _chipsFade,
                        child: _FeatureStrip(isCompact: isCompact),
                      ),

                      const Spacer(flex: 2),

                      // ── CTA button ──
                      FadeTransition(
                        opacity: _btnFade,
                        child: SlideTransition(
                          position: _btnSlide,
                          child: Column(
                            children: [
                              SizedBox(
                                width: isCompact ? double.infinity : 300,
                                height: 56,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF9B0000),
                                        Color(0xFF6B0000),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _navigateToWelcome,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.rocket_launch_rounded, size: 20),
                                        SizedBox(width: 10),
                                        Text(
                                          'Run the App',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'For MFU Community',
                                    style: TextStyle(
                                      fontSize: isCompact ? 12 : 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textTertiary,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// Decorative glow orb
// ────────────────────────────────────────────────────────────────────

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0)],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// Dot grid decoration
// ────────────────────────────────────────────────────────────────────

class _DotGrid extends StatelessWidget {
  final int rows, cols;
  final double spacing, dotSize;
  const _DotGrid({
    required this.rows,
    required this.cols,
    required this.spacing,
    required this.dotSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        rows,
        (r) => Padding(
          padding: EdgeInsets.only(bottom: r < rows - 1 ? spacing : 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              cols,
              (c) => Padding(
                padding: EdgeInsets.only(right: c < cols - 1 ? spacing : 0),
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
// Feature strip — three mini-cards
// ────────────────────────────────────────────────────────────────────

class _FeatureStrip extends StatelessWidget {
  final bool isCompact;
  const _FeatureStrip({required this.isCompact});

  static const _items = [
    _FItem(LucideIcons.calendarSearch, 'Browse Events',
        Color(0xFFDCFCE7), Color(0xFF16A34A)),
    _FItem(LucideIcons.sparkles, 'Create Events',
        Color(0xFFDBEAFE), Color(0xFF2563EB)),
    _FItem(LucideIcons.bellRing, 'Reminders',
        Color(0xFFFEF3C7), Color(0xFFD97706)),
  ];

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        children: _items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _FeatureMiniCard(data: item, full: true),
                ))
            .toList(),
      );
    }

    return IntrinsicHeight(
      child: Row(
        children: _items.asMap().entries.map((e) {
          final isLast = e.key == _items.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 12),
              child: _FeatureMiniCard(data: e.value, full: false),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FItem {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  const _FItem(this.icon, this.label, this.bg, this.fg);
}

class _FeatureMiniCard extends StatelessWidget {
  final _FItem data;
  final bool full;
  const _FeatureMiniCard({required this.data, required this.full});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: full ? 18 : 14,
        vertical: full ? 14 : 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: full
          ? Row(
              children: [
                _iconBadge(),
                const SizedBox(width: 14),
                Text(data.label, style: _labelStyle()),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _iconBadge(),
                const SizedBox(height: 12),
                Text(data.label, style: _labelStyle(), textAlign: TextAlign.center),
              ],
            ),
    );
  }

  Widget _iconBadge() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: data.bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: data.fg.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(data.icon, size: 20, color: data.fg),
    );
  }

  TextStyle _labelStyle() => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );
}
