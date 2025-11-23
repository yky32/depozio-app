import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class _WaveText extends StatelessWidget {
  const _WaveText({
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: text.split('').asMap().entries.map((entry) {
        final index = entry.key;
        final char = entry.value;
        final delay = index * 100; // 100ms delay between each letter

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            // Calculate animation progress with delay
            final progress = ((value * 1200) - delay) / 600;
            final clampedProgress = progress.clamp(0.0, 1.0);

            // Jump effect: letter moves up then down
            final jumpOffset = clampedProgress < 0.5
                ? -30.0 * (clampedProgress * 2) // Jump up
                : -30.0 * (2 - clampedProgress * 2); // Come down

            // Fade in effect
            final opacity = clampedProgress;

            // Scale effect for bounce
            final scale = clampedProgress < 0.5
                ? 1.0 + (0.3 * (clampedProgress * 2)) // Scale up
                : 1.3 - (0.3 * ((clampedProgress - 0.5) * 2)); // Scale down

            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: Transform.translate(
                  offset: Offset(0, jumpOffset),
                  child: Text(
                    char == ' ' ? '\u00A0' : char, // Non-breaking space
                    style: style,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    this.lottiePath = 'assets/lottie/splash-logo.json',
  });

  final String lottiePath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Navigate to home after animation completes
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (context.mounted) {
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeIn,
          builder: (context, fadeValue, child) {
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.5, end: 1.0),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutBack,
              builder: (context, scaleValue, child) {
                return Opacity(
                  opacity: fadeValue,
                  child: Transform.scale(
                    scale: scaleValue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie Animation
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(
                            lottiePath,
                            fit: BoxFit.contain,
                            repeat: true,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if Lottie file is not found
                              return Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          colorScheme.primary.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.store,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // App Name with wave animation (left to right jump)
                        _WaveText(
                          text: 'Depozio',
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
