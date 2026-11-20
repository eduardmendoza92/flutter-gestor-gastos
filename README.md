# flutter-gestor-gastos

Dos prototipos Flutter equivalentes para un estudio comparativo de calidad de software:

- `monolitica/`: lógica de negocio, datos y interfaz concentrados en `lib/home_page.dart`.
- `clean/`: separación por dominio, datos y presentación con Clean Architecture.

Ambos implementan un gestor local de ingresos y gastos sin APIs externas.

## Gráficos comparativos

Abre `docs/graficos-comparativos.html` en un navegador para visualizar las barras agrupadas de:

- tiempo por tarea;
- archivos tocados;
- cobertura LCOV.

Los valores de ejemplo y la tabla fuente están en `docs/metricas_comparativas.csv`. Reemplázalos por las mediciones reales del experimento.

## Ejecutar

```bash
cd monolitica
flutter pub get
flutter test
flutter analyze
flutter run
```

```bash
cd clean
flutter pub get
flutter test
flutter analyze
flutter run
```
