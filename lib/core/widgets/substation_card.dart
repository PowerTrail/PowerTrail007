import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';

class SubstationCard extends StatelessWidget {
  final String name;
  final String voltage;
  final String status;
  final String? lastUpdated;
  final double? capacity;
  final VoidCallback? onTap;
  final VoidCallback? onControlTap;

  const SubstationCard({
    super.key,
    required this.name,
    required this.voltage,
    required this.status,
    this.lastUpdated,
    this.capacity,
    this.onTap,
    this.onControlTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOnline = status.toLowerCase() == 'online';
    final theme = Theme.of(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isOnline ? AppColors.success.withAlpha((0.5 * 255).toInt()) : AppColors.danger.withAlpha((0.5 * 255).toInt()),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOnline ? AppColors.success.withAlpha((0.2 * 255).toInt()) : AppColors.danger.withAlpha((0.2 * 255).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isOnline ? Icons.power : Icons.power_off,
                          size: 16,
                          color: isOnline ? AppColors.success : AppColors.danger,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            color: isOnline ? AppColors.success : AppColors.danger,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildInfoRow(
                AppStrings.voltageLabel,
                voltage,
                Icons.electric_bolt,
                theme,
              ),
              if (capacity != null)
                _buildInfoRow(
                  'Capacity',
                  '$capacity MVA',
                  Icons.battery_charging_full,
                  theme,
                ),
              if (lastUpdated != null)
                _buildInfoRow(
                  AppStrings.lastUpdated,
                  lastUpdated!,
                  Icons.update,
                  theme,
                ),
              const SizedBox(height: 16),
              if (onControlTap != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onControlTap,
                    icon: const Icon(Icons.tune),
                    label: const Text('Control Panel'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.primaryColor),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyLarge?.color?.withAlpha((0.7 * 255).toInt()),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}