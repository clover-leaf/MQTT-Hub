import 'package:api_client/api_client.dart';
import 'package:bee/app/app.dart';
import 'package:bee/bootstrap.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:secure_storage_client/secure_storage_client.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //Remove this method to stop OneSignal Debugging
  await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  await OneSignal.shared.setAppId('3627dbf6-a450-4370-94af-7c874c103885');

  // The promptForPushNotificationsWithUserResponse function
  // will show the iOS or Android push notification prompt.
  // We recommend removing the following code and instead
  // using an In-App Message to prompt for notification permission
  final status = await OneSignal.shared.getDeviceState();
  print('id: ${status?.userId}');
  await OneSignal.shared
      .promptUserForPushNotificationPermission()
      .then((accepted) {
    print('Accepted permission: $accepted');
  });

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
