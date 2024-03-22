import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:pocket_quake/model/station_intensity.dart';
import 'package:pocket_quake/utils/intensity_color.dart';

class IntensityBadge extends StatelessWidget {
  final String name;
  final StationIntensity station;

  const IntensityBadge({super.key, required this.name, required this.station});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
                color: theme.colorScheme.intensity(station.intensity)),
            color: theme.colorScheme
                .intensity(station.intensity)
                .harmonizeWith(theme.colorScheme.primary)
                .withOpacity(0.16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: theme.colorScheme.intensity(station.intensity)),
                child: Center(
                    child: Text(station.intensity.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme
                                .onIntensity(station.intensity))))),
            Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 12, 0),
                child: Text(name,
                    style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 14))),
          ],
        ));
  }
}
