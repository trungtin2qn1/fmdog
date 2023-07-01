import 'package:fmdog/account/model/account.dart';
import 'package:fmdog/account/repository/account_repository.dart';
import 'package:fmdog/viewmodels/base_view_model.dart';

class ManageAccountViewModel extends BaseViewModel {
  ManageAccountViewModel({required this.accountRepository});

  final AccountRepository accountRepository;
  List<Account> accounts = [];

  Future<void> fetchAccounts() async {
    accounts = await accountRepository.accounts();
    notifyListeners();
  }
}
