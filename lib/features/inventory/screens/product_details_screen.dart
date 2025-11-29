import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/product_image_section.dart';
import '../widgets/product_info_section.dart';
import '../widgets/product_attributes_list.dart';
import '../models/product_model.dart';

/// Product Details screen displaying full product information
class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.product.stock;
  }

  void _handleAddStock() {
    setState(() {
      _currentQuantity++;
    });
    // TODO: Update product stock via API
  }

  void _handleRemoveStock() {
    if (_currentQuantity > 0) {
      setState(() {
        _currentQuantity--;
      });
      // TODO: Update product stock via API
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ProductImageSection(
                      imageUrl: widget.product.imageUrl,
                      productName: widget.product.name,
                    ),
                    
                    // Product Info
                    ProductInfoSection(
                      productName: widget.product.name,
                      rating: widget.product.rating ?? 4.5,
                      sku: widget.product.sku,
                      changePercent: widget.product.stockChangePercent != 0
                          ? widget.product.stockChangePercent.abs().toStringAsFixed(0)
                          : null,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Product Attributes
                    ProductAttributesList(
                      attributes: [
                        ProductAttribute(
                          label: 'Quantity',
                          value: _currentQuantity.toString(),
                        ),
                        ProductAttribute(
                          label: 'Category',
                          value: widget.product.category ?? 'N/A',
                        ),
                        ProductAttribute(
                          label: 'Selling Price',
                          value: widget.product.sellingPrice != null
                              ? '\$${widget.product.sellingPrice!.toStringAsFixed(2)}'
                              : 'N/A',
                        ),
                        ProductAttribute(
                          label: 'Purchase Price',
                          value: widget.product.purchasePrice != null
                              ? '\$${widget.product.purchasePrice!.toStringAsFixed(2)}'
                              : 'N/A',
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: AppColors.cardBackground,
      child: Row(
        children: [
          // Back Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  FeatherIcons.arrowLeft,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
          
          // Title
          Expanded(
            child: Text(
              'Product Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          
          // Spacer for symmetry
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Add Stock Button
          Expanded(
            child: Material(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _handleAddStock,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text(
                    'Add Stock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Remove Stock Button
          Expanded(
            child: Material(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _handleRemoveStock,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text(
                    'Remove Stock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

