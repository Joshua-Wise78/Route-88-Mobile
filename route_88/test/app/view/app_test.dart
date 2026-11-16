import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_88/app/app.dart';
import 'package:route_88/core/network/api_client.dart';
import 'package:route_88/features/home/view/home_page.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

void main() {
  group('App', () {
    testWidgets('renders HomePage', (tester) async {
      final mockApiClient = MockApiClient();
      final mockDio = MockDio();

      when(() => mockApiClient.dio).thenReturn(mockDio);
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/'),
          data: {'results': <dynamic>[]},
          statusCode: 200,
        ),
      );

      await tester.pumpWidget(App(apiClient: mockApiClient));
      await tester.pump();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
