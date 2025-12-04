import 'package:depozio/core/extensions/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:depozio/features/home/presentation/bloc/home_bloc.dart';
import 'package:depozio/core/network/logger.dart';
import 'package:depozio/core/services/app_setting_service.dart';
import 'package:depozio/core/bloc/app_core_bloc.dart';
import 'package:depozio/features/home/presentation/pages/widgets/home_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    LoggerUtil.i('🏗️ Building HomePage');

    return BlocProvider(
      create: (context) {
        LoggerUtil.d('🔧 Creating HomeBloc instance');
        return HomeBloc()..add(const LoadHome());
      },
      child: _HomePageContent(
        theme: theme,
        colorScheme: colorScheme,
        l10n: l10n,
      ),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent({
    required this.theme,
    required this.colorScheme,
    required this.l10n,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic l10n;

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) {
            // Always rebuild on state type changes
            if (previous.runtimeType != current.runtimeType) {
              LoggerUtil.d(
                '🔄 State type changed: ${previous.runtimeType} -> ${current.runtimeType}',
              );
              return true;
            }
            // Rebuild when transitioning to/from refreshing state
            if (previous is HomeRefreshing || current is HomeRefreshing) {
              return true;
            }
            // For HomeLoaded states, rebuild when refresh timestamp changes
            if (previous is HomeLoaded && current is HomeLoaded) {
              final refreshChanged =
                  previous.refreshTimestamp != current.refreshTimestamp;
              if (refreshChanged) {
                LoggerUtil.d('🔄 Refresh timestamp changed');
              }
              return refreshChanged;
            }
            return false;
          },
          builder: (context, state) {
            LoggerUtil.d(
              '🎨 BlocBuilder building with state: ${state.runtimeType}',
            );

            // Show error state
            if (state is HomeError) {
              LoggerUtil.w('⚠️ Showing error state: ${state.error}');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading home data',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(const LoadHome());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // For all other states (Loading, Refreshing, Loaded), use the same structure
            // This prevents layout shifts and zoom effects
            final isSkeletonEnabled =
                state is HomeLoading || state is HomeRefreshing;

            // Use a GlobalKey to access ScrollPosition for restoration
            final scrollKey = GlobalKey();

            return BlocListener<HomeBloc, HomeState>(
              listenWhen: (previous, current) {
                // Listen when transitioning from Refreshing to Loaded
                return previous is HomeRefreshing && current is HomeLoaded;
              },
              listener: (context, state) {
                // Restore scroll position after refresh
                if (state is HomeLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final scrollableState =
                        scrollKey.currentContext
                            ?.findAncestorStateOfType<ScrollableState>();
                    if (scrollableState != null) {
                      final position = scrollableState.position;
                      position.jumpTo(state.scrollOffset);
                    }
                  });
                }
              },
              child: NotificationListener<ScrollUpdateNotification>(
                onNotification: (notification) {
                  // Update scroll position in BLoC as user scrolls
                  final offset = notification.metrics.pixels;
                  context.read<HomeBloc>().add(UpdateScrollOffset(offset));
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    LoggerUtil.d('🔄 Pull to refresh triggered');
                    // Save current scroll position before refresh
                    final scrollableState =
                        scrollKey.currentContext
                            ?.findAncestorStateOfType<ScrollableState>();
                    if (scrollableState != null) {
                      final position = scrollableState.position;
                      final currentOffset = position.pixels;
                      context.read<HomeBloc>().add(
                        UpdateScrollOffset(currentOffset),
                      );
                    }
                    context.read<HomeBloc>().add(const RefreshHome());
                    await Future.delayed(const Duration(milliseconds: 300));
                  },
                  color: colorScheme.primary,
                  child: SingleChildScrollView(
                    key: scrollKey,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page title with username and start date badge (not skeletonized, stays in position)
                        Builder(
                          builder: (context) {
                            AppSettingService.init();
                            final username = AppSettingService.getUsername();
                            final title =
                                username != null && username.isNotEmpty
                                    ? l10n.home_page_greeting(username)
                                    : l10n.home_page_title;

                            return BlocBuilder<AppCoreBloc, AppCoreState>(
                              buildWhen: (previous, current) {
                                // Rebuild when start date changes in settings state
                                if (previous is AppCoreSettingsLoaded &&
                                    current is AppCoreSettingsLoaded) {
                                  return previous.startDate != current.startDate;
                                }
                                // Rebuild when transitioning to settings loaded state
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

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: theme.textTheme.displayMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${startDate}${_getDaySuffix(startDate)}',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        // Content with Skeletonizer (only content, not title)
                        Skeletonizer(
                          enabled: isSkeletonEnabled,
                          child: HomeContent(
                            theme: theme,
                            colorScheme: colorScheme,
                            l10n: l10n,
                            state: state,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
          ],
        ),
      ),
    );
  }
}
