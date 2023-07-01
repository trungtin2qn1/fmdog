import 'package:fmdog/settings/currency/currency_utils.dart';
import 'package:fmdog/settings/settings_service.dart';
import 'package:fmdog/utils/currency_helper.dart';
import 'package:fmdog/viewmodels/base_view_model.dart';

class CurrencyViewModel extends BaseViewModel {
  CurrencyViewModel({required this.settingsService});

  final SettingsService settingsService;

  List<CountryLocale> countries = [];

  void setLocales() {
    countries = getLocales();
  }

  void selectedCountryLocale(CountryLocale countryLocale) {
    CurrencyHelper.currentAppLevelLocale = countryLocale.locale.languageCode;
    settingsService.setLanguage(countryLocale.locale);
    notifyListeners();
  }
}
