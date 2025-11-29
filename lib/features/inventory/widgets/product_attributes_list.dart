import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Product attribute item model
class ProductAttribute {
  final String label;
  final String value;

  const ProductAttribute({
    required this.label,
    required this.value,
  });
}

/// Product attributes list widget
class ProductAttributesList extends StatelessWidget {
  final List<ProductAttribute> attributes;

  const ProductAttributesList({
    super.key,
    required this.attributes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          attributes.length,
          (index) {
            final attribute = attributes[index];
            final isLast = index == attributes.length - 1;
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        attribute.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        attribute.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.gray200,
                    indent: 20,
                    endIndent: 20,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

