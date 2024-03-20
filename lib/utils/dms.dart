String toCoordinateNotation(double coord) {
  final degrees = coord.floor();
  final remaining = coord - degrees;
  final minutes = (remaining * 60).floor();
  final seconds = (remaining * 3600).roundToDouble().toStringAsFixed(2);
  final direction = coord >= 0 ? '' : '-';

  return '$direction$degrees° $minutes\' $seconds"';
}
