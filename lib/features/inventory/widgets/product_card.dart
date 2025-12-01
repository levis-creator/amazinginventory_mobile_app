import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/responsive_util.dart';
import '../models/product_model.dart';
import '../screens/product_details_screen.dart';

/// Product card widget displaying inventory item information.
/// 
/// This widget displays a product in a card format with:
/// - Product image (80x80, placeholder for now)
/// - Product name and SKU
/// - Stock quantity and change percentage
/// - Status badge (In Stock, Low Stock, or Out of Stock)
/// 
/// Tapping the card navigates to the [ProductDetailsScreen].
/// 
/// The card uses Material InkWell for tap feedback and follows
/// the consistent design pattern used across the app.
/// 
/// Example:
/// ```dart
/// ProductCard(
///   product: productModel,
/// )
/// ```
class ProductCard extends StatelessWidget {
  /// The product model to display
  final ProductModel product;

  /// Creates a new [ProductCard] widget.
  /// 
  /// [product] is required.
  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveUtil.getCardPadding(context);
    final imageSize = ResponsiveUtil.getContainerSize(context, baseSize: 80);
    final nameFontSize = ResponsiveUtil.getFontSize(context, baseSize: 16);
    final skuFontSize = ResponsiveUtil.getFontSize(context, baseSize: 13);
    final stockFontSize = ResponsiveUtil.getFontSize(context, baseSize: 14);
    final spacing = ResponsiveUtil.getSpacing(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: product),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: EdgeInsets.only(bottom: spacing - 4),
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildProductImage(context),
            ),
          ),
          SizedBox(width: spacing),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ResponsiveUtil.isSmallScreen(context) ? 4 : 6),
                
                // SKU
                Text(
                  product.sku,
                  style: TextStyle(
                    fontSize: skuFontSize,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: spacing - 4),
                
                // Stock and Change
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${product.stock} in Stock',
                        style: TextStyle(
                          fontSize: stockFontSize,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (product.stockChangePercent != 0) ...[
                      SizedBox(width: ResponsiveUtil.isSmallScreen(context) ? 4 : 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FeatherIcons.arrowDown,
                            size: ResponsiveUtil.getIconSize(context, baseSize: 14),
                            color: AppColors.error,
                          ),
                          SizedBox(width: ResponsiveUtil.isSmallScreen(context) ? 1 : 2),
                          Text(
                            '${product.stockChangePercent.abs().toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: ResponsiveUtil.getFontSize(context, baseSize: 12),
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Status Badge
          _buildStatusBadge(context),
        ],
      ),
        ),
      ),
    );
  }

  /// Builds the product image widget.
  /// 
  /// Currently displays a placeholder icon. In production, this should
  /// use [Image.network] or [Image.asset] to display the actual product image.
  Widget _buildProductImage(BuildContext context) {
    // Placeholder for product image
    // In production, use Image.network or Image.asset
    return Container(
      color: AppColors.gray200,
      child: Icon(
        FeatherIcons.image,
        color: AppColors.gray400,
        size: ResponsiveUtil.getIconSize(context, baseSize: 40),
      ),
    );
  }

  /// Builds the status badge based on product stock status.
  /// 
  /// Returns a colored badge indicating:
  /// - In Stock: Green badge
  /// - Low Stock: Yellow/Amber badge
  /// - Out of Stock: Red badge
  Widget _buildStatusBadge(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (product.status) {
      case StockStatus.inStock:
        backgroundColor = AppColors.successLight;
        textColor = AppColors.success;
        label = 'In Stock';
        break;
      case StockStatus.lowStock:
        backgroundColor = AppColors.warningLight;
        textColor = AppColors.warning;
        label = 'Low Stock';
        break;
      case StockStatus.outOfStock:
        backgroundColor = AppColors.errorLight;
        textColor = AppColors.error;
        label = 'Out of Stock';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtil.isSmallScreen(context) ? 10 : 12,
        vertical: ResponsiveUtil.isSmallScreen(context) ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveUtil.getFontSize(context, baseSize: 12),
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

