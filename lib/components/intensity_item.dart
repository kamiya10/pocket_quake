import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:pocket_quake/model/station_intensity.dart';
import 'package:pocket_quake/utils/extensions.dart';
import 'package:pocket_quake/utils/intensity_color.dart';

class IntensityBadge extends StatelessWidget {
  final String name;
  final StationIntensity station;

  const IntensityBadge({super.key, required this.name, required this.station});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: context.colors.intensity(station.intensity),
        ),
        color: context.colors
            .intensity(station.intensity)
            .harmonizeWith(context.colors.primary)
            .withOpacity(0.16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: context.colors.intensity(station.intensity),
            ),
            child: Center(
              child: Text(
                station.intensity.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.colors.onIntensity(station.intensity),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 12, 0),
            child: Text(
              name,
              style: TextStyle(
                color: context.colors.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
