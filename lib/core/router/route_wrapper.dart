import 'package:flutter/widgets.dart';
import 'package:local_auth_showcase/main.dart';

/// Точки входа на экраны могут реализовывать этот интерфейс,
/// чтоб вернуть экран обернутый в [MultiProvider],
/// который содержит необходимые зависимости.
///
/// Пример:
/// ```
/// @override
/// Widget wrappedRoute(Dependencies dependencies) {
///   return MultiProvider(
///     providers: FeatureDependencies.providers(dependencies),
///     child: this,
///   );
/// }
/// ```
abstract interface class RouteWrapper {
  Widget wrappedRoute(Dependencies dependencies);
}
