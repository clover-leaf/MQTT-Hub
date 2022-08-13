import 'package:api_client/api_client.dart';
import 'package:bee/app/app.dart';
import 'package:bee/bootstrap.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:secure_storage_client/secure_storage_client.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: 'assets/.env');
  await bootstrap(() {
    final apiClient =
        ApiClient(API_URL: dotenv.env['API_URL']!, httpClient: http.Client());
    final secureStorageClient =
        SecureStorageClient(secureStorage: const FlutterSecureStorage());
    final userRepository = UserRepository(
      apiClient: apiClient,
      secureStorageClient: secureStorageClient,
      tokenKey: dotenv.env['TOKEN_KEY']!,
    );
    return App(userRepository: userRepository);
  });
}
