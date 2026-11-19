import 'package:flutter/material.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/transaction_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.provider});

  final TransactionProvider provider;

  String formatMoney(double amount) => '\$${amount.toStringAsFixed(2)}';

  void addTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        final descriptionController = TextEditingController();
        final amountController = TextEditingController();
        final categoryController = TextEditingController();
        TransactionType selectedType = TransactionType.expense;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nuevo movimiento',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<TransactionType>(
                    segments: const [
                      ButtonSegment(
                        value: TransactionType.income,
                        label: Text('Ingreso'),
                      ),
                      ButtonSegment(
                        value: TransactionType.expense,
                        label: Text('Gasto'),
                      ),
                    ],
                    selected: {selectedType},
                    onSelectionChanged: (values) {
                      setSheetState(() => selectedType = values.first);
                    },
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripcion'),
                  ),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(labelText: 'Categoria'),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Monto'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      final amount = double.tryParse(amountController.text);
                      if (amount == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ingrese un monto valido'),
                          ),
                        );
                        return;
                      }
                      try {
                        provider.add(
                          TransactionEntity(
                            id: DateTime.now().microsecondsSinceEpoch.toString(),
                            description: descriptionController.text,
                            category: categoryController.text,
                            amount: amount,
                            type: selectedType,
                            date: DateTime.now(),
                          ),
                        );
                        Navigator.pop(sheetContext);
                      } on ArgumentError catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.message.toString())),
                        );
                      }
                    },
                    child: const Text('Guardar movimiento'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: provider,
      builder: (context, _) {
        final summary = provider.summary;
        return Scaffold(
          appBar: AppBar(title: const Text('Gestor de Gastos')),
          floatingActionButton: FloatingActionButton(
            onPressed: () => addTransaction(context),
            child: const Icon(Icons.add),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Balance'),
                      Text(
                        formatMoney(summary.balance),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ingresos: ${formatMoney(summary.income)}'),
                          Text('Gastos: ${formatMoney(summary.expenses)}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (summary.budgetAlert)
                const Card(
                  color: Color(0xFFFFCDD2),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Alerta: los gastos superan el 80% de los ingresos.',
                      style: TextStyle(
                        color: Color(0xFFB71C1C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Todos', label: Text('Todos')),
                  ButtonSegment(value: 'Ingresos', label: Text('Ingresos')),
                  ButtonSegment(value: 'Gastos', label: Text('Gastos')),
                ],
                selected: {provider.filter},
                onSelectionChanged: (values) =>
                    provider.setFilter(values.first),
              ),
              const SizedBox(height: 8),
              ...provider.filteredTransactions.map(
                (item) => Card(
                  child: ListTile(
                    leading: Icon(
                      item.type == TransactionType.income
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: item.type == TransactionType.income
                          ? Colors.green
                          : Colors.red,
                    ),
                    title: Text(item.description),
                    subtitle: Text(item.category),
                    trailing: Text(
                      '${item.type == TransactionType.income ? '+' : '-'}${formatMoney(item.amount)}',
                      style: TextStyle(
                        color: item.type == TransactionType.income
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
