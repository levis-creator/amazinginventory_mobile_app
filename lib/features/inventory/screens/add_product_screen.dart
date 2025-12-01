import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/responsive_util.dart';
import '../widgets/image_upload_section.dart';
import '../widgets/form_input_field.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/category_dropdown_field.dart';
import '../../../../shared/widgets/add_category_modal.dart';
import '../cubit/add_product_cubit.dart';

/// Add Product screen for creating new inventory items
class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProductCubit()..loadCategories(),
      child: const _AddProductView(),
    );
  }
}

class _AddProductView extends StatefulWidget {
  const _AddProductView();

  @override
  State<_AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<_AddProductView> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _skuController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  String? _imagePath;

  @override
  void dispose() {
    _productNameController.dispose();
    _skuController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  void _showAddCategoryModal() {
    showDialog(
      context: context,
      builder: (context) => AddCategoryModal(
        onCategoryAdded: (category) {
          context.read<AddProductCubit>().addCategory(category);
        },
      ),
    );
  }

  void _handleChooseFile() {
    // TODO: Implement file picker
    setState(() {
      _imagePath = 'selected_image.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveUtil.isSmallScreen(context);
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);

    return BlocListener<AddProductCubit, AddProductState>(
      listener: (context, state) {
        // Handle success
        if (state.isSuccess && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop();
          context.read<AddProductCubit>().reset();
        }

        // Handle errors
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, isSmallScreen),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Form(
                    key: _formKey,
                    child: BlocBuilder<AddProductCubit, AddProductState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Upload Product Image Section
                            ImageUploadSection(
                              onChooseFile: _handleChooseFile,
                              imagePath: _imagePath,
                            ),
                            SizedBox(
                                height: ResponsiveUtil.getLargeSpacing(context)),

                            // Product Name
                            FormInputField(
                              label: 'Product Name *',
                              placeholder: 'e.g., Laptop Computer, T-Shirt',
                              controller: _productNameController,
                              onChanged: (value) {
                                context
                                    .read<AddProductCubit>()
                                    .updateProductName(value);
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Product name is required';
                                }
                                if (value.length > 255) {
                                  return 'Product name must be less than 255 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                                height: ResponsiveUtil.getLargeSpacing(context)),

                            // Category (Full Width with Add Button)
                            CategoryDropdownField(
                              selectedCategoryId: state.selectedCategoryId,
                              categories: state.categories,
                              isLoading: state.isLoadingCategories,
                              onChanged: (value) {
                                context
                                    .read<AddProductCubit>()
                                    .updateCategory(value);
                              },
                              onAddPressed: _showAddCategoryModal,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a category';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                                height: ResponsiveUtil.getLargeSpacing(context)),

                            // SKU
                            FormInputField(
                              label: 'SKU',
                              placeholder:
                                  'Leave empty to auto-generate (e.g., AG000001)',
                              controller: _skuController,
                              onChanged: (value) {
                                context.read<AddProductCubit>().updateSku(value);
                              },
                              validator: (value) {
                                if (value != null && value.length > 255) {
                                  return 'SKU must be less than 255 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                                height: ResponsiveUtil.getLargeSpacing(context)),

                            // Cost Price and Selling Price
                            isSmallScreen
                                ? Column(
                                    children: [
                                      FormInputField(
                                        label: 'Cost Price *',
                                        placeholder: '0.00',
                                        controller: _costPriceController,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        onChanged: (value) {
                                          context
                                              .read<AddProductCubit>()
                                              .updateCostPrice(value);
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Cost price is required';
                                          }
                                          final price = double.tryParse(value);
                                          if (price == null || price < 0) {
                                            return 'Please enter a valid price';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                          height: ResponsiveUtil
                                              .getLargeSpacing(context)),
                                      FormInputField(
                                        label: 'Selling Price *',
                                        placeholder: '0.00',
                                        controller: _sellingPriceController,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        onChanged: (value) {
                                          context
                                              .read<AddProductCubit>()
                                              .updateSellingPrice(value);
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Selling price is required';
                                          }
                                          final price = double.tryParse(value);
                                          if (price == null || price < 0) {
                                            return 'Please enter a valid price';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: FormInputField(
                                          label: 'Cost Price *',
                                          placeholder: '0.00',
                                          controller: _costPriceController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          onChanged: (value) {
                                            context
                                                .read<AddProductCubit>()
                                                .updateCostPrice(value);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Cost price is required';
                                            }
                                            final price = double.tryParse(value);
                                            if (price == null || price < 0) {
                                              return 'Please enter a valid price';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          width: ResponsiveUtil.getSpacing(
                                              context)),
                                      Expanded(
                                        child: FormInputField(
                                          label: 'Selling Price *',
                                          placeholder: '0.00',
                                          controller: _sellingPriceController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          onChanged: (value) {
                                            context
                                                .read<AddProductCubit>()
                                                .updateSellingPrice(value);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Selling price is required';
                                            }
                                            final price = double.tryParse(value);
                                            if (price == null || price < 0) {
                                              return 'Please enter a valid price';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(
                                height: ResponsiveUtil.getLargeSpacing(context)),

                            // Stock Quantity
                            Text(
                              'Stock Quantity',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            QuantitySelector(
                              quantity: state.stock,
                              onAdd: () {
                                context.read<AddProductCubit>().incrementStock();
                              },
                              onRemove: () {
                                context
                                    .read<AddProductCubit>()
                                    .decrementStock();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Save Product Button
              _buildSaveButton(context, isSmallScreen, horizontalPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    final topBarPadding = ResponsiveUtil.getTopBarPadding(context);

    return Container(
      padding: topBarPadding,
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
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                child: Icon(
                  FeatherIcons.arrowLeft,
                  color: AppColors.textPrimary,
                  size: ResponsiveUtil.getIconSize(context, baseSize: 24),
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
                fontSize: ResponsiveUtil.getFontSize(context, baseSize: 20),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Placeholder for symmetry
          SizedBox(width: ResponsiveUtil.getIconSize(context, baseSize: 40)),
        ],
      ),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    bool isSmallScreen,
    double horizontalPadding,
  ) {
    return BlocBuilder<AddProductCubit, AddProductState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(horizontalPadding),
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
            color: state.isSaving
                ? AppColors.metricPurple.withValues(alpha: 0.6)
                : AppColors.metricPurple,
            borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
            child: InkWell(
              onTap: state.isSaving
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AddProductCubit>().saveProduct();
                      }
                    },
              borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 14 : 16,
                ),
                child: state.isSaving
                    ? Center(
                        child: SizedBox(
                          width: ResponsiveUtil.getIconSize(context,
                              baseSize: 20),
                          height: ResponsiveUtil.getIconSize(context,
                              baseSize: 20),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : Text(
                        'Save Product',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              ResponsiveUtil.getFontSize(context, baseSize: 16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
