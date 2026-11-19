import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repo.dart';
import '../datasources/local_mock_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepoImpl implements TransactionRepo {
  TransactionRepoImpl(this.datasource);

  final LocalMockDatasource datasource;

  @override
  void addTransaction(TransactionEntity transaction) {
    datasource.add(TransactionModel.fromEntity(transaction));
  }

  @override
  List<TransactionEntity> getTransactions() =>
      datasource.getAll().cast<TransactionEntity>();
}
