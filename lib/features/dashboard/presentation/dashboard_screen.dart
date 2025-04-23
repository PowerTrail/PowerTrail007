import 'package:flutter/material.dart';
import 'package:power_grid_04/core/providers/substation_provider.dart';
import 'package:power_grid_04/core/widgets/voltage_gauge.dart';
import 'package:power_grid_04/features/dashboard/presentation/control_panel.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubstationProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Control Dashboard')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VoltageGauge(value: provider.voltage),
            const ControlPanel(),
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.refresh, 'Refresh', Colors.blue),
          _buildActionButton(Icons.history, 'Logs', Colors.green),
          _buildActionButton(Icons.warning, 'Alerts', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
