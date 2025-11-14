import 'package:ticketflowfront/dto/response/area_dto.dart';
import 'package:ticketflowfront/utils/api_client.dart';
import 'package:ticketflowfront/utils/result.dart';

class CategoryService {
  final ApiClient _api;

  CategoryService(this._api);

  Future<Result<List<AreaDTO>>> fetchCategories() async {
    final response = await _api.get('/categorias');

    if (response.statusCode != 200) {
      return Result.failure('Failed to fetch categories');
    }
    
    final List<dynamic> data = response.data;

    return Result.success(data.map((json) => AreaDTO.fromJson(json)).toList());
  }
}
