library ClientCommon.Utils.DI.HtmlStorage;
export 'package:cork/cork.dart';
export 'package:cork/mirrors.dart';
import 'package:cork/cork.dart';
import 'package:cork/src/binding/runtime.dart' show Binding, Provider;
export '../Interfaces/IStorage.dart';
import '../Interfaces/IStorage.dart';
import '../Impl/HtmlStorage.dart';


@Module(const [IStorage])
class HtmlStorageModule {
  static HtmlLocalStorage _storage = new HtmlLocalStorage();
  
  @Provide(IStorage)
  static IStorage getAdapter() => _storage;
}

@Entrypoint(const [HtmlStorageModule])
class HtmlStorageEntrypoint {}

final bindingsForHtmlStorageEntrypoint = <Binding>[
  new Binding(
      IStorage, new Provider((args) => HtmlStorageModule.getAdapter(), const []))
];