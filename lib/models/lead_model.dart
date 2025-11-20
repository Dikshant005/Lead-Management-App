class Lead {
  final int? id;
  final String name;
  final String contact;
  final String status; // New, Contacted, Converted, Lost
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lead({
    this.id,
    required this.name,
    required this.contact,
    required this.status,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert Lead to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create Lead from Map
  factory Lead.fromMap(Map<String, dynamic> map) {
    return Lead(
      id: map['id'],
      name: map['name'],
      contact: map['contact'],
      status: map['status'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Create copy with updated fields
  Lead copyWith({
    int? id,
    String? name,
    String? contact,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
