// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get action_cancel => 'Cancel';

  @override
  String get action_confirm => 'Confirm';

  @override
  String get action_save => 'Save';

  @override
  String get login_page_email => 'Email';

  @override
  String get login_page_password => 'Password';

  @override
  String get login_page_submit => 'Login';

  @override
  String get home_page_title => 'Home';

  @override
  String home_page_greeting(String username) {
    return 'Hi, $username';
  }

  @override
  String get home_page_deposits => 'Deposits';

  @override
  String get home_page_expenses => 'Expenses';

  @override
  String get home_page_total_savings => 'Total Savings';

  @override
  String get home_page_total_savings_currency_reminder =>
      'Currency exchange rates may affect the calculation';

  @override
  String get home_page_savings_goal => 'Savings Goal';

  @override
  String get home_page_monthly_savings => 'Monthly Savings';

  @override
  String get home_page_recent_activity => 'Recent Activity';

  @override
  String get home_page_no_activity => 'No recent activity';

  @override
  String get deposit_page_title => 'Deposit';

  @override
  String get deposit_page_add_category => 'Add Category';

  @override
  String get add_category_bottom_sheet_title => 'Add Category';

  @override
  String get add_category_name => 'Name';

  @override
  String get add_category_name_hint => 'Enter category name';

  @override
  String get add_category_icon => 'Icon';

  @override
  String get add_category_type => 'Type';

  @override
  String get add_category_type_deposits => 'Deposits';

  @override
  String get add_category_type_expenses => 'Expenses';

  @override
  String get transaction_record_title => 'Record Transaction';

  @override
  String get transaction_amount => 'Amount';

  @override
  String get transaction_category => 'Category';

  @override
  String get transaction_description => 'Description';

  @override
  String get transaction_description_placeholder => 'Add a note (optional)';

  @override
  String get transaction_select_currency => 'Select Currency';

  @override
  String get transaction_select_category => 'Select Category';

  @override
  String get transaction_select_category_placeholder => 'Select a category';

  @override
  String get transaction_please_select_category => 'Please select a category';

  @override
  String get transaction_please_enter_amount => 'Please enter an amount';

  @override
  String get transaction_please_enter_valid_amount =>
      'Please enter a valid amount';

  @override
  String transaction_recorded(String amount, String category) {
    return 'Transaction recorded: $amount - $category';
  }

  @override
  String get transaction_no_categories_available =>
      'No categories available. Please create a category first.';

  @override
  String get currency_usd => 'US Dollar';

  @override
  String get currency_eur => 'Euro';

  @override
  String get currency_gbp => 'British Pound';

  @override
  String get currency_jpy => 'Japanese Yen';

  @override
  String get currency_cny => 'Chinese Yuan';

  @override
  String get currency_hkd => 'Hong Kong Dollar';

  @override
  String get currency_sgd => 'Singapore Dollar';

  @override
  String get currency_thb => 'Thai Baht';

  @override
  String get currency_krw => 'South Korean Won';

  @override
  String get currency_aud => 'Australian Dollar';

  @override
  String get currency_cad => 'Canadian Dollar';

  @override
  String get deposit_page_error_loading => 'Error loading categories';

  @override
  String deposit_page_error_message(String error) {
    return 'Error: $error';
  }

  @override
  String get deposit_page_retry => 'Retry';

  @override
  String get deposit_page_no_categories => 'No categories yet';

  @override
  String get deposit_page_add_category_hint =>
      'Tap the + button to add a category';

  @override
  String get add_category_please_select_type => 'Please select a type';

  @override
  String get add_category_please_select_icon => 'Please select an icon';

  @override
  String get add_category_please_enter_name => 'Please enter a category name';

  @override
  String get add_category_please_select_icon_and_type =>
      'Please select an icon and type';

  @override
  String add_category_error(String error) {
    return 'Error: $error';
  }

  @override
  String get delete_category_dialog_title => 'Delete Category';

  @override
  String delete_category_dialog_message(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get delete_category_action => 'Delete';

  @override
  String delete_category_snackbar(String name) {
    return 'Category \"$name\" deleted';
  }

  @override
  String get delete_category_undo => 'UNDO';

  @override
  String delete_category_error(String error) {
    return 'Error deleting category: $error';
  }

  @override
  String slidable_category_edit_coming_soon(String name) {
    return 'Edit \"$name\" - Coming soon';
  }

  @override
  String slidable_category_archive_coming_soon(String name) {
    return 'Archive \"$name\" - Coming soon';
  }

  @override
  String get slidable_category_type_deposit => 'Deposit';

  @override
  String get slidable_category_type_expense => 'Expense';

  @override
  String get analytics_page_coming_soon => 'Coming Soon';

  @override
  String get setting_page_title => 'Settings';

  @override
  String get setting_page_coming_soon => 'Coming Soon';

  @override
  String get setting_page_testing => 'Testing';

  @override
  String get setting_page_font_test => 'Font Test';

  @override
  String get setting_page_font_test_subtitle =>
      'Verify Satoshi font is applied correctly';

  @override
  String get setting_page_app_information => 'App Information';

  @override
  String get setting_page_language => 'Language';

  @override
  String get setting_page_select_language => 'Select Language';

  @override
  String get setting_page_default_currency => 'Default Currency';

  @override
  String get setting_page_select_default_currency => 'Select Default Currency';

  @override
  String get setting_page_app_version => 'App Version';

  @override
  String get setting_page_app_name => 'App Name';

  @override
  String get setting_page_data_management => 'Data Management';

  @override
  String get setting_page_clear_all_data => 'Clear All Data';

  @override
  String get setting_page_clear_all_data_subtitle =>
      'Delete all categories and transactions (app settings will be preserved)';

  @override
  String get setting_page_clear_data_dialog_title => 'Clear All Data';

  @override
  String get setting_page_clear_data_dialog_message =>
      'This will permanently delete all categories and transactions. App settings (language, currency) will be preserved. This action cannot be undone.';

  @override
  String get setting_page_clear_data_confirm => 'Clear';

  @override
  String get setting_page_clear_data_success => 'All data cleared successfully';

  @override
  String get setting_page_clear_data_error => 'Error clearing data';

  @override
  String get setting_page_cleanup_data => 'Clean Up Data';

  @override
  String get setting_page_cleanup_data_subtitle => 'Select what to clean';

  @override
  String get setting_page_cleanup_dialog_title => 'Clean Up Data';

  @override
  String get setting_page_cleanup_categories => 'Categories';

  @override
  String get setting_page_cleanup_transactions => 'Transactions';

  @override
  String get setting_page_cleanup_dialog_message =>
      'Select the data you want to clean. App settings will be preserved.';

  @override
  String get setting_page_cleanup_success => 'Data cleaned successfully';

  @override
  String get setting_page_cleanup_error => 'Error cleaning data';

  @override
  String get setting_page_set_username => 'Set Username';

  @override
  String get setting_page_enter_username_hint => 'Enter your username';

  @override
  String get setting_page_start_date => 'Start Date';

  @override
  String setting_page_start_date_format(String day) {
    return 'Every $day of the month';
  }

  @override
  String get setting_page_select_start_date => 'Select Start Date';

  @override
  String get setting_page_start_date_hint => 'Enter a number between 1 and 31';

  @override
  String get setting_page_recent_activities_count => 'Recent Activities Count';

  @override
  String get setting_page_recent_activities_count_subtitle =>
      'Number of activities to show';

  @override
  String get setting_page_select_recent_activities_count => 'Select Count';

  @override
  String get setting_page_recent_activities_count_hint =>
      'Enter a number between 1 and 100';

  @override
  String get setting_page_emoji_ranges => 'Saving Emoji Ranges';

  @override
  String get setting_page_emoji_ranges_subtitle =>
      'Customize emoji thresholds for savings';

  @override
  String get setting_page_emoji_ranges_hint =>
      'Set the amount thresholds and emojis for different savings levels';

  @override
  String get setting_page_threshold => 'Threshold';

  @override
  String get setting_page_threshold_infinity => '∞ (Infinity)';

  @override
  String get setting_page_emoji => 'Emoji';

  @override
  String get setting_page_emoji_required => 'Emoji is required';

  @override
  String get setting_page_invalid_threshold => 'Invalid threshold';

  @override
  String get setting_page_reset_defaults => 'Reset to Defaults';

  @override
  String get setting_page_timezone => 'Timezone';

  @override
  String get setting_page_tap_to_set_username => 'Tap to set username';

  @override
  String get action_retry => 'Retry';

  @override
  String get transactions_page_title => 'Transactions';

  @override
  String get select_datetime_title => 'Select Date & Time';

  @override
  String get transaction_date => 'Transaction Date';

  @override
  String get transaction_select_date => 'Select date';

  @override
  String get transaction_is_today => 'Is Today';

  @override
  String get login_page_error => 'Email or password is incorrect.';

  @override
  String get login_page_email_hint => 'example@example.com';
}
