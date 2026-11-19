enum TransactionType { income, expense }

class TransactionEntity {
  const TransactionEntity({
    required this.id,
    required this.description,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
  });

  final String id;
  final String description;
  final String category;
  final double amount;
  final TransactionType type;
  final DateTime date;
}
