// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

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

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get action_cancel => '取消';

  @override
  String get action_confirm => '确认';

  @override
  String get action_save => '保存';

  @override
  String get login_page_email => '电子邮件';

  @override
  String get login_page_password => '密码';

  @override
  String get login_page_submit => '登录';

  @override
  String get home_page_title => '首页';

  @override
  String home_page_greeting(String username) {
    return '你好，$username';
  }

  @override
  String get home_page_deposits => '存款';

  @override
  String get home_page_expenses => '支出';

  @override
  String get home_page_total_savings => '总储蓄';

  @override
  String get home_page_total_savings_currency_reminder => '汇率可能影响计算结果';

  @override
  String get home_page_savings_goal => '储蓄目标';

  @override
  String get home_page_monthly_savings => '每月储蓄';

  @override
  String get home_page_recent_activity => '最近活动';

  @override
  String get home_page_no_activity => '无最近活动';

  @override
  String get deposit_page_title => '存款';

  @override
  String get deposit_page_add_category => '新增类别';

  @override
  String get add_category_bottom_sheet_title => '新增类别';

  @override
  String get add_category_name => '名称';

  @override
  String get add_category_name_hint => '输入类别名称';

  @override
  String get add_category_icon => '图标';

  @override
  String get add_category_type => '类型';

  @override
  String get add_category_type_deposits => '存款';

  @override
  String get add_category_type_expenses => '支出';

  @override
  String get transaction_record_title => '记录交易';

  @override
  String get transaction_amount => '金额';

  @override
  String get transaction_category => '类别';

  @override
  String get transaction_description => '描述';

  @override
  String get transaction_description_placeholder => '添加备注（选填）';

  @override
  String get transaction_select_currency => '选择货币';

  @override
  String get transaction_select_category => '选择类别';

  @override
  String get transaction_select_category_placeholder => '选择一个类别';

  @override
  String get transaction_please_select_category => '请选择一个类别';

  @override
  String get transaction_please_enter_amount => '请输入金额';

  @override
  String get transaction_please_enter_valid_amount => '请输入有效的金额';

  @override
  String transaction_recorded(String amount, String category) {
    return '交易已记录：$amount - $category';
  }

  @override
  String get transaction_no_categories_available => '没有可用的类别。请先创建一个类别。';

  @override
  String get currency_usd => '美元';

  @override
  String get currency_eur => '欧元';

  @override
  String get currency_gbp => '英镑';

  @override
  String get currency_jpy => '日元';

  @override
  String get currency_cny => '人民币';

  @override
  String get currency_hkd => '港币';

  @override
  String get currency_sgd => '新加坡元';

  @override
  String get currency_thb => '泰铢';

  @override
  String get currency_krw => '韩元';

  @override
  String get currency_aud => '澳元';

  @override
  String get currency_cad => '加元';

  @override
  String get deposit_page_error_loading => '加载类别时出错';

  @override
  String deposit_page_error_message(String error) {
    return '错误：$error';
  }

  @override
  String get deposit_page_retry => '重试';

  @override
  String get deposit_page_no_categories => '还没有类别';

  @override
  String get deposit_page_add_category_hint => '点击 + 按钮添加类别';

  @override
  String get add_category_please_select_type => '请选择类型';

  @override
  String get add_category_please_select_icon => '请选择图标';

  @override
  String get add_category_please_enter_name => '请输入类别名称';

  @override
  String get add_category_please_select_icon_and_type => '请选择图标和类型';

  @override
  String add_category_error(String error) {
    return '错误：$error';
  }

  @override
  String get delete_category_dialog_title => '删除类别';

  @override
  String delete_category_dialog_message(String name) {
    return '您确定要删除 \"$name\" 吗？';
  }

  @override
  String get delete_category_action => '删除';

  @override
  String delete_category_snackbar(String name) {
    return '类别 \"$name\" 已删除';
  }

  @override
  String get delete_category_undo => '撤销';

  @override
  String delete_category_error(String error) {
    return '删除类别时出错：$error';
  }

  @override
  String slidable_category_edit_coming_soon(String name) {
    return '编辑 \"$name\" - 即将推出';
  }

  @override
  String slidable_category_archive_coming_soon(String name) {
    return '归档 \"$name\" - 即将推出';
  }

  @override
  String get slidable_category_type_deposit => '存款';

  @override
  String get slidable_category_type_expense => '支出';

  @override
  String get analytics_page_coming_soon => '即将推出';

  @override
  String get setting_page_title => '设置';

  @override
  String get setting_page_coming_soon => '即将推出';

  @override
  String get setting_page_testing => '测试';

  @override
  String get setting_page_font_test => '字体测试';

  @override
  String get setting_page_font_test_subtitle => '验证 Satoshi 字体是否正确应用';

  @override
  String get setting_page_app_information => '应用信息';

  @override
  String get setting_page_language => '语言';

  @override
  String get setting_page_select_language => '选择语言';

  @override
  String get setting_page_default_currency => '默认货币';

  @override
  String get setting_page_select_default_currency => '选择默认货币';

  @override
  String get setting_page_app_version => '应用版本';

  @override
  String get setting_page_app_name => '应用名称';

  @override
  String get setting_page_data_management => '数据管理';

  @override
  String get setting_page_clear_all_data => '清除所有数据';

  @override
  String get setting_page_clear_all_data_subtitle => '删除所有类别和交易记录（应用设置将保留）';

  @override
  String get setting_page_clear_data_dialog_title => '清除所有数据';

  @override
  String get setting_page_clear_data_dialog_message =>
      '这将永久删除所有类别和交易记录。应用设置（语言、货币）将保留。此操作无法撤销。';

  @override
  String get setting_page_clear_data_confirm => '清除';

  @override
  String get setting_page_clear_data_success => '所有数据已成功清除';

  @override
  String get setting_page_clear_data_error => '清除数据时发生错误';

  @override
  String get setting_page_cleanup_data => '清理数据';

  @override
  String get setting_page_cleanup_data_subtitle => '选择要清理的内容';

  @override
  String get setting_page_cleanup_dialog_title => '清理数据';

  @override
  String get setting_page_cleanup_categories => '类别';

  @override
  String get setting_page_cleanup_transactions => '交易记录';

  @override
  String get setting_page_cleanup_dialog_message => '选择要清理的数据。应用设置将保留。';

  @override
  String get setting_page_cleanup_success => '数据清理成功';

  @override
  String get setting_page_cleanup_error => '清理数据时发生错误';

  @override
  String get setting_page_set_username => '设置用户名';

  @override
  String get setting_page_enter_username_hint => '请输入您的用户名';

  @override
  String get setting_page_start_date => '开始日期';

  @override
  String setting_page_start_date_format(String day) {
    return '每月$day';
  }

  @override
  String get setting_page_select_start_date => '选择开始日期';

  @override
  String get setting_page_start_date_hint => '请输入1到31之间的数字';

  @override
  String get setting_page_emoji_ranges => '储蓄表情范围';

  @override
  String get setting_page_emoji_ranges_subtitle => '自定义储蓄表情阈值';

  @override
  String get setting_page_emoji_ranges_hint => '为不同的储蓄水平设置金额阈值和表情';

  @override
  String get setting_page_threshold => '阈值';

  @override
  String get setting_page_threshold_infinity => '∞ (无限)';

  @override
  String get setting_page_emoji => '表情';

  @override
  String get setting_page_emoji_required => '表情是必需的';

  @override
  String get setting_page_invalid_threshold => '无效的阈值';

  @override
  String get setting_page_reset_defaults => '重置为默认值';

  @override
  String get setting_page_timezone => '时区';

  @override
  String get setting_page_tap_to_set_username => '点击设置用户名';

  @override
  String get action_retry => '重试';

  @override
  String get transactions_page_title => '交易记录';

  @override
  String get select_datetime_title => '选择日期和时间';

  @override
  String get transaction_date => '交易日期';

  @override
  String get transaction_select_date => '选择日期';

  @override
  String get transaction_is_today => '今天';

  @override
  String get login_page_error => '电子邮件或密码不正确。';

  @override
  String get login_page_email_hint => 'example@example.com';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get action_cancel => '取消';

  @override
  String get action_confirm => '確認';

  @override
  String get action_save => '儲存';

  @override
  String get login_page_email => '電子郵件';

  @override
  String get login_page_password => '密碼';

  @override
  String get login_page_submit => '登入';

  @override
  String get home_page_title => '首頁';

  @override
  String home_page_greeting(String username) {
    return '你好，$username';
  }

  @override
  String get home_page_deposits => '存款';

  @override
  String get home_page_expenses => '支出';

  @override
  String get home_page_total_savings => '總儲蓄';

  @override
  String get home_page_total_savings_currency_reminder => '匯率可能影響計算結果';

  @override
  String get home_page_savings_goal => '儲蓄目標';

  @override
  String get home_page_monthly_savings => '每月儲蓄';

  @override
  String get home_page_recent_activity => '最近活動';

  @override
  String get home_page_no_activity => '無最近活動';

  @override
  String get deposit_page_title => '存款';

  @override
  String get deposit_page_add_category => '新增類別';

  @override
  String get add_category_bottom_sheet_title => '新增類別';

  @override
  String get add_category_name => '名稱';

  @override
  String get add_category_name_hint => '輸入類別名稱';

  @override
  String get add_category_icon => '圖標';

  @override
  String get add_category_type => '類型';

  @override
  String get add_category_type_deposits => '存款';

  @override
  String get add_category_type_expenses => '支出';

  @override
  String get transaction_record_title => '記錄交易';

  @override
  String get transaction_amount => '金額';

  @override
  String get transaction_category => '類別';

  @override
  String get transaction_description => '描述';

  @override
  String get transaction_description_placeholder => '新增備註（選填）';

  @override
  String get transaction_select_currency => '選擇貨幣';

  @override
  String get transaction_select_category => '選擇類別';

  @override
  String get transaction_select_category_placeholder => '選擇一個類別';

  @override
  String get transaction_please_select_category => '請選擇一個類別';

  @override
  String get transaction_please_enter_amount => '請輸入金額';

  @override
  String get transaction_please_enter_valid_amount => '請輸入有效的金額';

  @override
  String transaction_recorded(String amount, String category) {
    return '交易已記錄：$amount - $category';
  }

  @override
  String get transaction_no_categories_available => '沒有可用的類別。請先建立一個類別。';

  @override
  String get currency_usd => '美元';

  @override
  String get currency_eur => '歐元';

  @override
  String get currency_gbp => '英鎊';

  @override
  String get currency_jpy => '日圓';

  @override
  String get currency_cny => '人民幣';

  @override
  String get currency_hkd => '港幣';

  @override
  String get currency_sgd => '新加坡幣';

  @override
  String get currency_thb => '泰銖';

  @override
  String get currency_krw => '韓元';

  @override
  String get currency_aud => '澳幣';

  @override
  String get currency_cad => '加幣';

  @override
  String get deposit_page_error_loading => '載入類別時發生錯誤';

  @override
  String deposit_page_error_message(String error) {
    return '錯誤：$error';
  }

  @override
  String get deposit_page_retry => '重試';

  @override
  String get deposit_page_no_categories => '尚無類別';

  @override
  String get deposit_page_add_category_hint => '點擊 + 按鈕新增類別';

  @override
  String get add_category_please_select_type => '請選擇類型';

  @override
  String get add_category_please_select_icon => '請選擇圖標';

  @override
  String get add_category_please_enter_name => '請輸入類別名稱';

  @override
  String get add_category_please_select_icon_and_type => '請選擇圖標和類型';

  @override
  String add_category_error(String error) {
    return '錯誤：$error';
  }

  @override
  String get delete_category_dialog_title => '刪除類別';

  @override
  String delete_category_dialog_message(String name) {
    return '您確定要刪除 \"$name\" 嗎？';
  }

  @override
  String get delete_category_action => '刪除';

  @override
  String delete_category_snackbar(String name) {
    return '類別 \"$name\" 已刪除';
  }

  @override
  String get delete_category_undo => '復原';

  @override
  String delete_category_error(String error) {
    return '刪除類別時發生錯誤：$error';
  }

  @override
  String slidable_category_edit_coming_soon(String name) {
    return '編輯 \"$name\" - 即將推出';
  }

  @override
  String slidable_category_archive_coming_soon(String name) {
    return '封存 \"$name\" - 即將推出';
  }

  @override
  String get slidable_category_type_deposit => '存款';

  @override
  String get slidable_category_type_expense => '支出';

  @override
  String get analytics_page_coming_soon => '即將推出';

  @override
  String get setting_page_title => '設定';

  @override
  String get setting_page_coming_soon => '即將推出';

  @override
  String get setting_page_testing => '測試';

  @override
  String get setting_page_font_test => '字體測試';

  @override
  String get setting_page_font_test_subtitle => '驗證 Satoshi 字體是否正確套用';

  @override
  String get setting_page_app_information => '應用程式資訊';

  @override
  String get setting_page_language => '語言';

  @override
  String get setting_page_select_language => '選擇語言';

  @override
  String get setting_page_default_currency => '預設貨幣';

  @override
  String get setting_page_select_default_currency => '選擇預設貨幣';

  @override
  String get setting_page_app_version => '應用程式版本';

  @override
  String get setting_page_app_name => '應用程式名稱';

  @override
  String get setting_page_data_management => '資料管理';

  @override
  String get setting_page_clear_all_data => '清除所有資料';

  @override
  String get setting_page_clear_all_data_subtitle => '刪除所有類別和交易記錄（應用程式設定將保留）';

  @override
  String get setting_page_clear_data_dialog_title => '清除所有資料';

  @override
  String get setting_page_clear_data_dialog_message =>
      '這將永久刪除所有類別和交易記錄。應用程式設定（語言、貨幣）將保留。此操作無法復原。';

  @override
  String get setting_page_clear_data_confirm => '清除';

  @override
  String get setting_page_clear_data_success => '所有資料已成功清除';

  @override
  String get setting_page_clear_data_error => '清除資料時發生錯誤';

  @override
  String get setting_page_cleanup_data => '清理資料';

  @override
  String get setting_page_cleanup_data_subtitle => '選擇要清理的內容';

  @override
  String get setting_page_cleanup_dialog_title => '清理資料';

  @override
  String get setting_page_cleanup_categories => '類別';

  @override
  String get setting_page_cleanup_transactions => '交易記錄';

  @override
  String get setting_page_cleanup_dialog_message => '選擇要清理的資料。應用程式設定將保留。';

  @override
  String get setting_page_cleanup_success => '資料清理成功';

  @override
  String get setting_page_cleanup_error => '清理資料時發生錯誤';

  @override
  String get setting_page_set_username => '設定使用者名稱';

  @override
  String get setting_page_enter_username_hint => '請輸入您的使用者名稱';

  @override
  String get setting_page_start_date => '開始日期';

  @override
  String setting_page_start_date_format(String day) {
    return '每月$day';
  }

  @override
  String get setting_page_select_start_date => '選擇開始日期';

  @override
  String get setting_page_start_date_hint => '請輸入1到31之間的數字';

  @override
  String get setting_page_emoji_ranges => '儲蓄表情範圍';

  @override
  String get setting_page_emoji_ranges_subtitle => '自訂儲蓄表情閾值';

  @override
  String get setting_page_emoji_ranges_hint => '為不同的儲蓄水平設置金額閾值和表情';

  @override
  String get setting_page_threshold => '閾值';

  @override
  String get setting_page_threshold_infinity => '∞ (無限)';

  @override
  String get setting_page_emoji => '表情';

  @override
  String get setting_page_emoji_required => '表情是必需的';

  @override
  String get setting_page_invalid_threshold => '無效的閾值';

  @override
  String get setting_page_reset_defaults => '重置為預設值';

  @override
  String get setting_page_timezone => '時區';

  @override
  String get setting_page_tap_to_set_username => '點擊設定使用者名稱';

  @override
  String get action_retry => '重試';

  @override
  String get transactions_page_title => '交易記錄';

  @override
  String get select_datetime_title => '選擇日期和時間';

  @override
  String get transaction_date => '交易日期';

  @override
  String get transaction_select_date => '選擇日期';

  @override
  String get transaction_is_today => '今天';

  @override
  String get login_page_error => '電子郵件或密碼不正確。';

  @override
  String get login_page_email_hint => 'example@example.com';
}
