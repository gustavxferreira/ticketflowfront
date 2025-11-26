import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketflowfront/dto/response/ticket_admin_dto.dart';

class TicketCardAdmin extends StatelessWidget {
  final TicketAdminDTO ticket;

  const TicketCardAdmin({super.key, required this.ticket});

  Color _getStatusColor(String step) {
    switch (step.toLowerCase()) {
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
    final statusColor = _getStatusColor(ticket.step);
    final dateFormat = DateFormat('dd/MM HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),

          onTap: () {
            Navigator.pushNamed(
              context,
              '/ticket-details-admin',
              arguments: ticket.id,
            );
          },

          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                                     
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: statusColor.withOpacity(0.5)),
                                          ),
                                          child: Text(
                                            "#${ticket.id} • ${ticket.step.toUpperCase()}", 
                                            style: TextStyle(
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis, 
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      Text(
                                        dateFormat.format(ticket.dateOpen),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                ),
                const SizedBox(height: 12),
                Text(
                  ticket.calledSubject,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.folder_open, size: 14, color: Colors.white.withOpacity(0.6)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${ticket.areaName} > ${ticket.subcategoryName}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
