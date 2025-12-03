import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'core/services/navigation_service.dart';
import 'core/di/service_locator.dart';
import 'shared/utils/responsive_util.dart';
import 'features/inventory/screens/add_product_screen.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/cubit/auth_state.dart';
import 'features/auth/screens/welcome_screen.dart';

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
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  // This must be done before accessing AppConstants that depend on .env
  try {
    await dotenv.load(fileName: '.env');
    // Debug: Print API configuration
    debugPrint('✅ .env file loaded successfully');
    debugPrint('📡 API Base URL: ${AppConstants.apiBaseUrl}');
    debugPrint('🌍 Environment: ${dotenv.get('APP_ENV', fallback: 'development')}');
  } catch (e) {
    // If .env file is not found, continue with fallback values
    // This allows the app to run even if .env is missing (uses fallback values in AppConstants)
    debugPrint('Warning: Could not load .env file: $e');
    debugPrint('Using fallback values from AppConstants');
    debugPrint('📡 API Base URL (fallback): ${AppConstants.apiBaseUrl}');
  }

  // Initialize dependency injection
  await setupServiceLocator();

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
/// - Authentication state management
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

  // Authentication cubit from service locator
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
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

  /// Initialize authentication and check auth status.
  void _initializeAuth() {
    // Get AuthCubit from service locator
    _authCubit = getIt<AuthCubit>();
    
    // Check authentication status on app start
    _authCubit.checkAuth();
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
    _authCubit.close();
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
    return BlocProvider<AuthCubit>(
      create: (context) => _authCubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, authState) {
          // Reset navigation to home screen when user logs in
          // This ensures users always start at home screen after authentication
          if (authState is AuthAuthenticated) {
            if (mounted) {
              // Reset synchronously before BlocBuilder rebuilds
              _currentIndex = AppConstants.homeIndex;
              _currentModuleId = null;
              // Trigger rebuild to reflect the change
              setState(() {});
            }
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            // Show welcome/login screen if not authenticated
            if (authState is AuthUnauthenticated || authState is AuthInitial) {
              return MaterialApp(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                home: const WelcomeScreen(),
              );
            }

            // Show loading screen while checking auth
            if (authState is AuthLoading) {
              return MaterialApp(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                home: Scaffold(
                  backgroundColor: AppColors.scaffoldBackground,
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            // Show main app if authenticated
            // Use a key to ensure MaterialApp is completely rebuilt when auth state changes
            // Navigation state is reset by BlocListener when AuthAuthenticated is emitted
            return MaterialApp(
              key: ValueKey('authenticated_app'),
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              home: Builder(
                builder: (context) {
                  // Store the scaffold context for use in modal
                  _scaffoldContext = context;
                  return Scaffold(
                    backgroundColor: AppColors.scaffoldBackground,
                    body: GestureDetector(
                      onTap: () {
                        // Close menu when tapping outside (only on body, not nav bar)
                        if (_isMenuOpen) {
                          _toggleMenu();
                        }
                      },
                      behavior: HitTestBehavior.translucent,
                      child: _buildCurrentScreen(),
                    ),
                    bottomNavigationBar: _buildBottomNavBar(context),
                    extendBody: false,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the current screen based on tab index and module selection.
  ///
  /// Uses IndexedStack to preserve state of all screens when navigating.
  /// This ensures dashboard and other screens don't reload data when switching tabs.
  /// If on the "More" tab and a module is selected, shows the module screen.
  /// Otherwise, shows the screen for the current tab index.
  /// Always returns a valid widget (defaults to DashboardScreen if invalid).
  Widget _buildCurrentScreen() {
    // If on More tab and a module is selected, show module screen
    if (_currentIndex == AppConstants.moreIndex && _currentModuleId != null) {
      final moduleScreen = AppRouter.getModuleScreen(_currentModuleId);
      if (moduleScreen != null) {
        return moduleScreen;
      }
    }
    
    // Use IndexedStack to preserve state of all screens
    // This prevents screens from reloading data when navigating between tabs
    // All screens are kept in memory, only the visible one is shown
    return IndexedStack(
      index: _currentIndex,
      children: [
        AppRouter.getScreenByIndex(AppConstants.homeIndex),
        AppRouter.getScreenByIndex(AppConstants.inventoryIndex),
        AppRouter.getScreenByIndex(AppConstants.notificationsIndex),
        AppRouter.getScreenByIndex(AppConstants.moreIndex),
      ],
    );
  }

  /// Builds the bottom navigation bar with floating action button.
  ///
  /// Includes:
  /// - 4 navigation items (Home, Inventory, Notifications, More)
  /// - Center floating action button with rotation animation
  /// - Safe area padding handling
  Widget _buildBottomNavBar(BuildContext scaffoldContext) {
    final bottomPadding = MediaQuery.of(scaffoldContext).padding.bottom;
    // Calculate responsive values once using the scaffold context
    final iconSize = ResponsiveUtil.getIconSize(scaffoldContext, baseSize: 24);
    final fontSize = ResponsiveUtil.getFontSize(scaffoldContext, baseSize: 12);
    final buttonSize = ResponsiveUtil.getContainerSize(
      scaffoldContext,
      baseSize: 56,
    );
    final buttonIconSize = ResponsiveUtil.getIconSize(
      scaffoldContext,
      baseSize: 28,
    );
    final screenWidth = MediaQuery.of(scaffoldContext).size.width;
    final buttonOffset = buttonSize / 2;

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
                  selectedFontSize: fontSize,
                  unselectedFontSize: fontSize,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(FeatherIcons.home, size: iconSize),
                      activeIcon: Icon(FeatherIcons.home, size: iconSize),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FeatherIcons.grid, size: iconSize),
                      activeIcon: Icon(FeatherIcons.grid, size: iconSize),
                      label: 'Inventory',
                    ),
                    // Center placeholder - will be covered by the plus button
                    const BottomNavigationBarItem(
                      icon: SizedBox.shrink(),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FeatherIcons.bell, size: iconSize),
                      activeIcon: Icon(FeatherIcons.bell, size: iconSize),
                      label: 'Notifications',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FeatherIcons.moreHorizontal, size: iconSize),
                      activeIcon: Icon(
                        FeatherIcons.moreHorizontal,
                        size: iconSize,
                      ),
                      label: 'More',
                    ),
                  ],
                ),
              ),
              // Center Plus/X Button with rotation animation
              Positioned(
                left: screenWidth / 2 - buttonOffset,
                top: -buttonOffset,
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
                        width: buttonSize,
                        height: buttonSize,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.metricPurple,
                        ),
                        child: Icon(
                          _isMenuOpen ? FeatherIcons.x : FeatherIcons.plus,
                          color: Colors.white,
                          size: buttonIconSize,
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
    // Calculate responsive values once using the modal context
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(modalContext);
    final verticalPadding = ResponsiveUtil.getVerticalPadding(modalContext);
    final spacing = ResponsiveUtil.getSpacing(modalContext);
    final handleBarSize = ResponsiveUtil.getContainerSize(
      modalContext,
      baseSize: 40,
    );
    final bottomPadding = MediaQuery.of(modalContext).padding.bottom;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
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
              width: handleBarSize,
              height: 4,
              margin: EdgeInsets.only(bottom: spacing),
              decoration: BoxDecoration(
                color: AppColors.gray400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Menu items
            _buildMenuItem(
              context: modalContext,
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
            SizedBox(height: spacing - 4),
            _buildMenuItem(
              context: modalContext,
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
            SizedBox(height: spacing - 4),
            _buildMenuItem(
              context: modalContext,
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
            SizedBox(height: bottomPadding),
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
  /// [context] BuildContext for responsive sizing
  /// [index] Item index (for future use)
  /// [icon] Icon to display
  /// [iconColor] Color of the icon
  /// [iconBackground] Background color of the icon container
  /// [label] Text label for the menu item
  /// [onTap] Callback when the item is tapped
  Widget _buildMenuItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String label,
    required VoidCallback onTap,
  }) {
    final iconSize = ResponsiveUtil.getContainerSize(context, baseSize: 40);
    final iconIconSize = ResponsiveUtil.getIconSize(context, baseSize: 20);
    final labelFontSize = ResponsiveUtil.getFontSize(context, baseSize: 15);
    final spacing = ResponsiveUtil.getSpacing(context);
    final horizontalPadding = ResponsiveUtil.getHorizontalPadding(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.metricPurple.withValues(alpha: 0.1),
        highlightColor: AppColors.metricPurple.withValues(alpha: 0.05),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: spacing - 4,
          ),
          child: Row(
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: iconIconSize),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: labelFontSize,
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
