import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ticketflowfront/dto/my_tickets_dto.dart';
import 'package:ticketflowfront/utils/result.dart';
import 'package:ticketflowfront/utils/service_locator.dart';
import 'package:ticketflowfront/widgets/ticket_card.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  late Future<Result<List<MyTicketDTO>>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = calledService.getMyTickets();
  }

  final List<Map<String, String>> tickets = [
    {"titulo": "Chamado 1 de Thaysa", "chamados": "1"},
    {"titulo": "Em andamento", "chamados": "3"},
    {"titulo": "Finalizados", "chamados": "15"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Meus Chamados",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF001F3F),
                  Color(0xFF004F7A),
                  Color(0xFF00A3E0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -120,
                  left: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF007ACC).withOpacity(0.35),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -150,
                  right: -80,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(
                        255,
                        0,
                        127,
                        211,
                      ).withOpacity(0.25),
                    ),
                  ),
                ),
                Positioned(
                  top: 200,
                  left: 100,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF66E0FF).withOpacity(0.15),
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(color: Colors.black.withOpacity(0.05)),
                ),
              ],
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),

          FutureBuilder<Result<List<MyTicketDTO>>>(
            future: _ticketsFuture,
            builder: (context, snapshot) {
              // 1. ESTADO DE CARREGAMENTO (Spin)
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              // 2. ESTADO DE ERRO DE CONEXÃO
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Erro ao conectar no servidor",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              // 3. TRATAMENTO DO SEU RESULT WRAPPER
              // Verifica se veio dado e se o Result é de sucesso
              if (snapshot.hasData) {
                final result = snapshot.data!;

                if (! result.isSuccess) {
                  return Center(
                    child: Text(
                      result.error ?? "Erro desconhecido",
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                final List<MyTicketDTO> tickets = result.data!;

                if (tickets.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhum chamado encontrado.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return TicketCard(ticket: ticket);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
