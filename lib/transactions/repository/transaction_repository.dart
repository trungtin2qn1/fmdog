import 'package:hive_flutter/hive_flutter.dart';
import 'package:fmdog/transactions/models/transaction.dart';
import 'package:fmdog/ui/home/models/timeline.dart';
import 'package:fmdog/utils/enum/filter_days.dart';
import 'package:fmdog/utils/enum/transaction_type.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getAllTransactions(bool isRefresh);
  Future<Map<DateTime, List<Transaction>>> getGroupedTransactions(
      bool isRefresh, Timeline? timeline);
  Future<String> totalTransactions(TransactionType type, Timeline timeline);
  Future<String> filterTransactionTotal(FilterDays filterDays);
  Future<void> addTransaction(
    String? notes,
    double amount,
    DateTime time,
    int categoryId,
    int accountId,
    TransactionType transactionType,
  );
  Future<void> clearTransactions();
  Future<void> clearTransaction(int transactionId);
  Future<void> updateTransaction(Transaction transaction, {bool forceOverride});
  Box<Transaction> getBox();
  Future<Transaction?> fetchTransactionFromId(int transactionId);
}
