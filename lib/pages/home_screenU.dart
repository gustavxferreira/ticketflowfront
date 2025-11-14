import 'dart:ui';
import 'package:flutter/material.dart';

class HomeScreenU extends StatefulWidget {
  const HomeScreenU({super.key});

  @override
  State<HomeScreenU> createState() => _HomeScreenUState();
}

class _HomeScreenUState extends State<HomeScreenU>
    with TickerProviderStateMixin {
  late final AnimationController _pulse;
  late final AnimationController _fadeIn;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _fadeIn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _fadeIn.dispose();
    super.dispose();
  }


  Widget _glassCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color accent = const Color(0xFF00A3E0),
    bool big = false,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _fadeIn, curve: Curves.easeOut),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 250),
        tween: Tween(begin: 0.98, end: 1),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: accent.withOpacity(0.25),
          highlightColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(big ? 22 : 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.18),
                  blurRadius: 22,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
          
                Container(
                  width: big ? 64 : 56,
                  height: big ? 64 : 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withOpacity(0.2),
                    border: Border.all(color: accent.withOpacity(0.5)),
                  ),
                  child: Icon(icon, color: Colors.white, size: big ? 30 : 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: big ? 18 : 16,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.white.withOpacity(0.75)),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Usuário",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
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

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF021B31),
                  Color(0xFF003B6A),
                  Color(0xFF00A3E0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: -90,
            left: -70,
            child: _orb(const Color(0xFF00A3E0).withOpacity(0.20), 260),
          ),
          Positioned(
            bottom: -130,
            right: -90,
            child: _orb(const Color(0xFF66E0FF).withOpacity(0.16), 360),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(color: Colors.black.withOpacity(0.08)),
          ),


          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Row(
                    children: [
                      ScaleTransition(
                        scale: Tween(begin: 0.95, end: 1.05).animate(
                          CurvedAnimation(
                            parent: _pulse,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                            ),
                          ),
                          child: const Icon(
                            Icons.support_agent,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          "Bem-vindo, Usuário",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

              
                  _glassCard(
                    icon: Icons.add_task,
                    title: "Criar Chamado",
                    subtitle: "Descreva seu problema e envie para o suporte",
                    big: true,
                    onTap: () => Navigator.pushNamed(context, '/mytickets/create'),
                  ),
                  const SizedBox(height: 14),
                  _glassCard(
                    icon: Icons.view_list_rounded,
                    title: "Meus Chamados",
                    subtitle: "Abertos, em andamento e concluídos",
                    accent: const Color(0xFF0BC770),
                    big: true,
                    onTap: () => Navigator.pushNamed(context, '/mytickets'),
                  ),

                  const Spacer(),

              
                  Center(
                    child: Opacity(
                      opacity: 0.8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        child: const Text(
                          "Suporte disponível de 08h às 18h",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 40)],
      ),
    );
  }
}
