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
  String get login_page_email => 'Email';

  @override
  String get login_page_password => 'Password';

  @override
  String get login_page_submit => 'Login';

  @override
  String get home_page_title => 'Home';

  @override
  String get home_page_deposits => 'Deposits';

  @override
  String get home_page_expenses => 'Expenses';

  @override
  String get home_page_total_savings => 'Total Savings';

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
}
