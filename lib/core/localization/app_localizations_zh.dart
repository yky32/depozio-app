// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get action_cancel => '取消';

  @override
  String get action_confirm => '確認';

  @override
  String get login_page_email => '電子郵件';

  @override
  String get login_page_password => '密碼';

  @override
  String get login_page_submit => '登入';

  @override
  String get home_page_title => '首頁';

  @override
  String get home_page_deposits => '存款';

  @override
  String get home_page_expenses => '支出';

  @override
  String get home_page_total_savings => '總儲蓄';

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
  String get transaction_no_categories_available => '沒有可用的類別。請先創建一個類別。';

  @override
  String get currency_usd => '美元';

  @override
  String get currency_eur => '歐元';

  @override
  String get currency_gbp => '英鎊';

  @override
  String get currency_jpy => '日元';

  @override
  String get currency_cny => '人民幣';

  @override
  String get currency_hkd => '港幣';

  @override
  String get currency_sgd => '新加坡元';

  @override
  String get currency_thb => '泰銖';

  @override
  String get currency_krw => '韓元';

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
  String get setting_page_app_version => '应用版本';

  @override
  String get setting_page_app_name => '应用名称';

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
  String get login_page_email => '電子郵件';

  @override
  String get login_page_password => '密碼';

  @override
  String get login_page_submit => '登入';

  @override
  String get home_page_title => '首頁';

  @override
  String get home_page_deposits => '存款';

  @override
  String get home_page_expenses => '支出';

  @override
  String get home_page_total_savings => '總儲蓄';

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
  String get setting_page_app_version => '應用程式版本';

  @override
  String get setting_page_app_name => '應用程式名稱';

  @override
  String get login_page_error => '電子郵件或密碼不正確。';

  @override
  String get login_page_email_hint => 'example@example.com';
}
