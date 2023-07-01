import 'package:flutter/material.dart';
import 'package:fmdog/core/theme/theme.dart';
import 'package:fmdog/settings/currency/currency_utils.dart';
import 'package:fmdog/ui/base_screen.dart';
import 'package:fmdog/utils/currency_helper.dart';
import 'package:fmdog/viewmodels/currency_viewmodel.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key, required this.callback});
  final VoidCallback callback;

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  late CurrencyViewModel _currencyViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CurrencyViewModel>(
      onModelReady: (model) {
        _currencyViewModel = model;
        _currencyViewModel.setLocales();
      },
      builder: (context, model, child) => _scaffold(),
    );
  }

  Widget _scaffold() {
    return Scaffold(
      backgroundColor: context.appHomeScreenBgColor,
      appBar: AppBar(
        title: const Text("Currency"),
      ),
      body: _listView(),
    );
  }

  Widget _listView() {
    return Container(
      color: context.appHomeScreenBgColor,
      child: ListView.builder(
        padding:
            const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 100),
        itemCount: _currencyViewModel.countries.length,
        itemBuilder: (context, index) {
          return _row(index);
        },
      ),
    );
  }

  Widget _row(int index) {
    CountryLocale countryLocale = _currencyViewModel.countries[index];
    bool isSelected =
        CurrencyHelper.getLocaleName() == countryLocale.locale.languageCode;
    return InkWell(
      onTap: () {
        _currencyViewModel.selectedCountryLocale(countryLocale);
        widget.callback();
      },
      child: Container(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
        color: isSelected ? context.appPrimaryColor.withOpacity(0.05) : null,
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(countryLocale.name),
                    Text(
                      CurrencyHelper.getCurrencyName(
                        locale: countryLocale.locale,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  CurrencyHelper.getCurrencySymbol(
                    locale: countryLocale.locale,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 0, thickness: 0)
          ],
        ),
      ),
    );
  }
}
