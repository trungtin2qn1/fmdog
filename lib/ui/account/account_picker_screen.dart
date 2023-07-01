import 'package:flutter/material.dart';
import 'package:fmdog/account/model/account.dart';
import 'package:fmdog/utils/custom_text_style.dart';
import 'package:fmdog/core/theme/theme.dart';

class AccountPickerScreen extends StatefulWidget {
  final List<Account> accountList;
  final Function(Account) onAccountSelected;
  const AccountPickerScreen(
      {Key? key, required this.accountList, required this.onAccountSelected})
      : super(key: key);

  @override
  State<AccountPickerScreen> createState() => _AccountPickerScreenState();
}

class _AccountPickerScreenState extends State<AccountPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: context.appHomeScreenBgColor,
        padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.3,
            maxHeight: MediaQuery.of(context).size.height * 0.7),
        child: SingleChildScrollView(
            child: Column(children: [
          const Text("Accounts",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ..._rows()
        ])));
  }

  List<Widget> _rows() {
    List<Widget> rows = [];
    List<Widget> currentTiles = [];
    for (var element in widget.accountList) {
      var tile = _getTile(element);
      currentTiles.add(tile);
      if (currentTiles.length % 3 == 0) {
        rows.add(_getRow(currentTiles));
        currentTiles = [];
      }
    }
    if (currentTiles.isNotEmpty) {
      rows.add(_getRow(currentTiles));
    }
    return rows;
  }

  Widget _getTile(Account account) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          widget.onAccountSelected(account);
          Navigator.of(context).pop();
        },
        child: Container(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
            padding: const EdgeInsets.only(top: 14, bottom: 14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(account.emoji,
                  style: CustomTextStyle.emojiStyle(
                      context: context, fontSize: 24)),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  account.name,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ])),
      ),
    );
  }

  Widget _getRow(List<Widget> widgets) {
    if (widgets.length % 3 != 0) {
      widgets.add(const Spacer());
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: widgets);
  }
}
