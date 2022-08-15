// // ignore_for_file: prefer_const_constructors

// import 'dart:convert';

// import 'package:api_client/api_client.dart';
// import 'package:http/http.dart' as http;
// import 'package:mocktail/mocktail.dart';
// import 'package:test/test.dart';

// class MockClient extends Mock implements http.Client {}

// void main() {
//   late String apiUrl;
//   late http.Client mockClient;
//   late ApiClient apiClient;

//   // setUpAll(() {
//   //   registerFallbackValue(FakeUri());
//   // });

//   setUp(() {
//     apiUrl = '0.0.0.0:8080';
//     mockClient = MockClient();
//     apiClient = ApiClient(
//       API_URL: apiUrl,
//       httpClient: mockClient,
//     );
//   });
//   group('ApiClient', () {
//     test('can be instantiated', () {
//       expect(
//         ApiClient(
//           API_URL: apiUrl,
//           httpClient: mockClient,
//         ),
//         isNotNull,
//       );
//     });
//     group('project', () {
//       group('createProject', () {
//         test('returns a valid project', () async {
//           final uri = Uri.http(apiUrl, 'v1/domain/projects');
//           when(
//             () => mockClient.post(uri, body: anything),
//           ).thenAnswer(
//             (input) async => http.Response(
//               jsonEncode({input.namedArguments[0]}),
//               200,
//             ),
//           );
//           await apiClient.createProject(
//             token: 'a.b.c',
//             project: {'id': 'vv', 'name': 'sunday'},
//           );
//           verify(() => mockClient.post(uri)).called(1);

//           // expect(
//           // apiClient.createProject(
//           //   token: 'a.b.c',
//           //   project: {'id': 'vv', 'name': 'sunday'},
//           // ),
//           //   completion(equals({'id': 'vv', 'name': 'sunday'})),
//           // );
//         });
//       });
//     });
//   });
// }
