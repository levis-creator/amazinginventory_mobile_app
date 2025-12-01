import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feather_icons/feather_icons.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'core/services/navigation_service.dart';
import 'features/inventory/screens/add_product_screen.dart';

/// Main entry point of the Amazing Inventory Flutter application.
///
/// Initializes the app with:
/// - System UI configuration (edge-to-edge mode)
/// - Theme setup
/// - Navigation service registration
///
/// The app uses a bottom navigation bar with 4 tabs:
/// - Home (Dashboard)
/// - Inventory (Products)
/// - Notifications
/// - More (Modules list)
///
/// A floating action button in the center provides quick actions.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Enable edge-to-edge mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

/// Root widget of the application.
///
/// Manages:
/// - Bottom navigation bar state
/// - Tab navigation
/// - Floating action button menu
/// - Navigation service callback registration
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// State class for the main application widget.
///
/// Handles:
/// - Current tab index management
/// - Current module screen identifier
/// - Floating action button menu state
/// - Button rotation animation
/// - Navigation service integration
class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  /// Current active tab index (0-3)
  int _currentIndex = AppConstants.homeIndex;

  /// Current module screen identifier (null when showing modules list)
  String? _currentModuleId;

  /// Whether the floating action button menu is open
  bool _isMenuOpen = false;

  /// Animation controller for the floating action button rotation
  AnimationController? _buttonAnimationController;

  /// Rotation animation for the floating action button (0 to 45 degrees)
  Animation<double>? _buttonRotationAnimation;

  /// Scaffold context stored for use in modal bottom sheets
  BuildContext? _scaffoldContext;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Register navigation service callbacks for decoupled navigation
    NavigationService.instance.onTabChanged = (index) {
      setState(() {
        // If tapping More tab while already on More tab with a module, go back to modules list
        if (index == AppConstants.moreIndex &&
            _currentIndex == AppConstants.moreIndex &&
            _currentModuleId != null) {
          _currentModuleId = null;
        } else {
          _currentIndex = index;
          // Clear module when switching to a different tab
          if (index != AppConstants.moreIndex) {
            _currentModuleId = null;
          }
        }
      });
    };
    NavigationService.instance.onModuleChanged = (moduleId) {
      setState(() {
        _currentModuleId = moduleId;
      });
    };
  }

  /// Initializes the floating action button rotation animation.
  ///
  /// The button rotates 45 degrees (0.125 turns) when opened.
  void _initializeAnimations() {
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _buttonRotationAnimation =
        Tween<double>(
          begin: 0.0,
          end: 0.125, // 45 degrees in turns (0.125 * 360 = 45)
        ).animate(
          CurvedAnimation(
            parent: _buttonAnimationController!,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _buttonAnimationController?.dispose();
    super.dispose();
  }

  /// Toggles the floating action button menu.
  ///
  /// Provides haptic feedback and shows/hides the action menu.
  void _toggleMenu() {
    HapticFeedback.lightImpact();
    _showActionMenu();
  }

  /// Shows the action menu bottom sheet with quick actions.
  ///
  /// Available actions:
  /// - Add Product
  /// - New Sale
  /// - New Purchase
  void _showActionMenu() {
    // Use the scaffold context which is inside MaterialApp
    final scaffoldContext = _scaffoldContext ?? context;

    showModalBottomSheet(
      context: scaffoldContext,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (modalContext) =>
          _buildActionMenuSheet(modalContext, scaffoldContext),
    ).then((_) {
      // Update button state when modal closes
      if (_isMenuOpen) {
        setState(() {
          _isMenuOpen = false;
        });
        _buttonAnimationController?.reverse();
      }
    });

    // Update button state when modal opens
    setState(() {
      _isMenuOpen = true;
    });
    _buttonAnimationController?.forward();
  }

  /// Maps internal tab index to bottom navigation bar index.
  ///
  /// The center position (index 2) is reserved for the floating action button,
  /// so indices are shifted: 0->0, 1->1, 2->3, 3->4
  ///
  /// Returns the corresponding bottom navigation bar index.
  int _getBottomNavIndex() {
    // Map internal index to bottom nav index: 0->0, 1->1, 2->3, 3->4
    if (_currentIndex >= 2) {
      return _currentIndex + 1;
    }
    return _currentIndex;
  }

  /// Handles bottom navigation bar tap events.
  ///
  /// - Index 2: Opens/closes the floating action button menu
  /// - Other indices: Navigate to corresponding tab
  ///
  /// [index] The tapped bottom navigation bar index
  void _onNavTap(int index) {
    // Handle center button (index 2)
    if (index == 2) {
      _toggleMenu();
      return;
    }

    // Close menu if open when navigating
    if (_isMenuOpen) {
      _toggleMenu();
    }

    // Map bottom nav indices to internal indices: 0->0, 1->1, 3->2, 4->3
    int mappedIndex = index;
    if (index > 2) {
      mappedIndex = index - 1;
    }

    setState(() {
      _currentIndex = mappedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: GestureDetector(
        onTap: () {
          // Close menu when tapping outside
          if (_isMenuOpen) {
            _toggleMenu();
          }
        },
        child: Builder(
          builder: (context) {
            // Store the scaffold context for use in modal
            _scaffoldContext = context;
            return Scaffold(
              body: _buildCurrentScreen(),
              bottomNavigationBar: _buildBottomNavBar(context),
              extendBody: false,
            );
          },
        ),
      ),
    );
  }

  /// Builds the current screen based on tab index and module selection.
  ///
  /// If on the "More" tab and a module is selected, shows the module screen.
  /// Otherwise, shows the screen for the current tab index.
  Widget _buildCurrentScreen() {
    // If on More tab and a module is selected, show module screen
    if (_currentIndex == AppConstants.moreIndex && _currentModuleId != null) {
      final moduleScreen = AppRouter.getModuleScreen(_currentModuleId);
      if (moduleScreen != null) {
        return moduleScreen;
      }
    }
    // Otherwise, show the screen for current tab
    return AppRouter.getScreenByIndex(_currentIndex);
  }

  /// Builds the bottom navigation bar with floating action button.
  ///
  /// Includes:
  /// - 4 navigation items (Home, Inventory, Notifications, More)
  /// - Center floating action button with rotation animation
  /// - Safe area padding handling
  Widget _buildBottomNavBar(BuildContext scaffoldContext) {
    final bottomPadding = MediaQuery.of(scaffoldContext).padding.bottom;

    return Container(
      color: AppColors.cardBackground,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
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
                child: BottomNavigationBar(
                  currentIndex: _getBottomNavIndex(),
                  onTap: _onNavTap,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.metricPurple,
                  unselectedItemColor: AppColors.navUnselected,
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(FeatherIcons.home, size: 24),
                      activeIcon: Icon(FeatherIcons.home, size: 24),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FeatherIcons.grid, size: 24),
                      activeIcon: Icon(FeatherIcons.grid, size: 24),
                      label: 'Inventory',
                    ),
                    // Center placeholder - will be covered by the plus button
                    BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
                    BottomNavigationBarItem(
                      icon: Icon(FeatherIcons.bell, size: 24),
                      activeIcon: Icon(FeatherIcons.bell, size: 24),
                      label: 'Notifications',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FeatherIcons.moreHorizontal, size: 24),
                      activeIcon: Icon(FeatherIcons.moreHorizontal, size: 24),
                      label: 'More',
                    ),
                  ],
                ),
              ),
              // Center Plus/X Button with rotation animation
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 28,
                top: -28,
                child: RotationTransition(
                  turns:
                      _buttonRotationAnimation ??
                      const AlwaysStoppedAnimation(0.0),
                  child: Material(
                    color: AppColors.metricPurple,
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: InkWell(
                      onTap: _toggleMenu,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.metricPurple,
                        ),
                        child: Icon(
                          _isMenuOpen ? FeatherIcons.x : FeatherIcons.plus,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (bottomPadding > 0)
            Container(height: bottomPadding, color: AppColors.cardBackground),
        ],
      ),
    );
  }

  /// Builds the action menu bottom sheet.
  ///
  /// Displays quick action options:
  /// - Add Product (navigates to AddProductScreen)
  /// - New Sale (placeholder - coming soon)
  /// - New Purchase (placeholder - coming soon)
  ///
  /// [modalContext] Context of the modal bottom sheet
  /// [scaffoldContext] Context of the main scaffold for navigation
  Widget _buildActionMenuSheet(
    BuildContext modalContext,
    BuildContext scaffoldContext,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.gray400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Menu items
            _buildMenuItem(
              index: 0,
              icon: FeatherIcons.plus,
              iconColor: AppColors.success,
              iconBackground: AppColors.successLight,
              label: 'Add Product',
              onTap: () {
                HapticFeedback.mediumImpact();
                // Close modal first
                Navigator.of(modalContext).pop();
                // Navigate to add product page after modal closes
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Use the scaffold context for navigation (has Navigator)
                  if (scaffoldContext.mounted) {
                    Navigator.of(scaffoldContext).push(
                      MaterialPageRoute(
                        builder: (context) => const AddProductScreen(),
                      ),
                    );
                  }
                });
              },
            ),
            const SizedBox(height: 8),
            _buildMenuItem(
              index: 1,
              icon: FeatherIcons.shoppingCart,
              iconColor: const Color(0xFF2196F3), // Blue
              iconBackground: const Color(0xFFE3F2FD), // Light blue
              label: 'New Sale',
              onTap: () {
                Navigator.of(modalContext).pop(); // Close modal
                HapticFeedback.mediumImpact();
                // TODO: Navigate to New Sale screen
                ScaffoldMessenger.of(modalContext).showSnackBar(
                  const SnackBar(
                    content: Text('New Sale - Coming Soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildMenuItem(
              index: 2,
              icon: FeatherIcons.creditCard,
              iconColor: AppColors.metricPurple,
              iconBackground: AppColors.metricPurple.withValues(alpha: 0.1),
              label: 'New Purchase',
              onTap: () {
                Navigator.of(modalContext).pop(); // Close modal
                HapticFeedback.mediumImpact();
                // TODO: Navigate to New Purchase screen
                ScaffoldMessenger.of(modalContext).showSnackBar(
                  const SnackBar(
                    content: Text('New Purchase - Coming Soon'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  /// Builds a menu item for the action menu.
  ///
  /// Each item has:
  /// - Icon with colored background
  /// - Label text
  /// - Tap handler
  ///
  /// [index] Item index (for future use)
  /// [icon] Icon to display
  /// [iconColor] Color of the icon
  /// [iconBackground] Background color of the icon container
  /// [label] Text label for the menu item
  /// [onTap] Callback when the item is tapped
  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.metricPurple.withValues(alpha: 0.1),
        highlightColor: AppColors.metricPurple.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
