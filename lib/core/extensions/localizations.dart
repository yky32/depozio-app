import 'package:flutter/material.dart';
import 'package:depozio/core/localization/app_localizations.dart';

extension Localizations on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
