import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:mockito/annotations.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

import 'parse_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late ApiService apiService;

  setUp(() {
    mockClient = MockClient();
    apiService = ApiService();
  });
  group('Test Fetch API', () {
    test(
        'getAll returns a Restaurant object if the http call completes successfully',
        () async {
      const sampleResponse = '''
        {
          "error": false,
          "message": "success",
          "count": 2,
          "restaurants": [
            {
              "id": "rqdv5juczeskfw1e867",
              "name": "Melting Pot",
              "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
              "pictureId": "14",
              "city": "Medan",
              "rating": 4.2
            },
            {
              "id": "s1knt6za9kkfw1e867",
              "name": "Kafe Kita",
              "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
              "pictureId": "25",
              "city": "Gorontalo",
              "rating": 4
            }
          ]
        }
      ''';

      when(mockClient.get(Uri.parse("${ApiService.baseURL}/list")))
          .thenAnswer((_) async => http.Response(sampleResponse, 200));

      final result = await apiService.getAll(mockClient);

      expect(result, isA<Restaurant>());
    });

    test(
        'getAll throws an exception if the http call completes with an error (dont use internet)',
        () async {
      when(mockClient.get(Uri.parse("${ApiService.baseURL}/list")))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => apiService.getAll(mockClient), throwsException);
    });
  });
}
