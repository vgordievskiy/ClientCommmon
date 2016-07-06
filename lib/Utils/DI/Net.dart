library ClientCommon.Utils.DI.Net;
export 'package:cork/cork.dart';
export 'package:cork/mirrors.dart';
export '../Interfaces/IRestAdapter.dart';
export '../CachedRestAdapter.dart';
export '../HttpCommunicator/HttpBrowserCommunicator.dart';
import 'package:cork/cork.dart';
import 'package:cork/src/binding/runtime.dart' show Binding, Provider;
import '../Interfaces/IRestAdapter.dart';
import '../HttpCommunicator/HttpBrowserCommunicator.dart';
import '../CachedRestAdapter.dart';

@Module(const [IRestAdapter])
class NetModule {
  static HttpCommunicator _httpBrowserCom = new HttpCommunicator();
  static CachedRestAdapter _restAdapter = new CachedRestAdapter(_httpBrowserCom);

  @Provide(IRestAdapter)
  static IRestAdapter getRestAdapter() => _restAdapter;
}

@Entrypoint(const [NetModule])
class NetModuleEntrypoint {}

final bindingsForNetModuleEntrypoint = <Binding>[
  new Binding(
      IRestAdapter, new Provider((args) => NetModule.getRestAdapter(), const []))
];
