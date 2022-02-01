import 'package:flutter_modular/flutter_modular.dart';
import 'package:intoxianimes_value_notifier/modules/home/home_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/', module: HomeModule()),
      ];
}
