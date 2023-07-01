import 'package:fmdog/globals.dart';
import 'package:fmdog/viewmodels/base_view_model.dart';
import 'package:fmdog/transactions/models/transaction.dart';
import 'package:fmdog/transactions/repository/transaction_repository.dart';
import 'package:fmdog/utils/enum/transaction_type.dart';

class TimeRangeViewModel extends BaseViewModel {
  TimeRangeViewModel(
      {required this.transactionRepository});
  final TransactionRepository transactionRepository;

  Map<DateTime, List<Transaction>> transactionList = {};
  String totalExpense = "0";
  String totalIncome = "0";

  void init() {
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

  void previousMonth() {
    currTimeline = currTimeline.previousMonth();
    setTransactions();
  }

  void nextMonth() {
    currTimeline = currTimeline.nextMonth();
    setTransactions();
  }

}