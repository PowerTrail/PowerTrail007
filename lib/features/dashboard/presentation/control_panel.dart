import 'package:flutter/material.dart';
import 'package:power_grid_04/core/providers/substation_provider.dart';
import 'package:provider/provider.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubstationProvider>(context);
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('CONTROL PANEL', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Power Supply'),
              value: provider.isOnline,
              onChanged: (value) => provider.toggleStatus(),
            ),
            const SizedBox(height: 16),
            const Text('Voltage Adjustment'),
            Slider(
              value: provider.voltage,
              min: 0,
              max: 500,
              divisions: 10,
              label: '${provider.voltage.round()} kV',
              onChanged: (value) => provider.setVoltage(value),
            ),
          ],
        ),
      ),
    );
  }
}
