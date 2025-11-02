import 'package:flutter/material.dart';
import '../models/chamado.dart';

class ChamadoTile extends StatelessWidget {
  final Chamado chamado;

  const ChamadoTile({required this.chamado});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chamado.subject),
      subtitle: Text(chamado.description),
      leading: CircleAvatar(child: Text(chamado.id.toString())),
    );
  }
}
