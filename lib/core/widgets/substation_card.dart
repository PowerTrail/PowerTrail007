import 'package:flutter/material.dart';
import 'package:substation_control/core/constants/strings.dart';

class SubstationCard extends StatelessWidget {
  final String name;
  final String voltage;
  final String status;
  final String? lastUpdated;

  const SubstationCard({
    super.key,
    required this.name,
    required this.voltage,
    required this.status,
    this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _buildInfoRow(AppStrings.voltageLabel, voltage),
            _buildInfoRow(AppStrings.powerStatus, status),
            if (lastUpdated != null)
              _buildInfoRow(AppStrings.lastUpdated, lastUpdated!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
