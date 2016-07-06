library ClientCommon.Utils.DI.NetIo;
export 'package:cork/cork.dart';
export 'package:cork/mirrors.dart';
import 'package:cork/cork.dart';
export '../Interfaces/IRestAdapter.dart';
import '../Interfaces/IRestAdapter.dart';
import '../HttpCommunicator/IOHttpCommunicator.dart';
import '../RestAdapter.dart';

@Module(const [IRestAdapter])
class NetModule {
  static IoHttpCommunicator _httpBrowserCom = new IoHttpCommunicator();
  static RestAdapter _restAdapter = new RestAdapter(_httpBrowserCom);
  
  @Provide(IRestAdapter)
  static IRestAdapter getRestAdapter() => _restAdapter;
}

@Entrypoint(const [NetModule])
class NetModuleEntrypoint {}