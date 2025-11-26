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
  final storage = const FlutterSecureStorage();

  bool _obscure = true;
  bool _isLoading = false; 
  bool _hasError = false; 

  late final AnimationController _fadeIn;
  late final AnimationController _pulse;
  
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeIn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), 
    )..repeat(reverse: true);

    
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    
    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
        
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
  }

  @override
  void dispose() {
    _fadeIn.dispose();
    _pulse.dispose();
    _shakeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _triggerError() {
    setState(() {
      _isLoading = false;
      _hasError = true;
    });
    _shakeController.forward();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 10),
            Text("Email ou senha incorretos"),
          ],
        ),
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _login() async {
    
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _hasError = false; 
    });

    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      
      if (email.isEmpty || password.isEmpty) {
        _triggerError();
        return;
      }

      final response = await apiClient.post(
        '/auth',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'];
      
      
      
      if (token != null) {
        await storage.write(key: 'jwt', value: token);
         
        final result = await authUser.me();
        
        final me = result.data!;
        
        if (mounted) {
        if (me.role == 'admin') {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/homeU');
        }
        }
      } else {
        if (mounted) _triggerError();
      }
    } catch (e) {
      
      if (mounted) _triggerError();
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

  
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscure : false,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      obscuringCharacter: '•',
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: _hasError 
            ? Colors.red.withOpacity(0.1) 
            : Colors.white.withOpacity(0.10),
        
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: _hasError ? Colors.redAccent : Colors.transparent,
            width: 1.5,
          ),
        ),
        
        
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: _hasError ? Colors.red : Colors.white.withOpacity(0.5),
            width: 1.5,
          ),
        ),

        prefixIcon: Icon(icon, color: _hasError ? Colors.redAccent : Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
              )
            : null,
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
                colors: [Color(0xFF001F3F), Color(0xFF004F7A), Color(0xFF00A3E0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          Positioned(top: -120, left: -100, child: _orb(const Color(0xFF007ACC).withOpacity(0.35), 300)),
          Positioned(bottom: -150, right: -80, child: _orb(const Color.fromARGB(255, 0, 127, 211).withOpacity(0.25), 350)),
          Positioned(top: 200, left: 100, child: _orb(const Color(0xFF66E0FF).withOpacity(0.15), 250)),

          
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(color: Colors.black.withOpacity(0.06)),
          ),

          
          Center(
            child: FadeTransition(
              opacity: CurvedAnimation(parent: _fadeIn, curve: Curves.easeOut),
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  
                  return Transform.translate(
                    offset: Offset(
                      
                      (_shakeAnimation.value * 2) * (1 - (_shakeController.value)), 
                      0,
                    ),
                    child: child,
                  );
                },
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
                            
                            color: _hasError 
                                ? Colors.redAccent.withOpacity(0.5) 
                                : Colors.white.withOpacity(0.16),
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
                                  CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                                ),
                                child: Image.asset(
                                  'assets/images/logo.png', 
                                  width: 96,
                                  height: 96,
                                  
                                  errorBuilder: (c, o, s) => const Icon(Icons.confirmation_number, size: 80, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 16),

                              const Text(
                                "Bem-vindo",
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 24),

                              _buildTextField(
                                controller: _emailController,
                                hint: "Email",
                                icon: Icons.email,
                              ),
                              
                              const SizedBox(height: 14),

                              _buildTextField(
                                controller: _passwordController,
                                hint: "Senha",
                                icon: Icons.lock,
                                isPassword: true,
                              ),
                              
                              const SizedBox(height: 22),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : () async {
                                    await _login();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: _hasError 
                                        ? Colors.redAccent 
                                        : const Color(0xFF00285C), 
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 8,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          _hasError ? "Tentar Novamente" : "Entrar",
                                          style: const TextStyle(
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
          ),
        ],
      ),
    );
  }
}