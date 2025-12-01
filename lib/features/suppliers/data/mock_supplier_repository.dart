import '../models/supplier_model.dart';

/// Mock repository for supplier data.
/// 
/// Provides sample supplier data matching the Laravel API structure.
/// This is used for development and testing when the API is not available.
class MockSupplierRepository {
  /// Returns a list of sample suppliers.
  /// 
  /// This method provides mock data that matches the API response format.
  /// In production, this should be replaced with actual API calls.
  static Future<List<SupplierModel>> getSuppliers({
    String? search,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var suppliers = _mockSuppliers;

    // Apply search filter
    if (search != null && search.isNotEmpty) {
      final searchLower = search.toLowerCase();
      suppliers = suppliers.where((supplier) {
        return supplier.name.toLowerCase().contains(searchLower) ||
            (supplier.contact?.toLowerCase().contains(searchLower) ?? false) ||
            (supplier.email?.toLowerCase().contains(searchLower) ?? false) ||
            (supplier.address?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }

    return suppliers;
  }

  /// Returns a single supplier by ID.
  static Future<SupplierModel?> getSupplierById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockSuppliers.firstWhere((supplier) => supplier.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Mock suppliers data matching API structure.
  static final List<SupplierModel> _mockSuppliers = [
    SupplierModel(
      id: 1,
      name: 'ABC Electronics Ltd.',
      contact: '+1-555-0101',
      email: 'contact@abcelectronics.com',
      address: '123 Tech Street, Silicon Valley, CA 94000, USA',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    SupplierModel(
      id: 2,
      name: 'Global Supplies Inc.',
      contact: '+1-555-0202',
      email: 'info@globalsupplies.com',
      address: '456 Commerce Blvd, New York, NY 10001, USA',
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    SupplierModel(
      id: 3,
      name: 'Premium Accessories Co.',
      contact: '+1-555-0303',
      email: 'sales@premiumaccessories.com',
      address: '789 Market Avenue, Los Angeles, CA 90001, USA',
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    SupplierModel(
      id: 4,
      name: 'Tech Solutions Group',
      contact: '+1-555-0404',
      email: 'hello@techsolutions.com',
      address: '321 Innovation Drive, Austin, TX 78701, USA',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    SupplierModel(
      id: 5,
      name: 'Quality Goods Distributors',
      contact: '+1-555-0505',
      email: 'orders@qualitygoods.com',
      address: '654 Wholesale Road, Chicago, IL 60601, USA',
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    SupplierModel(
      id: 6,
      name: 'Direct Import Services',
      contact: '+1-555-0606',
      email: 'contact@directimport.com',
      address: '987 Harbor Way, Seattle, WA 98101, USA',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
    ),
  ];
}

