import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/core/extensions/localizations.dart';
import 'package:depozio/router/app_page.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:depozio/core/services/app_setting_service.dart';
import 'package:depozio/core/bloc/app_core_bloc.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/currency_helper.dart';
import 'package:depozio/widgets/bottom_sheets/select_currency_bottom_sheet.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/services/transaction_service.dart';
import 'package:depozio/features/deposit/presentation/bloc/deposit_bloc.dart';
import 'package:depozio/features/home/presentation/bloc/home_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.setting_page_title,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              // Profile Section
              _buildProfileSection(context, theme, colorScheme),
              const SizedBox(height: 32),
              // Testing Section
              _buildTestingSection(context, theme, colorScheme),
              const SizedBox(height: 32),
              // App Info Section
              _buildAppInfoSection(context, theme, colorScheme),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    AppSettingService.init();
    final currentUsername = AppSettingService.getUsername() ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            () => _showUsernameDialog(
              context,
              theme,
              colorScheme,
              currentUsername,
            ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Circle Avatar Icon (30%)
                Expanded(
                  flex: 3,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Username or placeholder (70%)
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUsername.isEmpty
                            ? context.l10n.setting_page_coming_soon
                            : currentUsername,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color:
                              currentUsername.isEmpty
                                  ? colorScheme.onSurface.withValues(alpha: 0.6)
                                  : colorScheme.onSurface,
                        ),
                      ),
                      if (currentUsername.isEmpty)
                        Text(
                          'Tap to set username',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showUsernameDialog(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    String currentUsername,
  ) async {
    final textController = TextEditingController(text: currentUsername);
    final l10n = context.l10n;

    final result = await showDialog<String>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text('Set Username'),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Enter your username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => dialogContext.pop(),
                child: Text(l10n.action_cancel),
              ),
              TextButton(
                onPressed: () {
                  final username = textController.text.trim();
                  if (username.isNotEmpty) {
                    dialogContext.pop(username);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
    );

    if (result != null && result.isNotEmpty && context.mounted) {
      await AppSettingService.saveUsername(result);
      // Refresh the home page if it's available
      try {
        context.read<HomeBloc>().add(const RefreshHome());
      } catch (e) {
        // HomeBloc might not be available in this context
      }
    }
  }

  Widget _buildTestingSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final l10n = context.l10n;
    return _buildSettingsSection(
      l10n.setting_page_testing,
      [
        _buildSettingsTile(
          icon: AppPage.fontTest.icon,
          title: l10n.setting_page_font_test,
          subtitle: l10n.setting_page_font_test_subtitle,
          onTap: () => context.go(AppPage.fontTest.path),
          theme: theme,
          colorScheme: colorScheme,
        ),
      ],
      theme,
      colorScheme,
    );
  }

  Future<void> _showClearDataConfirmation(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(l10n.setting_page_clear_data_dialog_title),
            content: Text(l10n.setting_page_clear_data_dialog_message),
            actions: [
              TextButton(
                onPressed: () => dialogContext.pop(false),
                child: Text(l10n.action_cancel),
              ),
              TextButton(
                onPressed: () => dialogContext.pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(l10n.setting_page_clear_data_confirm),
              ),
            ],
          ),
    );

    if (confirmed == true && context.mounted) {
      await _clearAllData(context);
    }
  }

  Future<void> _clearAllData(BuildContext context) async {
    try {
      // Initialize services
      await CategoryService.init();
      await TransactionService.init();

      // Clear all categories
      final categoryService = CategoryService();
      await categoryService.clearAllCategories();

      // Clear all transactions
      final transactionService = TransactionService();
      await transactionService.clearAllTransactions();

      // Refresh DepositBloc if available
      try {
        context.read<DepositBloc>().add(LoadDeposits());
      } catch (e) {
        // DepositBloc might not be available in this context
      }

      // Refresh HomeBloc if available
      try {
        context.read<HomeBloc>().add(const RefreshHome());
      } catch (e) {
        // HomeBloc might not be available in this context
      }

      // Data cleared successfully (silent success)
    } catch (e) {
      // Error clearing data (silent failure)
    }
  }

  Widget _buildAppInfoSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        final packageInfo = snapshot.data;
        if (packageInfo == null) {
          return const SizedBox.shrink();
        }

        final version = packageInfo.version;
        final buildNumber = packageInfo.buildNumber;
        final appName = packageInfo.appName;

        final l10n = context.l10n;
        return _buildSettingsSection(
          l10n.setting_page_app_information,
          [
            _buildLanguageTile(context, theme, colorScheme),
            _buildCurrencyTile(context, theme, colorScheme),
            _buildInfoTile(
              icon: Icons.info_outline,
              title: l10n.setting_page_app_version,
              subtitle: '$version ($buildNumber)',
              theme: theme,
              colorScheme: colorScheme,
            ),
            _buildInfoTile(
              icon: Icons.phone_android,
              title: l10n.setting_page_app_name,
              subtitle: appName,
              theme: theme,
              colorScheme: colorScheme,
            ),
            _buildSettingsTile(
              icon: Icons.delete_outline,
              title: l10n.setting_page_clear_all_data,
              subtitle: l10n.setting_page_clear_all_data_subtitle,
              onTap:
                  () => _showClearDataConfirmation(context, theme, colorScheme),
              theme: theme,
              colorScheme: colorScheme,
              showChevron: false,
            ),
          ],
          theme,
          colorScheme,
        );
      },
    );
  }

  Widget _buildSettingsSection(
    String title,
    List<Widget> children,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
    required ColorScheme colorScheme,
    bool showChevron = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (showChevron)
                const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final currentLocale = widgets.Localizations.localeOf(context);
    final currentLanguage = _getLanguageDisplayName(currentLocale);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showLanguageSelector(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.language,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.setting_page_language,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentLanguage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
            ],
          ),
        ),
      ),
    );
  }

  String _getLanguageDisplayName(Locale locale) {
    if (locale.countryCode == 'TW') {
      return 'Chinese (Traditional)';
    } else if (locale.languageCode == 'zh') {
      return 'Chinese (Simplified)';
    } else {
      return 'English';
    }
  }

  Widget _buildCurrencyTile(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return BlocBuilder<AppCoreBloc, AppCoreState>(
      buildWhen: (previous, current) {
        // Rebuild when currency changes in settings state
        if (previous is AppCoreSettingsLoaded &&
            current is AppCoreSettingsLoaded) {
          return previous.currencyCode != current.currencyCode;
        }
        // Rebuild when transitioning to settings loaded state
        return current is AppCoreSettingsLoaded;
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

        final currencyName = CurrencyHelper.getName(
          currentCurrency,
          context.l10n,
        );
        final currencySymbol = CurrencyHelper.getSymbol(currentCurrency);
        final flag = CurrencyHelper.getFlag(currentCurrency);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showCurrencySelector(context),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.currency_exchange,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.setting_page_default_currency,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(flag, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(
                              '$currencySymbol $currencyName',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCurrencySelector(BuildContext context) async {
    AppSettingService.init();
    final currentCurrency = AppSettingService.getDefaultCurrency();
    final bloc = context.read<AppCoreBloc>();

    final selectedCurrency = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (BuildContext context) {
        return SelectCurrencyBottomSheet(
          currentCurrency: currentCurrency,
          title: context.l10n.setting_page_select_default_currency,
        );
      },
    );

    if (selectedCurrency != null && selectedCurrency != currentCurrency) {
      // Dispatch ChangeCurrency event to AppCoreBloc
      bloc.add(ChangeCurrency(currencyCode: selectedCurrency));
    }
  }

  Future<void> _showLanguageSelector(BuildContext context) async {
    final currentLocale = widgets.Localizations.localeOf(context);
    final supportedLocales = AppSettingService.getSupportedLocales();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedLocale = await showModalBottomSheet<Locale>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      useRootNavigator: true, // Use root navigator to show above navigation bar
      useSafeArea: false, // Don't use safe area to cover navigation bar
      builder: (bottomSheetContext) {
        final mediaQuery = MediaQuery.of(bottomSheetContext);
        final screenHeight = mediaQuery.size.height;
        final maxHeight = screenHeight * 0.5;

        return Stack(
          children: [
            // Backdrop to cover navigation bar - tappable to dismiss
            Positioned.fill(
              child: GestureDetector(
                onTap: () => bottomSheetContext.pop(),
                child: Container(color: Colors.black.withValues(alpha: 0.5)),
              ),
            ),
            // Bottom sheet content
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: BoxConstraints(maxHeight: maxHeight),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => bottomSheetContext.pop(),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Container(
                          width: 80,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: Text(
                        context.l10n.setting_page_select_language,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        itemCount: supportedLocales.length,
                        itemBuilder: (context, index) {
                          final locale = supportedLocales[index];
                          final displayName =
                              AppSettingService.getLocaleDisplayName(locale);
                          final isSelected =
                              currentLocale.languageCode ==
                                  locale.languageCode &&
                              currentLocale.countryCode == locale.countryCode;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () => bottomSheetContext.pop(locale),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? colorScheme.primary.withValues(
                                            alpha: 0.1,
                                          )
                                          : colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? colorScheme.primary
                                            : colorScheme.outline.withValues(
                                              alpha: 0.2,
                                            ),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        displayName,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontWeight:
                                                  isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                              color:
                                                  isSelected
                                                      ? colorScheme.primary
                                                      : colorScheme.onSurface,
                                            ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: colorScheme.primary,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

    if (selectedLocale != null && selectedLocale != currentLocale) {
      // Dispatch locale change event to AppCoreBloc
      if (context.mounted) {
        context.read<AppCoreBloc>().add(ChangeLocale(locale: selectedLocale));
      }
    }
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
