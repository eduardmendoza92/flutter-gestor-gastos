import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.description,
    required super.category,
    required super.amount,
    required super.type,
    required super.date,
  });

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      description: entity.description,
      category: entity.category,
      amount: entity.amount,
      type: entity.type,
      date: entity.date,
    );
  }
}
