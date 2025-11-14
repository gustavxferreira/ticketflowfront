import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/chamado.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String> chamados = [
    "Chamado #1: Impressora com problema",
    "Chamado #2: Computador lento",
    "Chamado #3: Problema de rede",
    "Chamado #4: Solicitação de acesso",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Chamados",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
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
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF001A33),
                    Color(0xFF004E92),
                    Color(0xFF0099FF),
                  ],
                  center: Alignment(0.2, -0.3),
                  radius: 1.4,
                ),
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.black.withOpacity(0.15)),
          ),

          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 20),
            child: ListView.builder(
              itemCount: chamados.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white.withOpacity(0.1),
                  elevation: 6,
                  shadowColor: Colors.black54,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A3E0).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.support_agent,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      chamados[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                      size: 18,
                    ),

                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/ticket',
                        arguments: Chamado(
                          id: index.toString(),
                          subject: chamados[index],
                          description: "Aqui estará a descrição do problema.",
                          status: "em andamento",
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
