import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:substation_control/core/providers/nav_provider.dart';
import 'package:substation_control/core/widgets/substation_card.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Substation Map')),
      body: FlutterMap(
        options: MapOptions(center: LatLng(51.509364, -0.128928), zoom: 13.0),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(51.509364, -0.128928),
                builder:
                    (ctx) => GestureDetector(
                      onTap: () => _showSubstationDialog(context),
                      child: const Icon(
                        Icons.electric_bolt,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSubstationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Substation A-12'),
            content: const SubstationCard(
              name: 'Main Transformer',
              voltage: '220 kV',
              status: 'Online',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<NavProvider>(context, listen: false).changeTab(1);
                },
                child: const Text('Control'),
              ),
            ],
          ),
    );
  }
}
