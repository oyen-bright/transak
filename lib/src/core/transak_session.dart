import 'package:transak/src/core/transak_config.dart';
import 'package:transak/src/core/transak_enum.dart';
import 'package:transak/src/core/transak_exception.dart';

class SessionConfig {
  static String? _modalTitle;
  static TransakConfigParams? _config;
  static TransakEnvironment? _environment;
  static TransakConfigParams? get config => _config;
  static TransakEnvironment? get environment => _environment;
  static String? get iosModalTitle => _modalTitle;
  static String get _endpoint =>
      _environmentEndpoint[environment ?? TransakEnvironment.test]!;
  static ({String? url, TransakConfigParams? params, String? modalTitle})?
      get sessionData {
    if (_config != null && _environment != null && _modalTitle != null) {
      return (url: _endpoint, params: config, modalTitle: _modalTitle);
    }
    return null;
  }

  static final Map<TransakEnvironment, String> _environmentEndpoint = {
    TransakEnvironment.production: "global.transak.com",
    TransakEnvironment.test: "global-stg.transak.com",
  };

  static Future<void> sessionConfig(TransakConfigParams configParams,
      {required TransakEnvironment environment,
      String modalTitle = "Transak"}) async {
    if (_config == null && _environment == null) {
      _config = configParams;
      _modalTitle = modalTitle;
      _environment = environment;
    } else {
      throw TransakException("Transak configuration already set");
    }
  }

  // static ({String url, String redirectURL}) buildURL(
  //     TransactionParams params) {}
}
