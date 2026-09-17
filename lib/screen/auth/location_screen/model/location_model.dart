class LocationSuggestion {
  final String address;
  final double latitude;
  final double longitude;

  const LocationSuggestion({
     required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory LocationSuggestion.fromGeocodeResult(Map<String, dynamic> json) {
    final geometry = json['geometry']['location'] as Map<String, dynamic>;
    return LocationSuggestion(
      address: json['formatted_address'] as String,
      latitude: (geometry['lat'] as num).toDouble(),
      longitude: (geometry['lng'] as num).toDouble(),
    );
  }
}

class LocationPayload {
  final double latitude;
  final double longitude;
  final String? address;

  const LocationPayload({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'location': {
        'type': 'Point',
        'coordinates': [longitude, latitude],
      },
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };
    final trimmed = address?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      map['address'] = trimmed;
    }
    return map;
  }
}