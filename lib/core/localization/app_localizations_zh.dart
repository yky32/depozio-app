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
}
