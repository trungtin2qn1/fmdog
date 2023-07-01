import 'package:flutter/material.dart';
import 'package:fmdog/transactions/models/transaction.dart';
import 'package:fmdog/utils/currency_helper.dart';
import 'package:fmdog/utils/enum/filter_budget.dart';
import 'package:fmdog/utils/enum/transaction_type.dart';
import 'package:fmdog/utils/list_utils.dart';
import 'package:fmdog/utils/time_extension.dart';

extension TotalAmountOnTransaction on Iterable<Transaction> {
  List<Transaction> get expenseList =>
      where((element) => element.type == TransactionType.expense).toList();

  List<Transaction> get incomeList =>
      where((element) => element.type == TransactionType.income).toList();

  String get balance =>
      CurrencyHelper.formattedCurrency(totalIncome - totalExpense);

  List<Transaction> isFilterTimeBetween(DateTimeRange range) {
    return where((element) => element.time.isAfterBeforeTime(range)).toList();
  }

  double get filterTotal => fold<double>(0, (previousValue, element) {
        if (element.type == TransactionType.expense) {
          return previousValue - element.amount;
        } else {
          return previousValue + element.amount;
        }
      });

  double get totalExpense =>
      where((element) => element.type == TransactionType.expense)
          .map((e) => e.amount)
          .fold<double>(0, (previousValue, element) => previousValue + element);

  double get totalIncome =>
      where((element) => element.type == TransactionType.income)
          .map((e) => e.amount)
          .fold<double>(0, (previousValue, element) => previousValue + element);

  double get total => map((e) => e.amount)
      .fold<double>(0, (previousValue, element) => previousValue + element);

  String get totalWithCurrencySymbol => CurrencyHelper.formattedCurrency(total);

  double get thisMonthExpense =>
      where((element) => element.type == TransactionType.expense)
          .where((element) => element.time.month == DateTime.now().month)
          .map((e) => e.amount)
          .fold<double>(0, (previousValue, element) => previousValue + element);

  double get thisMonthIncome =>
      where((element) => element.type == TransactionType.income)
          .where((element) => element.time.month == DateTime.now().month)
          .map((e) => e.amount)
          .fold<double>(0, (previousValue, element) => previousValue + element);

  Map<String, List<Transaction>> groupByTime(FilterBudget filterBudget) {
    return groupBy(
        this, (Transaction element) => element.time.formatted(filterBudget));
  }

  Map<DateTime, List<Transaction>> groupByDateTime(FilterBudget filterBudget) {
    return groupBy(this,
        (Transaction element) => element.time.formattedDateTime(filterBudget));
  }
}
