import 'package:flutter/material.dart';

/// Consistent color palette for the Depozio app
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Color Palette
  static const Color midnightGraphite = Color(0xFF0C0F16); // Dark background
  static const Color softGold = Color(0xFFD7B56D); // Primary/Accent
  static const Color neoMint = Color(0xFFB5FFDA); // Secondary/Success
  static const Color mistSilver = Color(0xFFC9CCD5); // Neutral/Surface
  static const Color pearWhite = Color(0xFFFAFAFA); // Light background

  // Primary Colors
  static const Color primary = softGold; // Soft Gold
  static const Color primaryLight = Color(0xFFE5C98A); // Lighter Gold
  static const Color primaryDark = Color(0xFFB8964F); // Darker Gold

  // Secondary Colors
  static const Color secondary = neoMint; // Neo Mint
  static const Color secondaryLight = Color(0xFFC9FFE5); // Lighter Mint
  static const Color secondaryDark = Color(0xFF9FE6C4); // Darker Mint

  // Accent Colors
  static const Color accent = softGold; // Soft Gold as accent
  static const Color accentLight = Color(0xFFE5C98A); // Light Gold
  static const Color accentDark = Color(0xFFB8964F); // Dark Gold

  // Status Colors
  static const Color success = neoMint; // Neo Mint for success
  static const Color warning = Color(0xFFF59E0B); // Orange for warning
  static const Color error = Color(0xFFDC2626); // Red for error
  static const Color info = Color(0xFF0EA5E9); // Blue for information

  // Neutral Colors
  static const Color background = pearWhite; // Pear White background
  static const Color backgroundDark =
      midnightGraphite; // Midnight Graphite for dark
  static const Color surface = pearWhite; // Pear White surface
  static const Color surfaceDark = Color(0xFF1A1F24); // Dark surface
  static const Color onSurface = midnightGraphite; // Dark text on light
  static const Color onSurfaceDark = pearWhite; // Light text on dark
  static const Color onSurfaceVariant = mistSilver; // Muted text
  static const Color divider = mistSilver; // Mist Silver divider

  // Gradients
  static const List<Color> primaryGradient = [primary, primaryLight];
  static const List<Color> secondaryGradient = [secondary, secondaryLight];
  static const List<Color> accentGradient = [accent, accentLight];
  static const List<Color> goldGradient = [
    softGold,
    Color(0xFFE5C98A),
  ]; // Gold gradient
  static const List<Color> mintGradient = [
    neoMint,
    Color(0xFFC9FFE5),
  ]; // Mint gradient

  // Semantic Colors with Alpha
  static Color primaryWithAlpha(double alpha) =>
      primary.withValues(alpha: alpha);
  static Color secondaryWithAlpha(double alpha) =>
      secondary.withValues(alpha: alpha);
  static Color accentWithAlpha(double alpha) => accent.withValues(alpha: alpha);
  static Color whiteWithAlpha(double alpha) =>
      Colors.white.withValues(alpha: alpha);
  static Color blackWithAlpha(double alpha) =>
      Colors.black.withValues(alpha: alpha);
}
