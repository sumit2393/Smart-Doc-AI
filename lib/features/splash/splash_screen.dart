import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_doc_ai/features/home/home_screen.dart';
import 'package:smart_doc_ai/features/home/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _scanController;
  late AnimationController _textController;
  Timer? _textAnimationTimer;
  Timer? _navigationTimer;

  // Animations
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scanAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToMain();
  }

  void _setupAnimations() {
    // 1. Pulse — icon breathe karta hai
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 2. Fade — poora screen fade in
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    // 3. Scan line — upar se neeche
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    // 4. Text fade + slide
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textFadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );
    _textSlideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // Text animation 600ms baad shuru ho
    _textAnimationTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) _textController.forward();
    });
  }

  // 3 second baad MainScreen pe jao
  Future<void> _navigateToMain() async {
    _navigationTimer = Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _textAnimationTimer?.cancel();
    _navigationTimer?.cancel();
    _pulseController.dispose();
    _fadeController.dispose();
    _scanController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Animated Scanner Icon ──────────────────────
              ScaleTransition(
                scale: _pulseAnimation,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow circle
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF6C63FF).withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Main circle
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF6C63FF),
                            Color(0xFF9C27B0),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                  child: ClipOval(
  child: Stack(
    alignment: Alignment.center,
    children: [
      // App icon image
      Image.asset(
        'assets/icons/app_icon.png',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      ),

      // Scan line animation — yeh waise hi rahega
      AnimatedBuilder(
        animation: _scanAnimation,
        builder: (context, _) {
          return Positioned(
            top: 130 * _scanAnimation.value,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ],
  ),
),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ── Animated Text ──────────────────────────────
              AnimatedBuilder(
                animation: _textController,
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(0, _textSlideAnimation.value),
                    child: FadeTransition(
                      opacity: _textFadeAnimation,
                      child: Column(
                        children: [
                          const Text(
                            'Smart Doc AI',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Scan • Extract • Analyze',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6C63FF),
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 80),

              // ── Loading dots ───────────────────────────────
              _LoadingDots(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Loading Dots Widget ──────────────────────────────────────────────────────
class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Timer> _dotTimers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _animations = _controllers.map((c) {
      return Tween<double>(begin: 0, end: -10).animate(
        CurvedAnimation(parent: c, curve: Curves.easeInOut),
      );
    }).toList();

    _dotTimers = [];

    // Staggered — one by one bounce animation
    for (int i = 0; i < 3; i++) {
      _dotTimers.add(
        Timer(Duration(milliseconds: i * 200), () {
          if (mounted) _controllers[i].repeat(reverse: true);
        }),
      );
    }
  }

  @override
  void dispose() {
    for (final timer in _dotTimers) {
      timer.cancel();
    }
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) {
            return Transform.translate(
              offset: Offset(0, _animations[i].value),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6C63FF).withOpacity(
                    i == 0 ? 1.0 : i == 1 ? 0.7 : 0.4,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
