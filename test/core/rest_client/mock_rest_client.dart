import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';


class MockRestClient extends Mock implements RestClient {
  MockRestClient() {
    when(unAuth).thenReturn(this);
    when(auth).thenReturn(this);
  }
}
