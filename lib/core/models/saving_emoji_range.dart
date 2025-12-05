/// Model for saving emoji range configuration
class SavingEmojiRange {
  final String
  label; // e.g., "Very sad", "Sad", "Normal", "Happy", "Very happy"
  final double threshold; // Amount threshold
  final String emoji; // Emoji to display

  const SavingEmojiRange({
    required this.label,
    required this.threshold,
    required this.emoji,
  });

  /// Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {'label': label, 'threshold': threshold, 'emoji': emoji};
  }

  /// Create from Map
  factory SavingEmojiRange.fromMap(Map<String, dynamic> map) {
    return SavingEmojiRange(
      label: map['label'] as String? ?? '',
      threshold: (map['threshold'] as num?)?.toDouble() ?? 0.0,
      emoji: map['emoji'] as String? ?? '',
    );
  }

  /// Default emoji ranges
  static List<SavingEmojiRange> getDefaultRanges() {
    return [
      const SavingEmojiRange(label: 'Very sad', threshold: -10000, emoji: '😢'),
      const SavingEmojiRange(label: 'Sad', threshold: 0, emoji: '😟'),
      const SavingEmojiRange(label: 'Normal', threshold: 5000, emoji: '😐'),
      const SavingEmojiRange(label: 'Happy', threshold: 20000, emoji: '😊'),
      const SavingEmojiRange(
        label: 'Very happy',
        threshold: double.infinity,
        emoji: '😄',
      ),
    ];
  }

  /// Get emoji for a given amount based on ranges
  static String getEmojiForAmount(
    double amount,
    List<SavingEmojiRange> ranges,
  ) {
    // Sort ranges by threshold (ascending), but put infinity at the end
    final sortedRanges = List<SavingEmojiRange>.from(ranges)..sort((a, b) {
      if (a.threshold == double.infinity) return 1;
      if (b.threshold == double.infinity) return -1;
      return a.threshold.compareTo(b.threshold);
    });

    // Find the appropriate range
    // Check from highest threshold down to lowest
    // The first range where amount >= threshold is the correct one
    for (int i = sortedRanges.length - 1; i >= 0; i--) {
      final range = sortedRanges[i];
      if (range.threshold == double.infinity) {
        // Infinity range matches everything, but check others first
        continue;
      }
      if (amount >= range.threshold) {
        return range.emoji;
      }
    }

    // If amount is less than all thresholds, use the first range (lowest threshold)
    // Or if there's an infinity range, use it as fallback
    final infinityRange = sortedRanges.firstWhere(
      (r) => r.threshold == double.infinity,
      orElse: () => sortedRanges.first,
    );
    return infinityRange.emoji;
  }
}
