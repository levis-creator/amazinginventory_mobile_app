/// Supplier model representing suppliers in the inventory system.
///
/// This data class represents a supplier that provides products
/// to the inventory.
class SupplierModel {
  /// Unique identifier for the supplier
  final int id;

  /// Supplier name
  final String name;

  /// Contact phone number
  final String? contact;

  /// Supplier email address
  final String? email;

  /// Supplier address
  final String? address;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  /// Creates a new [SupplierModel] instance.
  SupplierModel({
    required this.id,
    required this.name,
    this.contact,
    this.email,
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a [SupplierModel] from JSON data (API response).
  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] as int,
      name: json['name'] as String,
      contact: json['contact'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'email': email,
      'address': address,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a copy of this model with updated fields.
  SupplierModel copyWith({
    int? id,
    String? name,
    String? contact,
    String? email,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
