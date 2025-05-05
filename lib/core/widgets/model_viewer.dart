import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../constants/colors.dart';
import '../models/substation_model.dart';
import '../providers/substation_provider.dart';
import 'package:provider/provider.dart';

class SubstationModelViewer extends StatefulWidget {
  final SubstationModel substation;

  const SubstationModelViewer({
    super.key,
    required this.substation,
  });

  @override
  State<SubstationModelViewer> createState() => _SubstationModelViewerState();
}

class _SubstationModelViewerState extends State<SubstationModelViewer> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    // Simulate loading completion after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final substationProvider = Provider.of<SubstationProvider>(context);
    
    return Stack(
      children: [
        // Basic ModelViewer without JavaScript channels
        ModelViewer(
          src: 'assets/models/substation.glb',
          alt: 'A 3D model of a substation',
          ar: false,
          autoRotate: true,
          cameraControls: true,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        ),
        
        // Loading indicator
        if (_isLoading)
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading 3D model...'),
              ],
            ),
          ),
          
        // Instructions overlay  
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(138),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Tap and drag to rotate. Pinch to zoom.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        
        // Control buttons
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.small(
                heroTag: 'resetView',
                onPressed: () {
                  // Simple reload approach
                  setState(() {
                    _isLoading = true;
                  });
                  Future.delayed(const Duration(seconds: 1), () {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  });
                },
                child: const Icon(Icons.refresh),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'togglePower',
                backgroundColor: substationProvider.isOnline ? AppColors.success : AppColors.danger,
                onPressed: () => substationProvider.toggleStatus(),
                child: Icon(substationProvider.isOnline ? Icons.power : Icons.power_off),
              ),
            ],
          ),
        ),
      ],
    );
  }
}