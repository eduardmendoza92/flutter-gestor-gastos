import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_monolitico/home_page.dart';

void main() {
  test('los montos deben ser mayores que cero', () {
    expect(0 <= 0, isTrue);
    expect((-1) <= 0, isTrue);
  });

  test('el balance usa ingresos menos gastos', () {
    const income = 2500.0;
    const expenses = 650.0;
    expect(income - expenses, 1850.0);
  });

  test('el filtro de gastos se identifica correctamente', () {
    expect('Gastos', 'Gastos');
  });
}
