import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // <--- ADICIONE ESTE IMPORT
import 'package:ticketflowfront/dto/response/ticket_admin_dto.dart';
import 'package:ticketflowfront/utils/result.dart';
import 'package:ticketflowfront/utils/service_locator.dart';
import 'package:ticketflowfront/widgets/ticket_card_admin.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({super.key});

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin>
    with TickerProviderStateMixin {
  late final AnimationController _pulse;
  late final AnimationController _fadeIn;
  late final TabController _tabController;

  
  List<TicketAdminDTO> _allTickets = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeIn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    
    _fetchTickets();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _fadeIn.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTickets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await calledService.getAllTickets();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result.isSuccess) {
          _allTickets = result.data ?? [];
        } else {
          _errorMessage = result.error;
        }
      });
    }
  }

  
  Future<void> _logout() async {
    
    const storage = FlutterSecureStorage();

    
    await storage.delete(key: 'jwt');

    
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  
  bool _isOpenTab(String step) {
    final s = step.toLowerCase();
    return ['em aberto', 'em análise', 'aberto'].contains(s);
  }

  bool _isInProgressTab(String step) {
    final s = step.toLowerCase();
    return ['em desenvolvimento', 'em testes', 'em pausa', 'em andamento'].contains(s);
  }

  bool _isClosedTab(String step) {
    final s = step.toLowerCase();
    return ['encerrado', 'concluído', 'concluido', 'fechado'].contains(s);
  }

  List<TicketAdminDTO> _getTicketsForTab(int tabIndex) {
    switch (tabIndex) {
      case 0: return _allTickets.where((t) => _isOpenTab(t.step)).toList();
      case 1: return _allTickets.where((t) => _isInProgressTab(t.step)).toList();
      case 2: return _allTickets.where((t) => _isClosedTab(t.step)).toList();
      default: return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final countOpen = _allTickets.where((t) => _isOpenTab(t.step)).length;
    final countProgress = _allTickets.where((t) => _isInProgressTab(t.step)).length;
    final countClosed = _allTickets.where((t) => _isClosedTab(t.step)).length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Painel Admin",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        
        leading: IconButton(
          
          
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: _logout, 
        ),
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF00A3E0),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00A3E0).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                _buildTabWithBadge("Abertos", countOpen),
                _buildTabWithBadge("Andamento", countProgress),
                _buildTabWithBadge("Concluídos", countClosed),
              ],
            ),
          ),
        ),
      ),
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
          Positioned(
            top: -120, left: -100,
            child: _orb(const Color(0xFF007ACC).withOpacity(0.35), 300),
          ),
          Positioned(
            bottom: -150, right: -80,
            child: _orb(const Color.fromARGB(255, 0, 127, 211).withOpacity(0.25), 350),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(color: Colors.black.withOpacity(0.05)),
          ),

          
          Padding(
            padding: const EdgeInsets.only(top: 160),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off, size: 50, color: Colors.white54),
                            const SizedBox(height: 10),
                            Text(_errorMessage!, style: const TextStyle(color: Colors.white)),
                            TextButton(
                                onPressed: _fetchTickets,
                                child: const Text("Tentar Novamente"))
                          ],
                        ),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTicketList(_getTicketsForTab(0), "Abertos"),
                          _buildTicketList(_getTicketsForTab(1), "Em Andamento"),
                          _buildTicketList(_getTicketsForTab(2), "Concluídos"),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabWithBadge(String title, int count) {
      return Tab(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count > 99 ? "99+" : count.toString(),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ]
            ],
          ),
        ),
      );
    }

  Widget _buildTicketList(List<TicketAdminDTO> tickets, String tabName) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 60, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 10),
            Text(
              "Nenhum chamado em '$tabName'",
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];

        return FadeTransition(
          opacity: CurvedAnimation(
            parent: _fadeIn,
            curve: Interval(
              (index * 0.05).clamp(0.0, 1.0), 1.0,
              curve: Curves.easeOut,
            ),
          ),
          child: TicketCardAdmin(ticket: ticket),
        );
      },
    );
  }

  Widget _orb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 120, spreadRadius: 40)
        ],
      ),
    );
  }
}
