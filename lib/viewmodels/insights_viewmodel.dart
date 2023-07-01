import 'dart:collection';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:fmdog/account/repository/account_repository.dart';
import 'package:fmdog/category/repository/category_repository.dart';
import 'package:fmdog/globals.dart';
import 'package:fmdog/transactions/models/transaction.dart';
import 'package:fmdog/transactions/repository/transaction_repository.dart';
import 'package:fmdog/ui/insights/insights_screen.dart';
import 'package:fmdog/viewmodels/base_view_model.dart';
import 'package:fmdog/utils/transaction_extension.dart';
import 'package:fmdog/utils/enum/transaction_type.dart';

class InsightsViewModel extends BaseViewModel {
  InsightsViewModel(
      {required this.transactionRepository,
      required this.accountRepository,
      required this.categoryRepository});
  final TransactionRepository transactionRepository;
  final AccountRepository accountRepository;
  final CategoryRepository categoryRepository;

  ValueListenable<Box<Transaction>>? _valueListenable;

  List<ChartSampleData> chartData = [];
  List<ChartCategoryData> chartCategoryData = [];
  Map<String, ChartCategoryData> hashChartCategoryData =
      HashMap<String, ChartCategoryData>();

  void init() {
    setTransactions();
    listenToTransactionBox();
  }

  void setTransactions() async {
    Map<DateTime, List<Transaction>> transactionList = {};
    chartData = [];
    chartCategoryData = [];
    Map<String, ChartCategoryData> hashChartCategoryData =
        HashMap<String, ChartCategoryData>();
    double totalExpense = 0;
    var hashMap = HashMap();

    transactionList =
        await transactionRepository.getGroupedTransactions(true, currTimeline);
    int endDay = currTimeline.endTime.day;
    for (int i = 1; i <= endDay; i++) {
      var dateTime = DateTime(
          currTimeline.startTime.year, currTimeline.startTime.month, i);
      chartData.add(ChartSampleData(
          x: dateTime, y: transactionList[dateTime]?.totalExpense ?? 0));

      double tempTotalExpense = transactionList[dateTime]?.totalExpense ?? 0;

      if (tempTotalExpense != 0) {
        totalExpense += tempTotalExpense;
        List<Transaction>? list = transactionList[dateTime];
        for (int j = 0; j < list!.length; j++) {
          if (list[j].type != TransactionType.expense) {
            continue;
          }

          if (hashMap[list[j].categoryId] == null) {
            var category = await categoryRepository
                .fetchCategoryFromId(list[j].categoryId);
            hashMap[list[j].categoryId] = category?.name;
          }
          String name = hashMap[list[j].categoryId];

          if (hashChartCategoryData[name] == null) {
            hashChartCategoryData[name] = ChartCategoryData(x: name, y: 0);
          }
          hashChartCategoryData[name]?.y += list[j].amount;
        }
      }
    }

    hashChartCategoryData.forEach((key, value) {
      chartCategoryData.add(
        ChartCategoryData(
            x: key, y: roundDouble(value.y / totalExpense * 100, 2)),
      );
    });

    notifyListeners();
  }

  void previousDate() {
    currTimeline = currTimeline.previousMonth();
    setTransactions();
  }

  void nextDate() {
    currTimeline = currTimeline.nextMonth();
    setTransactions();
  }

  void listenToTransactionBox() {
    _valueListenable = transactionRepository.getBox().listenable();
    _valueListenable?.addListener(transactionListener);
  }

  void removeBoxListener() {
    _valueListenable?.removeListener(transactionListener);
  }

  void transactionListener() {
    setTransactions();
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }
}
