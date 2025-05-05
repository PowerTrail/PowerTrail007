import 'package:flutter/material.dart';
import '../../../core/providers/substation_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = Provider.of<SubstationProvider>(context).actionLogs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Operation History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: logs.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final log = logs[index];
          final timestamp = log['timestamp'];

          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(log['action']),
            subtitle: Text(
              timestamp != null
                  ? _formatDateTime(DateTime.parse(timestamp.toString()))
                  : 'Unknown time',
            ),
            trailing: Chip(
              label: Text(log['status'] ?? 'Completed'),
              backgroundColor: _getStatusColor(log['status']),
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return DateFormat('hh:mm a, dd MMM yyyy').format(dt);
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Filter Logs'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterOption('All', context),
                _buildFilterOption('Today', context),
                _buildFilterOption('This Week', context),
              ],
            ),
          ),
    );
  }

  Widget _buildFilterOption(String text, BuildContext context) {
    return ListTile(
      title: Text(text),
      onTap: () {
        Navigator.pop(context);
        // Implement filter logic here
      },
    );
  }
}
