import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fmdog/transactions/models/transaction.dart';
import 'package:fmdog/ui/add_transaction/add_transaction_page.dart';
import 'package:fmdog/ui/base_screen.dart';
import 'package:fmdog/ui/home/transaction_card_widget.dart';
import 'package:fmdog/ui/time_range_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:fmdog/ui/soft_hard_update/app_update_bottom_sheet.dart';
import 'package:fmdog/utils/broadcast/broadcast_channels.dart';
import 'package:fmdog/utils/broadcast/broadcast_receiver.dart';
import 'package:fmdog/utils/utils.dart';
import 'package:fmdog/utils/validation_utils.dart';
import 'package:fmdog/utils/custom_text_style.dart';
import 'package:fmdog/core/theme/theme.dart';
import 'package:fmdog/viewmodels/home_screen_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeScreenViewModel _homeScreenViewModel;

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    setBroadcastListener();
  }

  void setBroadcastListener() {
    _streamSubscription =
        BroadcastReceiver.broadcastController.stream.listen((event) {
      if (ValidationUtils.isValidString(event) &&
          (event == BroadcastChannels.refreshAppUpdateChecker ||
              event == BroadcastChannels.updateTimeRange)) {
                _homeScreenViewModel.setTransactions();
              }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen<HomeScreenViewModel>(onModelReady: (model) {
      _homeScreenViewModel = model;
      _homeScreenViewModel.init();
    }, builder: (context, model, child) {
      return _content();
    });
  }

  Widget _content() {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: context.appHomeScreenBgColor,
          elevation: 0),
      body: SafeArea(
        child: _body(),
      ),
      floatingActionButton:
          _fab(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      color: context.appHomeScreenBgColor,
      child: Column(
        children: [
          const TimeRangeScreen(),
          const SizedBox(height: 12),
          _listWidget()
        ],
      ),
    );
  }

  Widget _listWidget() {
    return Expanded(
        child: ListView.builder(
      padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 100),
      itemCount: _homeScreenViewModel.transactionList.length + 1,
      itemBuilder: (context, index) {
        var maps = _homeScreenViewModel.transactionList;
        if (index == 0) {
          return _topWidgetV2();
        }
        final transactions = maps.values.toList()[index - 1];
        transactions.sort((a, b) => b.time.compareTo(a.time));
        return TransactionCardWidget(
            dateTime: maps.keys.toList()[index - 1],
            transactions: transactions,
            onTap: (transaction) {
              _openTransactionPage(transaction: transaction);
            });
        // if (index % 4 == 0) {
        //   return TransactionRowHeaderWidget();
        // }
        // return TransactionRowWidget(transaction: Utils.getDummyTransaction(), accountLocalDataSource: locator.get(), categoryLocalDataSource: locator.get());
      },
    ));
  }

  FloatingActionButton _fab() {
    return FloatingActionButton(
      onPressed: () {
        _openTransactionPage();
      },
      tooltip: 'Add Transaction',
      backgroundColor: context.appSecondaryColor,
      child: Icon(
        Icons.add,
        size: 32,
        color: context.appPrimaryColor,
      ),
    );
  }

  void _openTransactionPage({Transaction? transaction}) async {
    showBarModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionPage(
        transaction: transaction,
      ),
    );
  }

  void showAppUpdateBottomSheet({bool canDismiss = true}) {
    showBarModalBottomSheet(
        enableDrag: canDismiss,
        isDismissible: canDismiss,
        context: context,
        builder: (builder) {
          return AppUpdateBottomSheet(
              onUpdateClick: () {
                Utils.openPlayOrAppStore();
              },
              isDismissible: canDismiss);
        });
  }

  Widget _topWidgetV2() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: context.appBgColor),
      child: Column(
        children: [
          _buildExpenseIncomeWidget(
              emoji: "💸",
              header: "Expenses",
              amount: _homeScreenViewModel.totalExpense),
          const SizedBox(height: 16),
          _buildExpenseIncomeWidget(
              emoji: "💰",
              header: "Income",
              amount: _homeScreenViewModel.totalIncome)
        ],
      ),
    );
  }

  Widget _buildExpenseIncomeWidget(
      {required String emoji, required String header, required String amount}) {
    var textSpan = TextSpan(children: [
      TextSpan(
          text: emoji,
          style: CustomTextStyle.emojiStyle(context: context, fontSize: 18)),
      TextSpan(
          text: " $header",
          style: TextStyle(
              fontSize: 14, color: context.appPrimaryColor.withOpacity(0.6)))
    ]);
    var amountWidget = Text(
      amount,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    );
    return Row(children: [
      RichText(text: textSpan),
      const Spacer(),
      const SizedBox(width: 12),
      amountWidget
    ]);
  }

  @override
  void dispose() {
    _homeScreenViewModel.removeBoxListener();
    _streamSubscription?.cancel();
    super.dispose();
  }
}
