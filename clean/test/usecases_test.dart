import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_clean/domain/entities/transaction_entity.dart';
import 'package:gestor_clean/domain/usecases/add_transaction_usecase.dart';
import 'package:gestor_clean/domain/usecases/get_balance_summary_usecase.dart';
import 'package:gestor_clean/data/datasources/local_mock_datasource.dart';
import 'package:gestor_clean/data/repositories/transaction_repo_impl.dart';

void main() {
  test('rechaza monto menor o igual a cero', () {
    final repository =
        TransactionRepoImpl(LocalMockDatasource());
    final useCase = AddTransactionUseCase(repository);
    final invalid = TransactionEntity(
      id: 'x',
      description: 'Prueba',
      category: 'Otros',
      amount: 0,
      type: TransactionType.expense,
      date: DateTime(2026),
    );

    expect(() => useCase.execute(invalid), throwsArgumentError);
  });

  test('calcula ingresos, gastos, balance y alerta', () {
    final useCase = GetBalanceSummaryUseCase();
    final result = useCase.execute([
      TransactionEntity(
        id: '1',
        description: 'Ingreso',
        category: 'Trabajo',
        amount: 1000,
        type: TransactionType.income,
        date: DateTime(2026),
      ),
      TransactionEntity(
        id: '2',
        description: 'Gasto',
        category: 'Otros',
        amount: 850,
        type: TransactionType.expense,
        date: DateTime(2026),
      ),
    ]);

    expect(result.income, 1000);
    expect(result.expenses, 850);
    expect(result.balance, 150);
    expect(result.budgetAlert, isTrue);
  });
}
