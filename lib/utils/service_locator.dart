import 'package:ticketflowfront/utils/api_client.dart';
import 'package:ticketflowfront/services/category/category_service.dart';
import 'package:ticketflowfront/services/called/called_service.dart';
import 'package:ticketflowfront/services/auth/auth_user.dart';

final ApiClient apiClient = ApiClient();

final CategoryService categoryService = CategoryService(apiClient);
final CalledService calledService = CalledService(apiClient);
final AuthUser authUser = AuthUser(apiClient);