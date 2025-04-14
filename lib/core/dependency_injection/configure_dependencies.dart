import 'package:dash_code/core/dependency_injection/configure_dependencies.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final serviceLocator = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)

Future configureDependencies() async {
  return serviceLocator.init();
}
