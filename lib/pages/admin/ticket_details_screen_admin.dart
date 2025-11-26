import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ticketflowfront/dto/response/ticket_detail_dto.dart';
import 'package:ticketflowfront/utils/service_locator.dart';

class TicketDetailsAdminScreen extends StatefulWidget {
  final int ticketId;

  const TicketDetailsAdminScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailsAdminScreen> createState() =>
      _TicketDetailsAdminScreenState();
}

class _TicketDetailsAdminScreenState extends State<TicketDetailsAdminScreen>
    with TickerProviderStateMixin {
  TicketDetailDTO? _ticketDetails;
  bool _isLoading = true;
  String? _error;

  final TextEditingController _solutionController = TextEditingController();
  String _selectedStatus = 'em aberto';

  
  late final AnimationController _fadeInController;
  late final AnimationController _pulseController;

  final List<String> _statusOptions = [
      'em aberto',
      'em andamento',
      'concluido',
      'concluído',
      'encerrado',
      'em análise',
      'em desenvolvimento',
      'em testes',
      'em pausa',
    ];

  @override
  void initState() {
    super.initState();
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fetchTicketDetails();
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _pulseController.dispose();
    _solutionController.dispose();
    super.dispose();
  }

  Future<void> _fetchTicketDetails() async {
    try {
      final response = await calledService.getTicketById(widget.ticketId);

      if (response.isSuccess) {
        setState(() {
          _ticketDetails = response.data;
          _selectedStatus = response.data!.step.toLowerCase();
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

  Future<void> _saveChanges() async {
    try {
      setState(() => _isLoading = true);

      
      
      
      
      

      
      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text("Ticket atualizado com sucesso"),
              ],
            ),
            backgroundColor: const Color(0xFF0BC770),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = "Erro ao salvar alterações: $e";
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'em aberto':
        return const Color(0xFF00A3E0); 
      case 'em andamento':
        return const Color(0xFFFFA000); 
      case 'concluido':
        return const Color(0xFF0BC770); 
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Gerenciar Ticket",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF001F3F), 
                Color(0xFF003B6A), 
                Color(0xFF004F7A), 
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        
        Positioned(
          top: -100,
          right: -50,
          child: _animatedOrb(const Color(0xFF00A3E0).withOpacity(0.2)),
        ),
        Positioned(
          bottom: -50,
          left: -80,
          child: _animatedOrb(const Color(0xFF66E0FF).withOpacity(0.15)),
        ),
        
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(color: Colors.black.withOpacity(0.1)),
        ),
      ],
    );
  }

  Widget _animatedOrb(Color color) {
    return ScaleTransition(
      scale: Tween(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      ),
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 100, spreadRadius: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF00A3E0)));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (_ticketDetails == null) {
      return const Center(child: Text("Nenhum dado encontrado"));
    }

    final ticket = _ticketDetails!;

    return FadeTransition(
      opacity: CurvedAnimation(parent: _fadeInController, curve: Curves.easeOut),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _buildHeaderCard(ticket),
            const SizedBox(height: 20),

            
            _sectionLabel("Detalhes"),
            _buildGlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(Icons.category_outlined, "Categoria",
                      "${ticket.areaName} • ${ticket.subcategoryName}"),
                  const Divider(color: Colors.white10, height: 24),
                  const Text(
                    "Descrição",
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ticket.calledDescription,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 15, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            
            if (ticket.suggestionAI != null &&
                ticket.suggestionAI!.isNotEmpty) ...[
              Row(
                children: const [
                  Icon(Icons.auto_awesome, color: Color(0xFF00A3E0), size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Sugestão Inteligente (IA)",
                    style: TextStyle(
                      color: Color(0xFF00A3E0),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00A3E0).withOpacity(0.15),
                      const Color(0xFF00A3E0).withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                      color: const Color(0xFF00A3E0).withOpacity(0.3)),
                ),
                padding: const EdgeInsets.all(16),
                child: MarkdownBody(
                  data: ticket.suggestionAI!,
                  styleSheet:
                      MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: const TextStyle(color: Colors.white, height: 1.4),
                    strong: const TextStyle(
                        color: Color(0xFF66E0FF), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],

            
            _sectionLabel("Painel do Administrador"),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _adminDropdown(),
                  const SizedBox(height: 16),
                  _solutionField(),
                  const SizedBox(height: 24),
                  _saveButton(),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(TicketDetailDTO ticket) {
    Color statusColor = _getStatusColor(ticket.step);

    return _buildGlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: statusColor.withOpacity(0.5)),
                              ),
                              child: Text(
                                ticket.step.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis, 
                                maxLines: 1,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8), 

                          Text(
                            "Ticket #${widget.ticketId}",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
          ),
          const SizedBox(height: 8),
          Text(
            ticket.calledSubject,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.white54),
              const SizedBox(width: 6),
              Text(
                _formatDate(ticket.dateOpen),
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer(
      {required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 10),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _adminDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Alterar Status",
            style: TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedStatus,
              isExpanded: true,
              dropdownColor: const Color(0xFF003B6A), 
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              items: _statusOptions.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Row(
                    children: [
                      Icon(Icons.circle,
                          size: 10, color: _getStatusColor(s)),
                      const SizedBox(width: 10),
                      Text(s.toUpperCase(),
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedStatus = value!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _solutionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Solução / Resposta",
            style: TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: _solutionController,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Descreva a solução técnica...",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.08),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00A3E0)),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A3E0),
          disabledBackgroundColor: const Color(0xFF00A3E0).withOpacity(0.5),
          shadowColor: const Color(0xFF00A3E0).withOpacity(0.4),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : const Text(
                "Salvar Alterações",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year} às "
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}";
  }
}
