import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/features/home/presentation/bloc/home_bloc.dart';
import 'package:depozio/core/bloc/app_core_bloc.dart';
import 'package:depozio/core/services/app_setting_service.dart';
import 'package:depozio/features/home/presentation/pages/widgets/total_savings_card.dart';
import 'package:depozio/features/home/presentation/pages/widgets/statistic_card.dart';
import 'package:depozio/features/home/presentation/pages/widgets/savings_goal_card.dart';
import 'package:depozio/features/home/presentation/pages/widgets/recent_activity_section.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/currency_helper.dart';
import 'package:intl/intl.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.theme,
    required this.colorScheme,
    required this.l10n,
    required this.state,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n;
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    // Get total savings from bloc state (calculated as: totalDeposits - totalExpenses)
    // The calculation is done in HomeBloc to ensure consistency
    final totalSavings =
        state is HomeLoaded ? (state as HomeLoaded).totalSavings : 0.0;

    // Get total deposits and expenses for display in statistics cards
    final totalDeposits =
        state is HomeLoaded ? (state as HomeLoaded).totalDeposits : 0.0;
    final totalExpenses =
        state is HomeLoaded ? (state as HomeLoaded).totalExpenses : 0.0;

    return BlocBuilder<AppCoreBloc, AppCoreState>(
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
      builder: (context, appCoreState) {
        // Load currency if not already loaded
        if (appCoreState is! AppCoreSettingsLoaded &&
            appCoreState is! AppCoreCurrencyLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AppCoreBloc>().add(const LoadCurrency());
          });
        }

        // Get current currency from state or fallback to service
        String currencyCode;
        if (appCoreState is AppCoreSettingsLoaded) {
          currencyCode = appCoreState.currencyCode;
        } else if (appCoreState is AppCoreCurrencyLoaded) {
          currencyCode = appCoreState.currencyCode;
        } else {
          AppSettingService.init();
          currencyCode = AppSettingService.getDefaultCurrency();
        }

        final currencySymbol = CurrencyHelper.getSymbol(currencyCode);
        final formattedDeposits = NumberFormat.currency(
          symbol: currencySymbol,
          decimalDigits: 2,
        ).format(totalDeposits);
        final formattedExpenses = NumberFormat.currency(
          symbol: currencySymbol,
          decimalDigits: 2,
        ).format(totalExpenses);

        return BlocBuilder<AppCoreBloc, AppCoreState>(
          buildWhen: (previous, current) {
            // Rebuild when start date changes
            if (previous is AppCoreSettingsLoaded &&
                current is AppCoreSettingsLoaded) {
              return previous.startDate != current.startDate;
            }
            return current is AppCoreSettingsLoaded;
          },
          builder: (context, appCoreState) {
            // Load start date if not already loaded
            if (appCoreState is! AppCoreSettingsLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<AppCoreBloc>().add(const LoadStartDate());
              });
            }

            // Get current start date from state or fallback to service
            int startDate;
            if (appCoreState is AppCoreSettingsLoaded) {
              startDate = appCoreState.startDate;
            } else {
              AppSettingService.init();
              startDate = AppSettingService.getStartDate();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date range indicator
                _DateRangeIndicator(
                  theme: theme,
                  colorScheme: colorScheme,
                  startDay: startDate,
                ),
                const SizedBox(height: 16),
                // Carousel with Total Savings and Savings Goal cards
                _CarouselSection(
                  theme: theme,
                  colorScheme: colorScheme,
                  l10n: l10n,
                  totalSavings: totalSavings,
                ),
                const SizedBox(height: 24),
                // Grid with 2 columns
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.25,
                  children: [
                    StatisticCard(
                      theme: theme,
                      colorScheme: colorScheme,
                      title: l10n.home_page_deposits,
                      value: formattedDeposits,
                      icon: Icons.account_balance_wallet,
                      valueColor: Colors.green.shade700,
                      topRightIcon: Icons.arrow_upward,
                      topRightIconColor: Colors.green.shade700,
                      topRightIconBackgroundColor: Colors.green.withValues(
                        alpha: 0.1,
                      ),
                    ),
                    StatisticCard(
                      theme: theme,
                      colorScheme: colorScheme,
                      title: l10n.home_page_expenses,
                      value: formattedExpenses,
                      icon: Icons.receipt_long,
                      valueColor: Colors.red.shade700,
                      topRightIcon: Icons.arrow_downward,
                      topRightIconColor: Colors.red.shade700,
                      topRightIconBackgroundColor: Colors.red.withValues(
                        alpha: 0.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Recent Activity
                RecentActivitySection(
                  theme: theme,
                  colorScheme: colorScheme,
                  l10n: l10n,
                  state: state,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// Date range indicator showing the calculation period
class _DateRangeIndicator extends StatelessWidget {
  const _DateRangeIndicator({
    required this.theme,
    required this.colorScheme,
    required this.startDay,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final int startDay;

  DateTime _getCurrentPeriodStart(DateTime now) {
    // If current day is >= startDay, period started on startDay of current month
    // Otherwise, period started on startDay of previous month
    if (now.day >= startDay) {
      return DateTime(now.year, now.month, startDay);
    } else {
      // Previous month
      final prevMonth = now.month == 1 ? 12 : now.month - 1;
      final prevYear = now.month == 1 ? now.year - 1 : now.year;
      // Handle months with fewer days (e.g., Feb 29th -> Feb 28th)
      final daysInMonth = DateTime(prevYear, prevMonth + 1, 0).day;
      final adjustedDay = startDay > daysInMonth ? daysInMonth : startDay;
      return DateTime(prevYear, prevMonth, adjustedDay);
    }
  }

  DateTime _getNextPeriodStart(DateTime now) {
    // Get the current period start date first
    final currentPeriodStart = _getCurrentPeriodStart(now);
    // Next period starts on startDay of the month after the current period's month
    final nextMonth =
        currentPeriodStart.month == 12 ? 1 : currentPeriodStart.month + 1;
    final nextYear =
        currentPeriodStart.month == 12
            ? currentPeriodStart.year + 1
            : currentPeriodStart.year;
    // Handle months with fewer days
    final daysInMonth = DateTime(nextYear, nextMonth + 1, 0).day;
    final adjustedDay = startDay > daysInMonth ? daysInMonth : startDay;
    return DateTime(nextYear, nextMonth, adjustedDay);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final periodStart = _getCurrentPeriodStart(now);
    final nextPeriodStart = _getNextPeriodStart(now);
    // Check if we haven't reached the next period start date yet
    final hasNotReachedNextPeriod = now.isBefore(nextPeriodStart);

    // Format start date as dd MMM (short format for display with space)
    final formattedStartDate = DateFormat(
      'dd MMM',
      'en_US',
    ).format(periodStart);

    // Full date format for tooltips (dd-MMM-yyyy)
    final fullStartDate = DateFormat(
      'dd-MMM-yyyy',
      'en_US',
    ).format(periodStart);

    final fullNextPeriodDate = DateFormat(
      'dd-MMM-yyyy',
      'en_US',
    ).format(nextPeriodStart);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Start date with icon
          GestureDetector(
            onTap: () {
              // Show tooltip with full date
              final overlay = Overlay.of(context);
              final RenderBox? renderBox =
                  context.findRenderObject() as RenderBox?;
              final offset =
                  renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
              final size = renderBox?.size ?? Size.zero;

              final overlayEntry = OverlayEntry(
                builder:
                    (context) => Positioned(
                      left: offset.dx,
                      top: offset.dy + size.height + 8,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            fullStartDate,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
              );
              overlay.insert(overlayEntry);
              Future.delayed(const Duration(seconds: 3), () {
                overlayEntry.remove();
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: fullStartDate,
                  child: Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: fullStartDate,
                  child: Text(
                    formattedStartDate,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // MTR-style separator with line and 2 stations (start and end)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Start station
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  // Continuous horizontal line
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  // End station
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Now with icon and info button
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Now',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.access_time, size: 16, color: colorScheme.primary),
              if (hasNotReachedNextPeriod) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // Show tooltip on tap
                    final overlay = Overlay.of(context);
                    final RenderBox? renderBox =
                        context.findRenderObject() as RenderBox?;
                    final offset =
                        renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
                    final size = renderBox?.size ?? Size.zero;

                    final overlayEntry = OverlayEntry(
                      builder:
                          (context) => Positioned(
                            left: offset.dx + size.width - 200,
                            top: offset.dy + size.height + 8,
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Next period: $fullNextPeriodDate',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    );
                    overlay.insert(overlayEntry);
                    Future.delayed(const Duration(seconds: 3), () {
                      overlayEntry.remove();
                    });
                  },
                  child: Tooltip(
                    message: 'Next period: $fullNextPeriodDate',
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.info_outline,
                        size: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Carousel widget for Total Savings and Savings Goal cards
/// Uses minimal StatefulWidget only for UI-only state (PageController lifecycle)
/// This follows README.md guidelines: "StatefulWidget should ONLY be used for:
/// - UI-only state (scroll position, animation controllers, form field focus)
/// - Widget lifecycle management (e.g., StreamSubscription cleanup)"
class _CarouselSection extends StatefulWidget {
  const _CarouselSection({
    required this.theme,
    required this.colorScheme,
    required this.l10n,
    required this.totalSavings,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n;
  final double totalSavings;

  @override
  State<_CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<_CarouselSection> {
  // UI-only state: PageController for scroll position (acceptable per README.md)
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180, // Height to accommodate both cards
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              // Page 1: Total Savings Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: TotalSavingsCard(
                    theme: widget.theme,
                    colorScheme: widget.colorScheme,
                    l10n: widget.l10n,
                    amount: widget.totalSavings,
                  ),
                ),
              ),
              // Page 2: Savings Goal Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SavingsGoalCard(
                  theme: widget.theme,
                  colorScheme: widget.colorScheme,
                  l10n: widget.l10n,
                ),
              ),
            ],
          ),
        ),
        // Page indicators
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentPage == index
                        ? widget.colorScheme.primary
                        : widget.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
