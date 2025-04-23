import 'package:flutter/material.dart';
import 'package:power_grid_04/core/providers/substation_provider.dart';
import 'package:provider/provider.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = Provider.of<SubstationProvider>(context).alerts;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () => _testNotification(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: _getAlertColor(alert['severity']),
            child: ListTile(
              leading: _getAlertIcon(alert['severity']),
              title: Text(alert['message']),
              subtitle: Text(alert['timestamp']),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getAlertColor(String severity) {
    switch (severity) {
      case 'critical':
        return Colors.red[100]!;
      case 'warning':
        return Colors.orange[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Icon _getAlertIcon(String severity) {
    switch (severity) {
      case 'critical':
        return const Icon(Icons.error, color: Colors.red);
      case 'warning':
        return const Icon(Icons.warning, color: Colors.orange);
      default:
        return const Icon(Icons.info, color: Colors.blue);
    }
  }

  void _testNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test alert notification sent')),
    );
  }
}
