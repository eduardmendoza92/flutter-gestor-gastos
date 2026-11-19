import '../entities/transaction_entity.dart';
import '../repositories/transaction_repo.dart';

class AddTransactionUseCase {
  AddTransactionUseCase(this.repository);

  final TransactionRepo repository;

  void execute(TransactionEntity transaction) {
    if (transaction.amount <= 0) {
      throw ArgumentError('El monto debe ser mayor que cero');
    }
    if (transaction.description.trim().isEmpty) {
      throw ArgumentError('La descripcion es obligatoria');
    }
    repository.addTransaction(transaction);
  }
}
