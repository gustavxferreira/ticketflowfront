import 'dart:ui';
import 'package:flutter/material.dart';
import '/models/chamado.dart';

class TicketUserDetailScreen extends StatelessWidget {
  final Chamado chamado;

  const TicketUserDetailScreen({super.key, required this.chamado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Detalhes do Chamado"),
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

          Padding(
            padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chamado.subject,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    chamado.description.isEmpty
                        ? "Aqui estará a descrição do problema."
                        : chamado.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 30),
                Text(
                  "Status: ${chamado.status}",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
