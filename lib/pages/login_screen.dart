import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticketflowfront/utils/service_locator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
  with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  double _errorOpacity = 0.0;
  bool _obscure = true;

  late final AnimationController _fadeIn;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _fadeIn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeIn.dispose();
    _pulse.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final response = await apiClient.post(
      '/auth',
      data: {'email': email, 'password': password},
    );

    final token = response.data['token'];

    if (token != null) {
      await storage.write(key: 'jwt', value: token);

      Navigator.pushReplacementNamed(context, '/homeU');
    } else {
      setState(() => _errorOpacity = 0.7);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _errorOpacity = 0.0);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email ou senha incorretos"),
          backgroundColor: Color.fromARGB(221, 255, 255, 255),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ),
          Positioned(
            top: -120,
            left: -100,
            child: _orb(const Color(0xFF007ACC).withOpacity(0.35), 300),
          ),
          Positioned(
            bottom: -150,
            right: -80,
            child: _orb(
              const Color.fromARGB(255, 0, 127, 211).withOpacity(0.25),
              350,
            ),
          ),
          Positioned(
            top: 200,
            left: 100,
            child: _orb(const Color(0xFF66E0FF).withOpacity(0.15), 250),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(color: Colors.black.withOpacity(0.06)),
          ),

          Center(
            child: FadeTransition(
              opacity: CurvedAnimation(parent: _fadeIn, curve: Curves.easeOut),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      width: 420,
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00A3E0).withOpacity(0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ScaleTransition(
                              scale: Tween(begin: 0.98, end: 1.08).animate(
                                CurvedAnimation(
                                  parent: _pulse,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: Image.asset(
                                'images/logo.png',
                                width: 96,
                                height: 96,
                              ),
                            ),
                            const SizedBox(height: 16),

                            const Text(
                              "Bem-vindo",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),

                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.white70,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                            ),
                            const SizedBox(height: 14),

                            TextField(
                              controller: _passwordController,
                              obscureText: _obscure,
                              enableSuggestions: false,
                              autocorrect: false,
                              obscuringCharacter: '•',
                              decoration: InputDecoration(
                                hintText: "Senha",
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.white70,
                                ),
                                suffixIcon: IconButton(
                                  tooltip: _obscure
                                      ? 'Mostrar senha'
                                      : 'Ocultar senha',
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 22),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _login();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    0,
                                    40,
                                    92,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 8,
                                ),
                                child: const Text(
                                  "Entrar",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          IgnorePointer(
            ignoring: true,
            child: AnimatedOpacity(
              opacity: _errorOpacity,
              duration: const Duration(milliseconds: 200),
              child: Container(color: Colors.red.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }
}
