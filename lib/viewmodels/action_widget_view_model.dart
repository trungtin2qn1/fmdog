import 'package:fmdog/account/model/account.dart';
import 'package:fmdog/account/repository/account_repository.dart';
import 'package:fmdog/category/model/category.dart';
import 'package:fmdog/category/repository/category_repository.dart';
import 'package:fmdog/di/service_locator.dart';
import 'package:fmdog/settings/settings_service.dart';
import 'package:fmdog/viewmodels/add_transaction_view_model.dart';
import 'package:fmdog/viewmodels/base_view_model.dart';
import 'package:fmdog/utils/time_extension.dart';

class ActionWidgetViewModel extends BaseViewModel {
  ActionWidgetViewModel(
      {required this.accountRepository, required this.categoryRepository});

  final AccountRepository accountRepository;
  final CategoryRepository categoryRepository;
  late AddTransactionViewModel _transactionViewModel;
  SettingsService settingsService = locator.get();
  Category? _category;
  Account? _account;

  DateTime? get transactionDate {
    return _transactionViewModel.selectedDate;
  }

  String get transactionDecoratedDate {
    var selectedDateTime = _transactionViewModel.selectedDate ?? DateTime.now();
    return selectedDateTime.decoratedDate;
  }

  void init({required AddTransactionViewModel transactionViewModel}) async {
    _transactionViewModel = transactionViewModel;
    await _setCategory(categoryId: transactionViewModel.selectedCategoryId);
    await _setAccount(accountId: transactionViewModel.selectedAccountId);
    notifyListeners();
  }

  Future<void> _setCategory({required int? categoryId}) async {
    if (categoryId == null) {
      categoryId = await settingsService.getDefaultCategory();
      if (categoryId != null) {
        var category = await categoryRepository.fetchCategoryFromId(categoryId);
        if (category != null) {
          _category = category;
          _transactionViewModel.selectedCategoryId = category.id;
          _transactionViewModel.transactionType = category.transactionType;
        }
        return;
      }
      return;
    }
    _category = await categoryRepository.fetchCategoryFromId(categoryId);
  }

  Future<void> _setAccount({required int? accountId}) async {
    if (accountId == null) {
      accountId = await settingsService.getDefaultAccount();
      if (accountId != null) {
        var account = await accountRepository.fetchAccountFromId(accountId);
        if (account != null) {
          _account = account;
          _transactionViewModel.selectedAccountId = account.id;
        }
        return;
      }
      return;
    }
    _account = await accountRepository.fetchAccountFromId(accountId);
  }

  Category? getCategory() {
    if (_category != null) {
      return _category!;
    }
    return null;
  }

  Account? getAccount() {
    if (_account != null) {
      return _account!;
    }
    return null;
  }

  void setCategory(Category category) {
    _category = category;
    _transactionViewModel.selectedCategoryId = category.id;
    _transactionViewModel.transactionType = category.transactionType;
    notifyListeners();
  }

  void setAccount(Account account) {
    _account = account;
    _transactionViewModel.selectedAccountId = account.id;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _transactionViewModel.selectedDate = date;
    notifyListeners();
  }

  // Account getAccount() {
  //   if (account != null) {
  //     return account!;
  //   }
  //   return Account(emoji: "🫠", name: "Default Account");
  // }
}
