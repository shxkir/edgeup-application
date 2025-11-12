import 'dart:math';
import 'package:flutter/material.dart';

/// Elegant animated background with subtle effects
/// Uses the premium gradient background with floating particles and shimmer
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final String? backgroundImage;
  final bool enableParticles;
  final bool enableShimmer;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.backgroundImage = 'assets/images/edgeup_bg_v3_grain.png',
    this.enableParticles = true,
    this.enableShimmer = true,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _particleController;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Shimmer animation - slow and subtle
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Particle animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..repeat();

    // Initialize particles
    if (widget.enableParticles) {
      _initializeParticles();
    }

    _particleController.addListener(() {
      setState(() {
        _updateParticles();
      });
    });
  }

  void _initializeParticles() {
    // Create subtle floating particles
    for (int i = 0; i < 20; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 1,
        speedX: (_random.nextDouble() - 0.5) * 0.0002,
        speedY: (_random.nextDouble() - 0.5) * 0.0003,
        opacity: _random.nextDouble() * 0.3 + 0.1,
      ));
    }
  }

  void _updateParticles() {
    for (var particle in _particles) {
      particle.x += particle.speedX;
      particle.y += particle.speedY;

      // Wrap around screen
      if (particle.x < 0) particle.x = 1;
      if (particle.x > 1) particle.x = 0;
      if (particle.y < 0) particle.y = 1;
      if (particle.y > 1) particle.y = 0;
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        if (widget.backgroundImage != null)
          Positioned.fill(
            child: Image.asset(
              widget.backgroundImage!,
              fit: BoxFit.cover,
            ),
          ),

        // Subtle shimmer effect
        if (widget.enableShimmer)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ShimmerPainter(
                    animation: _shimmerController.value,
                  ),
                );
              },
            ),
          ),

        // Floating particles
        if (widget.enableParticles)
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlePainter(particles: _particles),
            ),
          ),

        // Content on top
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = Colors.white.withAlpha((particle.opacity * 255).toInt())
        ..style = PaintingStyle.fill;

      final position = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );

      // Draw subtle glow
      final glowPaint = Paint()
        ..color = Colors.white.withAlpha((particle.opacity * 0.2 * 255).toInt())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(position, particle.size * 2, glowPaint);
      canvas.drawCircle(position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

class ShimmerPainter extends CustomPainter {
  final double animation;

  ShimmerPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    // Create a subtle diagonal shimmer that sweeps across
    final double shimmerPosition = (animation * 1.5 - 0.25) * size.width;

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.transparent,
        Colors.white.withAlpha(5),
        Colors.white.withAlpha(13),
        Colors.white.withAlpha(5),
        Colors.transparent,
      ],
      stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(
          shimmerPosition - 100,
          0,
          200,
          size.height,
        ),
      );

    canvas.drawRect(
      Rect.fromLTWH(shimmerPosition - 100, 0, 200, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(ShimmerPainter oldDelegate) =>
      animation != oldDelegate.animation;
}
