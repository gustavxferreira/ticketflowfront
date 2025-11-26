import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app.dart';
import 'package:ticketflowfront/utils/service_locator.dart'; 
import 'package:ticketflowfront/dto/response/me_dto.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'jwt');
  
  if(token == null) {
    runApp(MyApp(initialRoute: '/login'));
    return;
  }
  
  final result = await authUser.me();
  
  if (!result.isSuccess) {
    runApp(MyApp(initialRoute: '/login'));
    return;
  }
  
  final me = result.data!;
  
  if (me.role == 'admin') {
    runApp(MyApp(initialRoute: '/home'));
  } else {
    runApp(MyApp(initialRoute: '/homeU'));
  }
}