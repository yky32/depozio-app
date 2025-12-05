import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/currency_helper.dart';
import 'package:depozio/core/bloc/app_core_bloc.dart';
import 'package:depozio/core/services/app_setting_service.dart';
import 'package:depozio/core/models/saving_emoji_range.dart';
import 'package:intl/intl.dart';

class TotalSavingsCard extends StatelessWidget {
  const TotalSavingsCard({
    super.key,
    required this.theme,
    required this.colorScheme,
    required this.l10n,
    required this.amount,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n;
  final double amount;

  /// Get emoji based on saving amount using custom ranges from settings
  String _getSavingEmoji(double amount) {
    AppSettingService.init();
    final rangesData = AppSettingService.getSavingEmojiRanges();
    final ranges =
        rangesData.map((map) => SavingEmojiRange.fromMap(map)).toList();
    return SavingEmojiRange.getEmojiForAmount(amount, ranges);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.savings, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              // Title section (left) with tooltip
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.home_page_total_savings,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _CurrencyReminderTooltip(
                    message: l10n.home_page_total_savings_currency_reminder,
                    theme: theme,
                  ),
                ],
              ),
              // Spacer to push flag to center
              const Spacer(),
              // Currency flag from AppCoreBloc (centered between title and emoji)
              BlocBuilder<AppCoreBloc, AppCoreState>(
                buildWhen: (previous, current) {
                  // Rebuild when currency changes
                  if (previous is AppCoreSettingsLoaded &&
                      current is AppCoreSettingsLoaded) {
                    return previous.currencyCode != current.currencyCode;
                  }
                  // Rebuild when transitioning to settings loaded state
                  return current is AppCoreSettingsLoaded ||
                      current is AppCoreCurrencyLoaded;
                },
                builder: (context, state) {
                  // Load currency if not already loaded
                  if (state is! AppCoreSettingsLoaded &&
                      state is! AppCoreCurrencyLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<AppCoreBloc>().add(const LoadCurrency());
                    });
                  }

                  // Get current currency from state or fallback to service
                  String currentCurrency;
                  if (state is AppCoreSettingsLoaded) {
                    currentCurrency = state.currencyCode;
                  } else if (state is AppCoreCurrencyLoaded) {
                    currentCurrency = state.currencyCode;
                  } else {
                    AppSettingService.init();
                    currentCurrency = AppSettingService.getDefaultCurrency();
                  }

                  final flag = CurrencyHelper.getFlag(currentCurrency);

                  return Text(flag, style: const TextStyle(fontSize: 24));
                },
              ),
              // Spacer to balance and push emoji to right
              const Spacer(),
              // Emoji indicator in top right corner
              Text(
                _getSavingEmoji(amount),
                style: const TextStyle(fontSize: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Format total savings as currency from AppCoreBloc
          BlocBuilder<AppCoreBloc, AppCoreState>(
            buildWhen: (previous, current) {
              // Rebuild when currency changes
              if (previous is AppCoreSettingsLoaded &&
                  current is AppCoreSettingsLoaded) {
                return previous.currencyCode != current.currencyCode;
              }
              // Rebuild when transitioning to settings loaded state
              return current is AppCoreSettingsLoaded ||
                  current is AppCoreCurrencyLoaded;
            },
            builder: (context, state) {
              // Load currency if not already loaded
              if (state is! AppCoreSettingsLoaded &&
                  state is! AppCoreCurrencyLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<AppCoreBloc>().add(const LoadCurrency());
                });
              }

              // Get current currency from state or fallback to service
              String currencyCode;
              if (state is AppCoreSettingsLoaded) {
                currencyCode = state.currencyCode;
              } else if (state is AppCoreCurrencyLoaded) {
                currencyCode = state.currencyCode;
              } else {
                AppSettingService.init();
                currencyCode = AppSettingService.getDefaultCurrency();
              }

              final currencySymbol = CurrencyHelper.getSymbol(currencyCode);
              final formattedSavings = NumberFormat.currency(
                symbol: currencySymbol,
                decimalDigits: 2,
              ).format(amount);

              // Keep amount color white for carousel
              const amountColor = Colors.white;

              return Text(
                formattedSavings,
                style: theme.textTheme.displayLarge?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Custom tooltip widget that shows on tap
class _CurrencyReminderTooltip extends StatefulWidget {
  const _CurrencyReminderTooltip({required this.message, required this.theme});

  final String message;
  final ThemeData theme;

  @override
  State<_CurrencyReminderTooltip> createState() =>
      _CurrencyReminderTooltipState();
}

class _CurrencyReminderTooltipState extends State<_CurrencyReminderTooltip> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _iconKey = GlobalKey();

  void _showTooltip() {
    if (_overlayEntry != null) {
      _hideTooltip();
      return;
    }

    final RenderBox? renderBox =
        _iconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: position.dx,
            top: position.dy + size.height + 8,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(maxWidth: 250),
                child: Text(
                  widget.message,
                  style: widget.theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _hideTooltip();
    });
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: _iconKey,
        onTap: _showTooltip,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            Icons.info_outline,
            size: 18,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
