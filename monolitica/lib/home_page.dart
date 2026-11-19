import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class Transaction {
  Transaction({
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> transactions = [
    Transaction(
      id: '1',
      description: 'Salario',
      category: 'Trabajo',
      amount: 2500,
      type: TransactionType.income,
      date: DateTime(2026, 11, 1),
    ),
    Transaction(
      id: '2',
      description: 'Supermercado',
      category: 'Alimentacion',
      amount: 650,
      type: TransactionType.expense,
      date: DateTime(2026, 11, 5),
    ),
  ];
  String filter = 'Todos';

  double get income =>
      transactions.where((item) => item.type == TransactionType.income).fold(
            0,
            (sum, item) => sum + item.amount,
          );

  double get expenses =>
      transactions.where((item) => item.type == TransactionType.expense).fold(
            0,
            (sum, item) => sum + item.amount,
          );

  double get balance => income - expenses;

  bool get budgetAlert => income > 0 && expenses > income * 0.80;

  String formatMoney(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  List<Transaction> get filteredTransactions {
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

  void addTransaction() {
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
                    decoration:
                        const InputDecoration(labelText: 'Descripcion'),
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
                      if (amount == null || amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('El monto debe ser mayor que cero'),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        transactions.insert(
                          0,
                          Transaction(
                            id: DateTime.now().microsecondsSinceEpoch.toString(),
                            description: descriptionController.text.trim(),
                            category: categoryController.text.trim(),
                            amount: amount,
                            type: selectedType,
                            date: DateTime.now(),
                          ),
                        );
                      });
                      Navigator.pop(sheetContext);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de Gastos')),
      floatingActionButton: FloatingActionButton(
        onPressed: addTransaction,
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
                    formatMoney(balance),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ingresos: ${formatMoney(income)}'),
                      Text('Gastos: ${formatMoney(expenses)}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (budgetAlert)
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
            selected: {filter},
            onSelectionChanged: (values) =>
                setState(() => filter = values.first),
          ),
          const SizedBox(height: 8),
          ...filteredTransactions.map(
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
  }
}
