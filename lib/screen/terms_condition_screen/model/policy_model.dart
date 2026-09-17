class TermsAndConditionsModel {
  final String? id;
  final String type;
  final int? version;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TermsAndConditionsModel({
    this.id,
    required this.type,
    this.version,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create instance from JSON
  factory TermsAndConditionsModel.fromJson(Map<String, dynamic> json) {
    return TermsAndConditionsModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      version: json['__v'] ?? 0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }


  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      '__v': version,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Method to create copy with updated values
  TermsAndConditionsModel copyWith({
    String? id,
    String? type,
    int? version,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TermsAndConditionsModel(
      id: id ?? this.id,
      type: type ?? this.type,
      version: version ?? this.version,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TermsAndConditionsModel(id: $id, type: $type, version: $version, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TermsAndConditionsModel &&
        other.id == id &&
        other.type == type &&
        other.version == version &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    type.hashCode ^
    version.hashCode ^
    content.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode;
  }
}

// API Response wrapper class
class TermsAndConditionsResponse {
  final TermsAndConditionsModel data;

  TermsAndConditionsResponse({required this.data});

  factory TermsAndConditionsResponse.fromJson(Map<String, dynamic> json) {
    return TermsAndConditionsResponse(
      data: TermsAndConditionsModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}