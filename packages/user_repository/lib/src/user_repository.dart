
import 'package:api_client/api_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:secure_storage_client/secure_storage_client.dart';

/// {@template user_repository}
/// A repository contain all client helper
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required ApiClient apiClient,
    required SecureStorageClient secureStorageClient,
    required String tokenKey,
  })  : _apiClient = apiClient,
        _secureStorageClient = secureStorageClient,
        _tokenKey = tokenKey;

  /// ApiClient
  final ApiClient _apiClient;

  /// SecureStorageClient
  final SecureStorageClient _secureStorageClient;

  /// JWT
  late String token;

  /// JWT key
  final String _tokenKey;

  /// the controller of [Stream]
  final _authenticatorStreamController = BehaviorSubject<bool>.seeded(false);

  /// gets the [Stream]
  Stream<bool> authenticatorSubscribe() {
    return _authenticatorStreamController.asBroadcastStream();
  }

  /// read secure-storage if it contains token
  Future<String> recoverSession() async {
    final token = await _secureStorageClient.readSecureData(_tokenKey);
    if (token != null) {
      return token;
    } else {
      throw Exception('Token not found');
    }
  }

  /// check if token is valid
  Future<void> checkToken(String token) async {
    await _apiClient.checkToken(token);
  }

  /// read all pair
  Future<Map<String, String>> readAll() async {
    return _secureStorageClient.readAll();
  }

  /// login into tenant with given data
  /// set token when success
  /// throw Exception(message) when fail
  Future<String> login(String domain, String email, String password) async {
    final token = await _apiClient.login(domain, email, password);
    await _secureStorageClient.writeSecureData(_tokenKey, token);
    return token;
  }

  /// udate authenticator stream
  void updateAuthenticator({required bool isAuth}) {
    _authenticatorStreamController.add(isAuth);
  }
}
