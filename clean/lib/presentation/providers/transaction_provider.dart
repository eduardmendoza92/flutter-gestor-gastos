import 'package:flutter/foundation.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repo.dart';
import '../../domain/usecases/add_transaction_usecase.dart';
import '../../domain/usecases/get_balance_summary_usecase.dart';

class TransactionProvider extends ChangeNotifier {
  TransactionProvider(this.repository)
      : addTransactionUseCase = AddTransactionUseCase(repository),
        getBalanceSummaryUseCase = GetBalanceSummaryUseCase();

  final TransactionRepo repository;
  final AddTransactionUseCase addTransactionUseCase;
  final GetBalanceSummaryUseCase getBalanceSummaryUseCase;
  String filter = 'Todos';

  List<TransactionEntity> get transactions => repository.getTransactions();

  BalanceSummary get summary =>
      getBalanceSummaryUseCase.execute(transactions);

  List<TransactionEntity> get filteredTransactions {
    if (filter == 'Ingresos') {
      return transactions
          .where((item) => item.type == TransactionType.income)
          .toList();
    }
    if (filter == 'Gastos') {
      return transactions
          .where((item) => item.type == TransactionType.expense)
          .toList();
    }
    return transactions;
  }

  void setFilter(String value) {
    filter = value;
    notifyListeners();
  }

  void add(TransactionEntity transaction) {
    addTransactionUseCase.execute(transaction);
    notifyListeners();
  }
}
