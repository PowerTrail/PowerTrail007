import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class VoltageGauge extends StatelessWidget {
  final double value;

  const VoltageGauge({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 500,
            ranges: [
              GaugeRange(startValue: 0, endValue: 200, color: Colors.green),
              GaugeRange(startValue: 200, endValue: 400, color: Colors.orange),
              GaugeRange(startValue: 400, endValue: 500, color: Colors.red),
            ],
            pointers: [
              NeedlePointer(
                value: value,
                enableAnimation: true,
                needleColor: Colors.blue,
              ),
            ],
            annotations: [
              GaugeAnnotation(
                widget: Text(
                  '${value.toStringAsFixed(1)} kV',
                  style: const TextStyle(fontSize: 20),
                ),
                positionFactor: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
