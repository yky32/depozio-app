import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @action_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get action_cancel;

  /// No description provided for @action_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get action_confirm;

  /// No description provided for @login_page_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get login_page_email;

  /// No description provided for @login_page_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_page_password;

  /// No description provided for @login_page_submit.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_page_submit;

  /// No description provided for @home_page_title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_page_title;

  /// No description provided for @home_page_deposits.
  ///
  /// In en, this message translates to:
  /// **'Deposits'**
  String get home_page_deposits;

  /// No description provided for @home_page_expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get home_page_expenses;

  /// No description provided for @home_page_total_savings.
  ///
  /// In en, this message translates to:
  /// **'Total Savings'**
  String get home_page_total_savings;

  /// No description provided for @home_page_savings_goal.
  ///
  /// In en, this message translates to:
  /// **'Savings Goal'**
  String get home_page_savings_goal;

  /// No description provided for @home_page_monthly_savings.
  ///
  /// In en, this message translates to:
  /// **'Monthly Savings'**
  String get home_page_monthly_savings;

  /// No description provided for @home_page_recent_activity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get home_page_recent_activity;

  /// No description provided for @home_page_no_activity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get home_page_no_activity;

  /// No description provided for @deposit_page_title.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit_page_title;

  /// No description provided for @deposit_page_add_category.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get deposit_page_add_category;

  /// No description provided for @add_category_bottom_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get add_category_bottom_sheet_title;

  /// No description provided for @add_category_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get add_category_name;

  /// No description provided for @add_category_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter category name'**
  String get add_category_name_hint;

  /// No description provided for @add_category_icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get add_category_icon;

  /// No description provided for @add_category_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get add_category_type;

  /// No description provided for @add_category_type_deposits.
  ///
  /// In en, this message translates to:
  /// **'Deposits'**
  String get add_category_type_deposits;

  /// No description provided for @add_category_type_expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get add_category_type_expenses;

  /// No description provided for @transaction_record_title.
  ///
  /// In en, this message translates to:
  /// **'Record Transaction'**
  String get transaction_record_title;

  /// No description provided for @transaction_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transaction_amount;

  /// No description provided for @transaction_category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transaction_category;

  /// No description provided for @transaction_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get transaction_description;

  /// No description provided for @transaction_description_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get transaction_description_placeholder;

  /// No description provided for @transaction_select_currency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get transaction_select_currency;

  /// No description provided for @transaction_select_category.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get transaction_select_category;

  /// No description provided for @transaction_select_category_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get transaction_select_category_placeholder;

  /// No description provided for @transaction_please_select_category.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get transaction_please_select_category;

  /// No description provided for @transaction_please_enter_amount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get transaction_please_enter_amount;

  /// No description provided for @transaction_please_enter_valid_amount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get transaction_please_enter_valid_amount;

  /// No description provided for @transaction_recorded.
  ///
  /// In en, this message translates to:
  /// **'Transaction recorded: {amount} - {category}'**
  String transaction_recorded(String amount, String category);

  /// No description provided for @transaction_no_categories_available.
  ///
  /// In en, this message translates to:
  /// **'No categories available. Please create a category first.'**
  String get transaction_no_categories_available;

  /// No description provided for @currency_usd.
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get currency_usd;

  /// No description provided for @currency_eur.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get currency_eur;

  /// No description provided for @currency_gbp.
  ///
  /// In en, this message translates to:
  /// **'British Pound'**
  String get currency_gbp;

  /// No description provided for @currency_jpy.
  ///
  /// In en, this message translates to:
  /// **'Japanese Yen'**
  String get currency_jpy;

  /// No description provided for @currency_cny.
  ///
  /// In en, this message translates to:
  /// **'Chinese Yuan'**
  String get currency_cny;

  /// No description provided for @currency_hkd.
  ///
  /// In en, this message translates to:
  /// **'Hong Kong Dollar'**
  String get currency_hkd;

  /// No description provided for @currency_sgd.
  ///
  /// In en, this message translates to:
  /// **'Singapore Dollar'**
  String get currency_sgd;

  /// No description provided for @currency_thb.
  ///
  /// In en, this message translates to:
  /// **'Thai Baht'**
  String get currency_thb;

  /// No description provided for @currency_krw.
  ///
  /// In en, this message translates to:
  /// **'South Korean Won'**
  String get currency_krw;

  /// No description provided for @currency_aud.
  ///
  /// In en, this message translates to:
  /// **'Australian Dollar'**
  String get currency_aud;

  /// No description provided for @currency_cad.
  ///
  /// In en, this message translates to:
  /// **'Canadian Dollar'**
  String get currency_cad;

  /// No description provided for @deposit_page_error_loading.
  ///
  /// In en, this message translates to:
  /// **'Error loading categories'**
  String get deposit_page_error_loading;

  /// No description provided for @deposit_page_error_message.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String deposit_page_error_message(String error);

  /// No description provided for @deposit_page_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get deposit_page_retry;

  /// No description provided for @deposit_page_no_categories.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get deposit_page_no_categories;

  /// No description provided for @deposit_page_add_category_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add a category'**
  String get deposit_page_add_category_hint;

  /// No description provided for @add_category_please_select_type.
  ///
  /// In en, this message translates to:
  /// **'Please select a type'**
  String get add_category_please_select_type;

  /// No description provided for @add_category_please_select_icon.
  ///
  /// In en, this message translates to:
  /// **'Please select an icon'**
  String get add_category_please_select_icon;

  /// No description provided for @add_category_please_enter_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter a category name'**
  String get add_category_please_enter_name;

  /// No description provided for @add_category_please_select_icon_and_type.
  ///
  /// In en, this message translates to:
  /// **'Please select an icon and type'**
  String get add_category_please_select_icon_and_type;

  /// No description provided for @add_category_error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String add_category_error(String error);

  /// No description provided for @delete_category_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get delete_category_dialog_title;

  /// No description provided for @delete_category_dialog_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String delete_category_dialog_message(String name);

  /// No description provided for @delete_category_action.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_category_action;

  /// No description provided for @delete_category_snackbar.
  ///
  /// In en, this message translates to:
  /// **'Category \"{name}\" deleted'**
  String delete_category_snackbar(String name);

  /// No description provided for @delete_category_undo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get delete_category_undo;

  /// No description provided for @delete_category_error.
  ///
  /// In en, this message translates to:
  /// **'Error deleting category: {error}'**
  String delete_category_error(String error);

  /// No description provided for @slidable_category_edit_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Edit \"{name}\" - Coming soon'**
  String slidable_category_edit_coming_soon(String name);

  /// No description provided for @slidable_category_archive_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Archive \"{name}\" - Coming soon'**
  String slidable_category_archive_coming_soon(String name);

  /// No description provided for @slidable_category_type_deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get slidable_category_type_deposit;

  /// No description provided for @slidable_category_type_expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get slidable_category_type_expense;

  /// No description provided for @analytics_page_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get analytics_page_coming_soon;

  /// No description provided for @setting_page_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting_page_title;

  /// No description provided for @setting_page_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get setting_page_coming_soon;

  /// No description provided for @setting_page_testing.
  ///
  /// In en, this message translates to:
  /// **'Testing'**
  String get setting_page_testing;

  /// No description provided for @setting_page_font_test.
  ///
  /// In en, this message translates to:
  /// **'Font Test'**
  String get setting_page_font_test;

  /// No description provided for @setting_page_font_test_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Satoshi font is applied correctly'**
  String get setting_page_font_test_subtitle;

  /// No description provided for @setting_page_app_information.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get setting_page_app_information;

  /// No description provided for @setting_page_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get setting_page_language;

  /// No description provided for @setting_page_select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get setting_page_select_language;

  /// No description provided for @setting_page_app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get setting_page_app_version;

  /// No description provided for @setting_page_app_name.
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get setting_page_app_name;

  /// No description provided for @login_page_error.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get login_page_error;

  /// No description provided for @login_page_email_hint.
  ///
  /// In en, this message translates to:
  /// **'example@example.com'**
  String get login_page_email_hint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
