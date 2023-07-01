import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fmdog/account/repository/account_repository.dart';
import 'package:fmdog/category/repository/category_repository.dart';
import 'package:fmdog/transactions/models/transaction.dart';
import 'package:fmdog/transactions/repository/transaction_repository.dart';
import 'package:fmdog/utils/enum/transaction_type.dart';
import 'package:fmdog/viewmodels/base_view_model.dart';
import 'package:fmdog/globals.dart';

class HomeScreenViewModel extends BaseViewModel {
  HomeScreenViewModel(
      {required this.transactionRepository,
      required this.accountRepository,
      required this.categoryRepository});
  final TransactionRepository transactionRepository;
  final AccountRepository accountRepository;
  final CategoryRepository categoryRepository;

  Map<DateTime, List<Transaction>> transactionList = {};
  ValueListenable<Box<Transaction>>? _valueListenable;
  String totalExpense = "0";
  String totalIncome = "0";

  void init() {
    setTransactions();
    listenToTransactionBox();
  }

  void setTransactions() async {
    transactionList =
        await transactionRepository.getGroupedTransactions(true, currTimeline);
    totalExpense = await transactionRepository.totalTransactions(
        TransactionType.expense, currTimeline);
    totalIncome = await transactionRepository.totalTransactions(
        TransactionType.income, currTimeline);
    notifyListeners();
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
}
