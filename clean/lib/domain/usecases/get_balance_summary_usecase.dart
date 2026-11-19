import '../entities/transaction_entity.dart';

class BalanceSummary {
  const BalanceSummary({
    required this.income,
    required this.expenses,
    required this.balance,
    required this.budgetAlert,
  });

  final double income;
  final double expenses;
  final double balance;
  final bool budgetAlert;
}

class GetBalanceSummaryUseCase {
  BalanceSummary execute(List<TransactionEntity> transactions) {
    var income = 0.0;
    var expenses = 0.0;

    for (final transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        income += transaction.amount;
      } else {
        expenses += transaction.amount;
      }
    }

    return BalanceSummary(
      income: income,
      expenses: expenses,
      balance: income - expenses,
      budgetAlert: income > 0 && expenses > income * 0.80,
    );
  }
}
