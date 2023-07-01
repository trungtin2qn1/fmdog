import 'package:flutter/material.dart';
import 'package:fmdog/account/model/account.dart';
import 'package:fmdog/core/theme/theme.dart';
import 'package:fmdog/ui/account/add_edit_account_screen.dart';
import 'package:fmdog/ui/base_screen.dart';
import 'package:fmdog/utils/custom_text_style.dart';
import 'package:fmdog/viewmodels/manage_account_view_model.dart';

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({super.key});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  late ManageAccountViewModel _manageAccountViewModel;

  bool _isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<ManageAccountViewModel>(
        onModelReady: (model) {
          _manageAccountViewModel = model;
          _manageAccountViewModel.fetchAccounts();
        },
        builder: (context, model, child) => _scaffold());
  }

  Widget _scaffold() {
    return Scaffold(
      backgroundColor: context.appHomeScreenBgColor,
      appBar: AppBar(title: const Text("Accounts"), actions: _appBarActions()),
      body: _listView(),
      floatingActionButton: _fab(),
    );
  }

  List<Widget> _appBarActions() {
    List<Widget> list = [];
    if (!_isEditMode) {
      var editWidget = InkWell(
        onTap: () {
          setState(() {
            _isEditMode = true;
          });
        },
        child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: const Icon(Icons.edit_outlined)),
      );
      list.add(editWidget);
    } else {
      var doneWidget = InkWell(
        onTap: () {
          setState(() {
            _isEditMode = false;
          });
        },
        child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: const Icon(Icons.done)),
      );
      list.add(doneWidget);
    }
    return list;
  }

  Widget _listView() {
    return ListView.builder(
        padding:
            const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 100),
        itemCount: _manageAccountViewModel.accounts.length,
        itemBuilder: (context, index) {
          return _row(_manageAccountViewModel.accounts[index]);
        });
  }

  Widget _row(Account account) {
    return InkWell(
      onTap: _isEditMode
          ? null
          : () => _openAddEditAccountScreen(account: account),
      child: Container(
        padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
        child: Column(
          children: [
            Row(
              children: [
                Text(account.emoji,
                    style: CustomTextStyle.emojiStyle(
                        context: context, fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(account.isActive ? "Show" : "Hidden",
                          style: TextStyle(
                              fontSize: 12,
                              color: context.appPrimaryColor.withOpacity(0.6))),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 12),
                if (_isEditMode)
                  _switchWidget(account, (value) {
                    setState(() {
                      account.isActive = value;
                    });
                  })
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 0, thickness: 0)
          ],
        ),
      ),
    );
  }

  Widget _switchWidget(Account account, ValueChanged<bool> callback) {
    // var widget = Container(
    //   height: 34.0,
    //   width: 42.0,
    //   child: FittedBox(
    //       fit: BoxFit.contain,
    //       child: CupertinoSwitch(
    //           value: category.isActive,
    //           activeColor: context.appPrimaryColor.withOpacity(0.8),
    //           onChanged: callback)),
    // );

    var widget = Switch(
        value: account.isActive,
        activeColor: context.appPrimaryColor.withOpacity(0.8),
        onChanged: callback);

    return widget;
  }

  void _openAddEditAccountScreen({Account? account}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditAccountScreen(
              account: account,
              addOrEditPerformed: () => _manageAccountViewModel.fetchAccounts(),
            )));
  }

  Widget _fab() {
    return FloatingActionButton(
      onPressed: () => _openAddEditAccountScreen(),
      tooltip: 'Add Account',
      backgroundColor: context.appSecondaryColor,
      child: Icon(
        Icons.add,
        size: 32,
        color: context.appPrimaryColor,
      ),
    );
  }
}
