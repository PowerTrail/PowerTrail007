import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/substation_model.dart';
import '../../../core/services/supabase_service.dart';
import '../../substation/presentation/substation_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _EnhancedMapScreenState();
}

class _EnhancedMapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final SupabaseService _supabaseService = SupabaseService();
  
  List<SubstationModel> _substations = [];
  List<SubstationModel> _filteredSubstations = [];
  String _selectedFilter = 'All';
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadSubstations();
  }
  
  Future<void> _loadSubstations() async {
    setState(() => _isLoading = true);
    
    try {
      // Perform async operation
      final substationsData = await _supabaseService.getSubstations();
      
      // After the await, check if still mounted before setState
      if (!mounted) return;
      
      setState(() {
        _substations = substationsData
            .map((data) => SubstationModel.fromJson(data))
            .toList();
        _filteredSubstations = _substations;
        _isLoading = false;
      });
    } catch (e) {
      // After the await, check if still mounted before setState
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      
      // Now we can use context safely
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load substations: $e')),
      );
    }
  }
  
  void _filterSubstations(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredSubstations = _substations;
      });
      return;
    }
    
    setState(() {
      _filteredSubstations = _substations
          .where((substation) =>
              (substation.name?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (substation.district?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (substation.voltageLevel?.toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();
    });
  }
  
  void _applyTypeFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      
      if (filter == 'All') {
        _filteredSubstations = _substations;
      } else {
        _filteredSubstations = _substations
            .where((substation) => substation.type == filter)
            .toList();
      }
    });
  }
  
  void _navigateToSubstation(SubstationModel substation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubstationDetailScreen(substation: substation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use Gujarat's approximate center coordinates
    final LatLng gujaratCenter = const LatLng(22.2587, 71.1924);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Power Grid Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSubstations,
          ),
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search substations...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterSubstations('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterSubstations,
            ),
          ),
          _buildFilterChips(),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: gujaratCenter,
                    initialZoom: 7.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: _filteredSubstations.map((substation) {
                        return Marker(
                          point: LatLng(substation.latitude, substation.longitude),
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () => _showSubstationPopup(substation),
                            child: _buildMarkerIcon(substation),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                if (_isLoading)
                  const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoomIn',
                        child: const Icon(Icons.add),
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom + 1,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoomOut',
                        child: const Icon(Icons.remove),
                        onPressed: () {
                          _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom - 1,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'centerMap',
                        child: const Icon(Icons.my_location),
                        onPressed: () {
                          _mapController.move(gujaratCenter, 7.0);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChips() {
    final filters = ['All', 'Substation', 'Solar', 'Wind', 'Hybrid'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              checkmarkColor: Colors.white,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
              onSelected: (_) => _applyTypeFilter(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildMarkerIcon(SubstationModel substation) {
    IconData icon;
    Color color;
    
    switch (substation.type) {
      case 'Solar':
        icon = Icons.solar_power;
        color = Colors.orange;
        break;
      case 'Wind':
        icon = Icons.air;
        color = Colors.blue;
        break;
      case 'Hybrid':
        icon = Icons.gradient;
        color = Colors.purple;
        break;
      default: // Substation
        icon = Icons.electric_bolt;
        color = substation.isOnline ? AppColors.success : AppColors.danger;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(138),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
  
  void _showSubstationPopup(SubstationModel substation) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              substation.name ?? 'Unknown Substation',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.electric_bolt),
              title: Text('Voltage: ${substation.voltageLevel ?? 'Unknown'}'),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text('District: ${substation.district ?? 'Unknown'}'),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text('Close'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View Details'),
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToSubstation(substation);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Map Layers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Substations'),
              value: true,
              onChanged: (_) {},
            ),
            SwitchListTile(
              title: const Text('Solar Plants'),
              value: true,
              onChanged: (_) {},
            ),
            SwitchListTile(
              title: const Text('Wind Farms'),
              value: false,
              onChanged: (_) {},
            ),
            SwitchListTile(
              title: const Text('Transmission Lines'),
              value: false,
              onChanged: (_) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Apply filters
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}