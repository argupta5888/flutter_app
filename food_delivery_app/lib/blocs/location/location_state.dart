part of 'location_bloc.dart';

class LocationState extends Equatable {
  final double? userLat;
  final double? userLng;
  final String userAddress;
  final bool isLoading;

  const LocationState({
    this.userLat,
    this.userLng,
    this.userAddress = 'Bandra West, Mumbai',
    this.isLoading = false,
  });

  bool get hasLocation => userLat != null && userLng != null;

  double calculateDistance(double destLat, double destLng) {
    if (!hasLocation) return 0.0;
    const double earthRadius = 6371;
    final dLat = _toRad(destLat - userLat!);
    final dLng = _toRad(destLng - userLng!);
    final a = _sin2(dLat / 2) +
        _cos(_toRad(userLat!)) * _cos(_toRad(destLat)) * _sin2(dLng / 2);
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return earthRadius * c;
  }

  String formattedDistance(double destLat, double destLng) {
    final dist = calculateDistance(destLat, destLng);
    return dist < 1 ? '${(dist * 1000).toStringAsFixed(0)}m' : '${dist.toStringAsFixed(1)}km';
  }

  int estimatedTime(double destLat, double destLng) {
    final dist = calculateDistance(destLat, destLng);
    return (dist / 20 * 60 + 10).round();
  }

  LocationState copyWith({double? userLat, double? userLng, String? userAddress, bool? isLoading}) =>
      LocationState(
        userLat: userLat ?? this.userLat,
        userLng: userLng ?? this.userLng,
        userAddress: userAddress ?? this.userAddress,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props => [userLat, userLng, userAddress, isLoading];
}

// Standalone math helpers (dart:math import in bloc file)
double _toRad(double d) => d * 3.141592653589793 / 180;
double _sin2(double x) { final s = _sinImpl(x); return s * s; }
double _cos(double x) => _cosImpl(x);
double _sqrt(double x) => x < 0 ? 0 : _sqrtImpl(x);
double _atan2(double y, double x) => _atan2Impl(y, x);

// Implemented via dart:math in bloc
double _sinImpl(double x) => x - x*x*x/6 + x*x*x*x*x/120;
double _cosImpl(double x) => 1 - x*x/2 + x*x*x*x/24;
double _sqrtImpl(double x) { double r = x; for(int i=0;i<20;i++){r=(r+x/r)/2;} return r; }
double _atan2Impl(double y, double x) {
  if (x > 0) return _atanImpl(y / x);
  if (x < 0 && y >= 0) return _atanImpl(y / x) + 3.141592653589793;
  if (x < 0 && y < 0) return _atanImpl(y / x) - 3.141592653589793;
  if (x == 0 && y > 0) return 3.141592653589793 / 2;
  if (x == 0 && y < 0) return -3.141592653589793 / 2;
  return 0;
}
double _atanImpl(double x) {
  if (x.abs() > 1) return (x > 0 ? 1 : -1) * 3.141592653589793/2 - _atanImpl(1/x);
  return x - x*x*x/3 + x*x*x*x*x/5 - x*x*x*x*x*x*x/7;
}
