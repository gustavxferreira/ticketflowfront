import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ticketflowfront/dto/response/ticket_detail_dto.dart';
import 'package:ticketflowfront/utils/service_locator.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TicketDetailsScreen extends StatefulWidget {
  final int ticketId;

  const TicketDetailsScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  TicketDetailDTO? _ticketDetails;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTicketDetails();
  }

  Future<void> _fetchTicketDetails() async {
    try {
      final response = await calledService.getTicketById(widget.ticketId);

      if (response.isSuccess) {
        setState(() {
          _ticketDetails = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.error ?? "Erro ao carregar o ticket.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Falha de conexão: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Detalhes do Ticket #${widget.ticketId}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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

          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),

          child: Text(
            _error!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_ticketDetails == null) {
      return const Center(
        child: Text(
          "Nenhum dado encontrado.",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final ticket = _ticketDetails!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ticket.calledSubject,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.folder_open,
            title: "Categoria",
            value:
                "${ticket.areaName} > ${ticket.categoryName} > ${ticket.subcategoryName}",
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            icon: Icons.info_outline,
            title: "Status",
            value: ticket.step,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            icon: Icons.calendar_today,
            title: "Aberto em",
            value: _formatDate(ticket.dateOpen),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white30),
          const SizedBox(height: 24),
          _buildSectionTitle("Descrição do Problema"),
          Text(
            ticket.calledDescription,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("Sugestão (IA)"),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: MarkdownBody(
              data:
                  ticket.suggestionAI ?? "Nenhuma sugestão disponível ainda...",

              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                  .copyWith(
                    
                    p: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),

                    
                    strong: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),

                    pPadding: const EdgeInsets.only(bottom: 8),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    IconData? icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white54, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
