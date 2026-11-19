import 'package:flutter/material.dart';
import 'data/datasources/local_mock_datasource.dart';
import 'data/repositories/transaction_repo_impl.dart';
import 'presentation/providers/transaction_provider.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const CleanApp());
}

class CleanApp extends StatelessWidget {
  const CleanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final datasource = LocalMockDatasource();
    final repository = TransactionRepoImpl(datasource);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gastos - Clean',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomePage(provider: TransactionProvider(repository)),
    );
  }
}
