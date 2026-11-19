import '../models/transaction_model.dart';
import '../../domain/entities/transaction_entity.dart';

class LocalMockDatasource {
  LocalMockDatasource() : transactions = [
          TransactionModel(
            id: '1',
            description: 'Salario',
            category: 'Trabajo',
            amount: 2500,
            type: TransactionType.income,
            date: DateTime(2026, 11, 1),
          ),
          TransactionModel(
            id: '2',
            description: 'Supermercado',
            category: 'Alimentacion',
            amount: 650,
            type: TransactionType.expense,
            date: DateTime(2026, 11, 5),
          ),
        ];

  final List<TransactionModel> transactions;

  List<TransactionModel> getAll() => List.unmodifiable(transactions);

  void add(TransactionModel transaction) => transactions.insert(0, transaction);
}
