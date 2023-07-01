import 'package:fmdog/viewmodels/time_range_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:fmdog/account/data_source/account_local_data_source.dart';
import 'package:fmdog/account/data_source/account_local_data_source_impl.dart';
import 'package:fmdog/account/model/account.dart';
import 'package:fmdog/account/repository/account_repository.dart';
import 'package:fmdog/account/repository/account_repository_impl.dart';
import 'package:fmdog/category/data_source/category_local_data_source.dart';
import 'package:fmdog/category/data_source/category_local_data_source_impl.dart';
import 'package:fmdog/category/model/category.dart';
import 'package:fmdog/category/repository/category_repository.dart';
import 'package:fmdog/category/repository/category_repository_impl.dart';
import 'package:fmdog/settings/settings_service.dart';
import 'package:fmdog/transactions/data_sources/transaction_local_data_source.dart';
import 'package:fmdog/transactions/data_sources/transaction_local_data_source_impl.dart';
import 'package:fmdog/transactions/models/transaction.dart';
import 'package:fmdog/transactions/repository/transaction_repository.dart';
import 'package:fmdog/transactions/repository/transaction_repository_impl.dart';
import 'package:fmdog/utils/enum/box_types.dart';
import 'package:fmdog/utils/enum/transaction_type.dart';
import 'package:fmdog/viewmodels/action_widget_view_model.dart';
import 'package:fmdog/viewmodels/add_transaction_view_model.dart';
import 'package:fmdog/viewmodels/currency_viewmodel.dart';
import 'package:fmdog/viewmodels/home_screen_viewmodel.dart';
import 'package:fmdog/viewmodels/insights_viewmodel.dart';
import 'package:fmdog/viewmodels/manage_account_view_model.dart';
import 'package:fmdog/viewmodels/manage_category_view_model.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  await _setupHive();
  _localSources();
  _setupRepository();
  _setupViewModels();
}

Future<void> _setupHive() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(TransactionAdapter())
    ..registerAdapter(TransactionTypeAdapter())
    ..registerAdapter(AccountAdapter())
    ..registerAdapter(CategoryAdapter());

  final transactionBox =
      await Hive.openBox<Transaction>(BoxType.transactions.stringValue);
  locator.registerLazySingleton<Box<Transaction>>(() => transactionBox);

  final categoryBox =
      await Hive.openBox<Category>(BoxType.category.stringValue);
  locator.registerLazySingleton<Box<Category>>(() => categoryBox);

  final accountBox = await Hive.openBox<Account>(BoxType.accounts.stringValue);
  locator.registerLazySingleton<Box<Account>>(() => accountBox);

  final settingsBox = await Hive.openBox(BoxType.settings.stringValue);
  locator.registerLazySingleton<Box<dynamic>>(() => settingsBox);
}

void _localSources() {
  locator.registerLazySingleton<TransactionManagerLocalDataSource>(
      () => TransactionManagerLocalDataSourceImpl());
  locator.registerLazySingleton<CategoryLocalDataSource>(
      () => CategoryLocalDataSourceImpl());
  locator.registerLazySingleton<AccountLocalDataSource>(
      () => AccountLocalDataSourceImpl());
}

void _setupRepository() {
  locator.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      dataSource: locator.get(),
    ),
  );
  locator.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      dataSource: locator.get(),
    ),
  );
  locator.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      dataSource: locator.get(),
    ),
  );

  locator.registerLazySingleton<SettingsService>(() => SettingsServiceImpl());
}

void _setupViewModels() {
  locator.registerFactory(
    () => HomeScreenViewModel(
      accountRepository: locator.get(),
      categoryRepository: locator.get(),
      transactionRepository: locator.get(),
    ),
  );

  locator.registerFactory(
    () => InsightsViewModel(
      accountRepository: locator.get(),
      categoryRepository: locator.get(),
      transactionRepository: locator.get(),
    ),
  );

  locator.registerFactory(
    () => AddTransactionViewModel(
      accountRepository: locator.get(),
      categoryRepository: locator.get(),
      transactionRepository: locator.get(),
    ),
  );

  locator.registerFactory(
    () => ActionWidgetViewModel(
      accountRepository: locator.get(),
      categoryRepository: locator.get(),
    ),
  );

  locator.registerFactory(
    () => ManageCategoryViewModel(
      categoryRepository: locator.get(),
    ),
  );

  locator.registerFactory(
    () => ManageAccountViewModel(
      accountRepository: locator.get(),
    ),
  );

  locator.registerFactory(
    () => CurrencyViewModel(
      settingsService: locator.get(),
    ),
  );

  locator.registerFactory(
    () => TimeRangeViewModel(
      transactionRepository: locator.get(),
    ),
  );
}
