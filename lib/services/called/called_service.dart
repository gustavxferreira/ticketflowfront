import 'package:ticketflowfront/dto/called_create_dto.dart';
import 'package:ticketflowfront/dto/my_tickets_dto.dart';
import 'package:ticketflowfront/dto/response/created_called_dto.dart';
import 'package:ticketflowfront/utils/api_client.dart';
import 'package:ticketflowfront/utils/result.dart';

class CalledService {
  final ApiClient _api;

  CalledService(this._api);

  Future<Result> create(CalledCreateDTO dto) async {
    final response = await _api.post('/chamados', data: dto.toJson());

    if (response.statusCode != 201) {
      return Result.failure("Failed to create called");
    }

    final createdCalled = CreatedCalledDTO.fromJson(response.data);
    return Result.success(createdCalled);
  }
  
  Future<Result<List<MyTicketDTO>>> getMyTickets() async {
    final response = await _api.get('/meus-chamados');
    
    if (response.statusCode != 200) {
      return Result.failure('Failed to fetch my tickets');
    }
    
    final List<dynamic> data = response.data;

    final tickets = data.map((json) => MyTicketDTO.fromJson(json)).toList();
    return Result.success(tickets);
  }
}
