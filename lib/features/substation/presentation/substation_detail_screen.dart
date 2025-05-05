import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/substation_model.dart';
import '../../../core/providers/substation_provider.dart';
import '../../../core/widgets/model_viewer.dart';
import '../../../core/widgets/voltage_gauge.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class SubstationDetailScreen extends StatefulWidget {
  final SubstationModel substation;

  const SubstationDetailScreen({
    super.key,
    required this.substation,
  });

  @override
  State<SubstationDetailScreen> createState() => _SubstationDetailScreenState();
}

class _SubstationDetailScreenState extends State<SubstationDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubstationProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.substation.name ?? 'Substation Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusBar(provider),
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicator: MaterialIndicator(
              height: 4,
              topLeftRadius: 8,
              topRightRadius: 8,
              color: AppColors.primary,
              horizontalPadding: 30,
            ),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: '3D Model'),
              Tab(text: 'Analytics'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(provider),
                _build3DModelTab(),
                _buildAnalyticsTab(provider),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showControlPanel(context, provider),
        icon: const Icon(Icons.power_settings_new),
        label: const Text('Control Panel'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildStatusBar(SubstationProvider provider) {
    final isOnline = provider.isOnline;
    
    return Container(
      color: isOnline ? AppColors.success.withAlpha(25) : AppColors.danger.withAlpha(25),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isOnline ? AppColors.success : AppColors.danger,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isOnline ? AppColors.success : AppColors.danger,
            ),
          ),
          const Spacer(),
          const Icon(Icons.access_time, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            'Last updated: ${_formatTime(DateTime.now())}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(SubstationProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(provider),
          const SizedBox(height: 16),
          Text(
            'Key Parameters',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildParametersGrid(provider),
          const SizedBox(height: 16),
          Text(
            'Location',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildLocationCard(),
          const SizedBox(height: 16),
          Text(
            'Recent Activities',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          _buildRecentActivities(provider),
        ],
      ),
    );
  }

  Widget _buildInfoCard(SubstationProvider provider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.substation.name ?? 'Unknown Substation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('District', widget.substation.district ?? 'Unknown'),
            _buildInfoRow('Voltage Level', widget.substation.voltageLevel ?? 'Unknown'),
            if (widget.substation.commissioningDate != null)
              _buildInfoRow(
                'Commissioned',
                _formatDate(widget.substation.commissioningDate!),
              ),
            if (widget.substation.transformerCapacity != null)
              _buildInfoRow(
                'Transformer Capacity',
                '${widget.substation.transformerCapacity} MVA',
              ),
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
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildParametersGrid(SubstationProvider provider) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildParameterCard(
          'Voltage',
          '${provider.voltage.toStringAsFixed(1)} kV',
          Icons.electric_bolt,
          Colors.blue,
        ),
        _buildParameterCard(
          'Current',
          '${(provider.voltage / 2).toStringAsFixed(1)} A',
          Icons.bolt,
          Colors.amber,
        ),
        _buildParameterCard(
          'Power',
          '${(provider.voltage * 50).toStringAsFixed(0)} MW',
          Icons.power,
          Colors.green,
        ),
        _buildParameterCard(
          'Temperature',
          '${(30 + (provider.voltage / 20)).toStringAsFixed(1)}°C',
          Icons.thermostat,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildParameterCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.red),
            title: Text(widget.substation.district ?? 'Unknown District'),
            subtitle: Text(
              'Lat: ${widget.substation.latitude.toStringAsFixed(4)}, '
              'Long: ${widget.substation.longitude.toStringAsFixed(4)}',
            ),
            trailing: ElevatedButton.icon(
              icon: const Icon(Icons.directions, size: 16),
              label: const Text('Directions'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Icon(Icons.map, size: 50, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(SubstationProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.actionLogs.length.clamp(0, 3),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final log = provider.actionLogs[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.history, color: Colors.white, size: 16),
            ),
            title: Text(log['action'] as String),
            subtitle: Text(_formatTime(DateTime.now())),
            dense: true,
          );
        },
      ),
    );
  }

  Widget _build3DModelTab() {
    // Use our simplified model viewer widget
    return SubstationModelViewer(substation: widget.substation);
  }

  Widget _buildAnalyticsTab(SubstationProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Voltage Trends',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: VoltageGauge(value: provider.voltage),
          ),
          const SizedBox(height: 24),
          Text(
            'Performance Metrics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildPerformanceMetrics(),
          const SizedBox(height: 24),
          Text(
            'Alert History',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildAlertHistory(provider),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    final metrics = [
      {'title': 'Uptime', 'value': '99.8%', 'icon': Icons.access_time},
      {'title': 'Efficiency', 'value': '97.2%', 'icon': Icons.bolt},
      {'title': 'Load Factor', 'value': '76.5%', 'icon': Icons.speed},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: metrics.map((metric) {
            return Column(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withAlpha(25),
                  child: Icon(
                    metric['icon'] as IconData,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  metric['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  metric['value'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAlertHistory(SubstationProvider provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.alerts.length.clamp(0, 3),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final alert = provider.alerts[index];
          IconData icon;
          Color color;
          
          switch (alert['severity']) {
            case 'critical':
              icon = Icons.error;
              color = Colors.red;
              break;
            case 'warning':
              icon = Icons.warning;
              color = Colors.orange;
              break;
            default:
              icon = Icons.info;
              color = Colors.blue;
          }
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withAlpha(50),
              child: Icon(icon, color: color, size: 16),
            ),
            title: Text(alert['message'] as String),
            subtitle: Text(alert['timestamp'] as String),
            dense: true,
          );
        },
      ),
    );
  }

  void _showControlPanel(BuildContext context, SubstationProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'CONTROL PANEL',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              title: const Text('Main Power'),
              subtitle: Text(provider.isOnline ? 'Online' : 'Offline'),
              value: provider.isOnline,
              onChanged: (value) {
                provider.toggleStatus();
                Navigator.pop(context);
              },
              secondary: Icon(
                Icons.power_settings_new,
                color: provider.isOnline ? Colors.green : Colors.red,
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Voltage Adjustment'),
              subtitle: Text('${provider.voltage.toStringAsFixed(1)} kV'),
              leading: const Icon(Icons.electric_bolt),
            ),
            Slider(
              value: provider.voltage,
              min: 0,
              max: 500,
              divisions: 50,
              label: '${provider.voltage.round()} kV',
              onChanged: (value) => provider.setVoltage(value),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  'Reset',
                  Icons.restore,
                  Colors.orange,
                  () {
                    provider.setVoltage(220.0);
                    Navigator.pop(context);
                  },
                ),
                _buildControlButton(
                  'Emergency Off',
                  Icons.power_off,
                  Colors.red,
                  () {
                    if (provider.isOnline) provider.toggleStatus();
                    Navigator.pop(context);
                  },
                ),
                _buildControlButton(
                  'Apply',
                  Icons.check_circle,
                  Colors.green,
                  () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Substation Info'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to Bookmarks'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('View Full History'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download Reports'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}