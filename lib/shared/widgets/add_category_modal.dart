import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/utils/responsive_util.dart';
import '../../features/inventory/widgets/form_input_field.dart';
import '../../features/categories/models/category_model.dart';

/// Reusable modal dialog for adding a new category
/// Can be used from product forms, category list screens, etc.
class AddCategoryModal extends StatefulWidget {
  /// Callback when a category is successfully added
  final Function(CategoryModel)? onCategoryAdded;
  
  /// Optional title for the modal (defaults to "Add Category")
  final String? title;

  const AddCategoryModal({
    super.key,
    this.onCategoryAdded,
    this.title,
  });

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      // TODO: Replace with actual API call
      // final categoryData = {
      //   'name': _nameController.text.trim(),
      //   'description': _descriptionController.text.trim().isEmpty
      //       ? null
      //       : _descriptionController.text.trim(),
      //   'is_active': _isActive,
      // };
      // 
      // final category = await categoryRepository.createCategory(categoryData);
      
      // Mock category for now
      final category = CategoryModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        isActive: true, // Default to active
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (mounted) {
        widget.onCategoryAdded?.call(category);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category added successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add category: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveUtil.isSmallScreen(context);
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);
    final verticalPadding = ResponsiveUtil.getVerticalPadding(context);
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isSmallScreen ? 12 : 20),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isSmallScreen ? double.infinity : 500,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.gray300,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title ?? 'Add Category',
                      style: TextStyle(
                        fontSize: ResponsiveUtil.getFontSize(context, baseSize: 20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                        child: Icon(
                          FeatherIcons.x,
                          color: AppColors.textPrimary,
                          size: ResponsiveUtil.getIconSize(context, baseSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Name
                      FormInputField(
                        label: 'Category Name *',
                        placeholder: 'e.g., Electronics, Clothing, Food',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Category name is required';
                          }
                          if (value.length > 255) {
                            return 'Category name must be less than 255 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: ResponsiveUtil.getLargeSpacing(context)),
                      
                      // Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: ResponsiveUtil.getFontSize(context, baseSize: 14),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: ResponsiveUtil.getSpacing(context)),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: isSmallScreen ? 3 : 4,
                            maxLength: 1000,
                            decoration: InputDecoration(
                              hintText: 'Enter a description for this category',
                              hintStyle: TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: ResponsiveUtil.getFontSize(context, baseSize: 14),
                              ),
                              filled: true,
                              fillColor: AppColors.cardBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
                                borderSide: BorderSide(
                                  color: AppColors.gray300,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
                                borderSide: BorderSide(
                                  color: AppColors.gray300,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
                                borderSide: BorderSide(
                                  color: AppColors.metricPurple,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 16,
                                vertical: isSmallScreen ? 12 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer Buttons
            Container(
              padding: EdgeInsets.all(horizontalPadding),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.gray300,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 12 : 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.gray300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
                          ),
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: ResponsiveUtil.getFontSize(context, baseSize: 16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtil.getSpacing(context)),
                  Expanded(
                    child: Material(
                      color: _isSaving
                          ? AppColors.metricPurple.withValues(alpha: 0.6)
                          : AppColors.metricPurple,
                      borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
                      child: InkWell(
                        onTap: _isSaving ? null : _handleSave,
                        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 12 : 14,
                          ),
                          child: _isSaving
                              ? Center(
                                  child: SizedBox(
                                    width: ResponsiveUtil.getIconSize(context, baseSize: 20),
                                    height: ResponsiveUtil.getIconSize(context, baseSize: 20),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  'Save Category',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveUtil.getFontSize(context, baseSize: 16),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

