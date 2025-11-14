import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/chamado.dart';

class TicketsByStatusScreen extends StatelessWidget {
  final String status;
  const TicketsByStatusScreen({super.key, required this.status});

  List<Chamado> _loadTickets(String status) {
    switch (status) {
      case "Aberto":
        return [
          Chamado(
            id: "u1",
            subject: "Impressora sem papel",
            description: "",
            status: "Aberto",
          ),
          Chamado(
            id: "u2",
            subject: "Solicitar acesso ao ERP",
            description: "",
            status: "Aberto",
          ),
        ];
      case "Em andamento":
        return [
          Chamado(
            id: "u3",
            subject: "Lentidão no PC do financeiro",
            description: "",
            status: "Em andamento",
          ),
          Chamado(
            id: "u4",
            subject: "Erro ao enviar e-mails",
            description: "",
            status: "Em andamento",
          ),
          Chamado(
            id: "u5",
            subject: "VPN cai ao conectar",
            description: "",
            status: "Em andamento",
          ),
        ];
      default:
        return [
          Chamado(
            id: "u6",
            subject: "Troca de mouse concluída",
            description: "",
            status: "Finalizados",
          ),
          Chamado(
            id: "u7",
            subject: "Rede do setor X normalizada",
            description: "",
            status: "Finalizados",
          ),
          Chamado(
            id: "u8",
            subject: "Atualização do sistema aplicada",
            description: "",
            status: "Finalizados",
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final tickets = _loadTickets(status);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(status),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF001F3F), Color(0xFF004E92), Color(0xFF00A3E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            blendMode: BlendMode.srcOver,
            child: Container(color: Colors.black),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.black.withOpacity(0.15)),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(top: kToolbarHeight + 20),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final chamado = tickets[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
                child: ListTile(
                  leading: const Icon(Icons.description, color: Colors.white),
                  title: Text(
                    chamado.subject,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/ticket_user',
                      arguments: chamado,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
