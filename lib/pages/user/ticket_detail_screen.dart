import 'dart:ui';
import 'package:flutter/material.dart';
import '/models/chamado.dart';

class TicketDetailScreen extends StatefulWidget {
  final Chamado chamado;
  const TicketDetailScreen({super.key, required this.chamado});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sugestaoIA() async {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Integração com IA ainda não configurada.")),
    );
  }

  Future<void> _enviar() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva a solução antes de enviar.')),
      );
      return;
    }

    setState(() => _sending = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _sending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solução enviada ao cliente!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final descricao = widget.chamado.description.trim().isEmpty
        ? "Aqui estará a descrição do problema."
        : widget.chamado.description;

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
            padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 20, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Text(
                  widget.chamado.subject,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Text(
                    descricao,
                    style: const TextStyle(color: Colors.white70, height: 1.4),
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Escreva a solução aqui...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _sugestaoIA,
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text("Sugestão IA"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _sending ? null : _enviar,
                        icon: _sending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send),
                        label: Text(_sending ? "Enviando..." : "Enviar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent.shade400,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
