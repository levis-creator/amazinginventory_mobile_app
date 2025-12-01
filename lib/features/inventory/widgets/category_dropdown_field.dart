import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../categories/models/category_model.dart';

/// Category dropdown field with add button
class CategoryDropdownField extends StatelessWidget {
  final int? selectedCategoryId;
  final List<CategoryModel> categories;
  final bool isLoading;
  final Function(int?)? onChanged;
  final VoidCallback? onAddPressed;
  final String? Function(int?)? validator;

  const CategoryDropdownField({
    super.key,
    this.selectedCategoryId,
    required this.categories,
    this.isLoading = false,
    this.onChanged,
    this.onAddPressed,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selectedCategoryId == null && categories.isNotEmpty
                        ? AppColors.error
                        : AppColors.gray300,
                    width: 1,
                  ),
                ),
                child: DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  decoration: InputDecoration(
                    hintText: isLoading
                        ? 'Loading categories...'
                        : 'Select an option',
                    hintStyle: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: isLoading ? null : onChanged,
                  validator: validator,
                  menuMaxHeight: 300,
                  enableFeedback: false,
                  // Prevent any dialogs or modals from appearing
                  autovalidateMode: AutovalidateMode.disabled,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Material(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onAddPressed,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.gray300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    FeatherIcons.plus,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

