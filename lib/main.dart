import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app.dart';

void main() async{
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'jwt');
  
  runApp(MyApp(initialRoute: token == null ? '/login' : '/homeU'));
}