import '../entities/transaction_entity.dart';

abstract class TransactionRepo {
  List<TransactionEntity> getTransactions();
  void addTransaction(TransactionEntity transaction);
}
