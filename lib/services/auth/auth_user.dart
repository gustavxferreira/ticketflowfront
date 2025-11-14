import 'package:ticketflowfront/utils/api_client.dart';
import 'package:ticketflowfront/utils/result.dart';

class AuthUser {
  final ApiClient _api;

  AuthUser(this._api);

  Future<Result<String>> tryAuth(String email, String password) async {
    final response = await _api.get(
      '/auth',
      queryParameters: {'user': email, 'password': password},
    );

    if (response.statusCode != 200) {
      return Result.failure('Invalid credentials');
    }

    return Result.success(response.data.token);
  }
}
