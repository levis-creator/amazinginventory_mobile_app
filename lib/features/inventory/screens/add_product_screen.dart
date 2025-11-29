import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/image_upload_section.dart';
import '../widgets/form_input_field.dart';
import '../widgets/quantity_selector.dart';

/// Add Product screen for creating new inventory items
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _skuController = TextEditingController();
  final _supplierController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  
  int _quantity = 0;
  String? _imagePath;

  @override
  void dispose() {
    _productNameController.dispose();
    _categoryController.dispose();
    _skuController.dispose();
    _supplierController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  void _handleChooseFile() {
    // TODO: Implement file picker
    setState(() {
      _imagePath = 'selected_image.png';
    });
  }

  void _handleAddStock() {
    setState(() {
      _quantity++;
    });
  }

  void _handleRemoveStock() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _handleSaveProduct() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save product logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product saved successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
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
            
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upload Product Image Section
                      ImageUploadSection(
                        onChooseFile: _handleChooseFile,
                        imagePath: _imagePath,
                      ),
                      const SizedBox(height: 24),
                      
                      // Product Name
                      FormInputField(
                        label: 'Product Name',
                        placeholder: 'Product Name',
                        controller: _productNameController,
                      ),
                      const SizedBox(height: 20),
                      
                      // Category and SKU (Side by Side)
                      Row(
                        children: [
                          Expanded(
                            child: FormInputField(
                              label: 'Category',
                              placeholder: 'Category',
                              controller: _categoryController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FormInputField(
                              label: 'SKU',
                              placeholder: 'SKU-123',
                              controller: _skuController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Quantity Section
                      Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      QuantitySelector(
                        quantity: _quantity,
                        onAdd: _handleAddStock,
                        onRemove: _handleRemoveStock,
                      ),
                      const SizedBox(height: 20),
                      
                      // Supplier Name
                      FormInputField(
                        label: 'Supplier Name',
                        placeholder: 'Supplier Name',
                        controller: _supplierController,
                      ),
                      const SizedBox(height: 20),
                      
                      // Selling Price
                      FormInputField(
                        label: 'Selling Price',
                        placeholder: 'Selling Price',
                        controller: _sellingPriceController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            
            // Save Product Button
            _buildSaveButton(),
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
              'Add Product',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          
          // Edit Icon
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Handle edit action
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  FeatherIcons.edit,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
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
      child: Material(
        color: AppColors.metricPurple,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: _handleSaveProduct,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              'Save Product',
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
    );
  }
}

