import 'package:flutter/material.dart';
import 'pages/login_screen.dart';
import 'pages/home_screen.dart';
import 'pages/home_screenU.dart';
import 'pages/create_screen.dart';
import 'pages/my_tickets_screen.dart';
import 'models/chamado.dart';
import 'pages/ticket_detail_screen.dart';
import 'pages/tickets_by_status_screen.dart';
import 'pages/ticket_user_detail_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginScreen(),
  '/home': (context) => HomeScreen(),
  '/homeU': (context) => HomeScreenU(),
  '/mytickets/create': (context) => const CreateScreen(),
  '/mytickets': (context) => const MyTicketsScreen(),

  '/tickets_status': (context) {
    final status = ModalRoute.of(context)!.settings.arguments as String;
    return TicketsByStatusScreen(status: status);
  },

  '/ticket_user': (context) {
    final chamado = ModalRoute.of(context)!.settings.arguments as Chamado;
    return TicketUserDetailScreen(chamado: chamado);
  },

  '/ticket': (context) {
    final chamado = ModalRoute.of(context)!.settings.arguments as Chamado;
    return TicketDetailScreen(chamado: chamado);
  },
};
