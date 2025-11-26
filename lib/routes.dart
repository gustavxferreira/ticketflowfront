import 'package:flutter/material.dart';
import 'package:ticketflowfront/pages/user/ticket_details_screen.dart';
import '/pages/login_screen.dart';
import '/pages/admin/home_screen_admin.dart';
import '/pages/user/home_screenU.dart';
import '/pages/user/create_screen.dart';
import '/pages/user/my_tickets_screen.dart';
import 'models/chamado.dart';
import '/pages/user/ticket_detail_screen.dart';
import '/pages/admin/ticket_details_screen_admin.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginScreen(),
  '/homeU': (context) => HomeScreenU(),
  '/home': (context) => HomeScreenAdmin(),
  '/mytickets/create': (context) => const CreateScreen(),
  '/mytickets': (context) => const MyTicketsScreen(),

  '/ticket-details': (context) {
    final int ticketId = ModalRoute.of(context)!.settings.arguments as int;
    return TicketDetailsScreen(ticketId: ticketId);
  },
  
  '/ticket-details-admin': (context) {
    final int ticketId = ModalRoute.of(context)!.settings.arguments as int;
    return TicketDetailsAdminScreen(ticketId: ticketId);
  },
  
  '/ticket': (context) {
    final chamado = ModalRoute.of(context)!.settings.arguments as Chamado;
    return TicketDetailScreen(chamado: chamado);
  },
};
