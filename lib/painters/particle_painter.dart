import 'dart:math';
import 'package:flutter/material.dart';
import 'package:balatro_blast/utils/theme.dart';

class ScoreParticle {
  ScoreParticle({
    required this.position,
    required this.velocity,
    required this.text,
    required this.color,
    this.life = 1.0,
  });

  Offset position;
  Offset velocity;
  String text;
  Color color;
  double life;
}

/// Paints floating score particles for visual feedback.
class ParticlePainter extends CustomPainter {
  ParticlePainter({required this.particles});

  final List<ScoreParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      if (p.life <= 0) continue;

      final textPainter = TextPainter(
        text: TextSpan(
          text: p.text,
          style: TextStyle(
            color: p.color.withValues(alpha: p.life),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: p.color.withValues(alpha: p.life * 0.8),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        p.position - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) =>
      oldDelegate.particles != particles;
}

/// Creates and manages a set of score particles for animation.
class ParticleSystem {
  final List<ScoreParticle> particles = [];
  final _rng = Random();

  void spawnScoreParticles(Offset origin, int score) {
    particles.add(ScoreParticle(
      position: origin,
      velocity: Offset(0, -2),
      text: '+$score',
      color: AppColors.neonYellow,
    ));
  }

  void spawnChipsParticle(Offset origin, int chips) {
    particles.add(ScoreParticle(
      position: origin,
      velocity: Offset(-1.5, -1.5),
      text: '+$chips chips',
      color: AppColors.neonBlue,
    ));
  }

  void spawnMultParticle(Offset origin, int mult) {
    particles.add(ScoreParticle(
      position: origin,
      velocity: Offset(1.5, -1.5),
      text: '×$mult mult',
      color: AppColors.neonMagenta,
    ));
  }

  void update(double dt) {
    particles.removeWhere((p) => p.life <= 0);
    for (final p in particles) {
      p.position += p.velocity;
      p.life -= dt * 0.8;
      p.velocity = Offset(
        p.velocity.dx * 0.98,
        p.velocity.dy * 0.98,
      );
    }
  }

  bool get isEmpty => particles.isEmpty;
}
