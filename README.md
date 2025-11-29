# Amazing Inventory - Flutter Mobile App

A modern Flutter mobile application for inventory management with a beautiful, intuitive dashboard interface.

## Features

### Dashboard
- **Personalized Greeting**: Dynamic greeting based on time of day with user profile
- **Key Metrics Cards**: Four metric cards displaying:
  - Total Stock Value
  - Total Stock
  - Out of Stock items
  - Low Stock alerts
- **Stock Flow Chart**: Interactive stacked bar chart showing weekly inventory trends
- **Bottom Navigation**: Easy navigation between Home, Inventory, Analytics, and Settings

## Project Structure

The app uses a **feature-based architecture** for better scalability and maintainability:

```
lib/
├── main.dart                          # App entry point
├── core/                              # Core app functionality
│   ├── constants/
│   │   └── app_constants.dart        # Application-wide constants
│   └── theme/
│       └── app_theme.dart            # Theme configuration
├── features/                          # Feature modules
│   └── dashboard/                     # Dashboard feature
│       ├── screens/
│       │   └── dashboard_screen.dart # Main dashboard screen
│       └── widgets/
│           ├── metric_card.dart      # Metric card component
│           └── stock_flow_chart.dart # Stock flow chart
└── shared/                            # Shared across features
    ├── widgets/
    │   └── bottom_nav_bar.dart       # Bottom navigation bar
    └── utils/
        └── greeting_util.dart        # Utility functions
```

## Architecture

The app follows **feature-based architecture** with clean architecture principles:

### Feature-Based Architecture Benefits
- **Modularity**: Each feature is self-contained
- **Scalability**: Easy to add new features without affecting existing ones
- **Maintainability**: Related code is grouped together
- **Team Collaboration**: Multiple developers can work on different features independently

### Design Principles
- **KISS (Keep It Simple, Stupid)**: Simple, straightforward code
- **SOLID Principles**: Single responsibility, separation of concerns
- **DRY (Don't Repeat Yourself)**: Reusable components and utilities
- **Feature Isolation**: Each feature contains its own screens, widgets, models, and services

### Architecture Layers

#### Core Layer (`lib/core/`)
Contains application-wide configurations and constants:
- **Constants**: App-wide constants (navigation indices, default values, colors)
- **Theme**: Centralized theme management for light/dark modes

#### Features Layer (`lib/features/`)
Each feature is a self-contained module:
- **Dashboard Feature**: Main dashboard with metrics and charts
  - `screens/`: Feature-specific screens
  - `widgets/`: Feature-specific widgets (MetricCard, StockFlowChart)
  - Future features: `inventory/`, `analytics/`, `settings/`

#### Shared Layer (`lib/shared/`)
Reusable components and utilities used across features:
- **Widgets**: Shared UI components (BottomNavBar)
- **Utils**: Utility functions (GreetingUtil)

### Components

#### Dashboard Feature Components

**MetricCard Widget** (`features/dashboard/widgets/`)
- Reusable card component for displaying key metrics
- Customizable icon and color
- Period selector (Weekly, Monthly, etc.)
- Trend indicator
- Support for circular or square icons

**StockFlowChart Widget** (`features/dashboard/widgets/`)
- Interactive chart displaying inventory trends using `fl_chart`
- Stacked bar chart visualization
- Weekly data display
- Color-coded segments
- Responsive design

**DashboardScreen** (`features/dashboard/screens/`)
- Main dashboard screen
- Displays metrics, charts, and user information
- Integrates dashboard-specific widgets

#### Shared Components

**CustomBottomNavBar Widget** (`shared/widgets/`)
- Bottom navigation bar used across the app
- Four main sections: Home, Inventory, Analytics, Settings
- Centralized navigation management

**GreetingUtil** (`shared/utils/`)
- Utility function for generating time-based greetings
- Reusable across features

## Dependencies

- `flutter`: SDK
- `fl_chart: ^0.69.0`: Chart visualization library
- `intl: ^0.19.0`: Internationalization support
- `cupertino_icons: ^1.0.8`: iOS-style icons

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## Development

### Code Style
- Follows Flutter best practices
- Uses Material Design 3
- Responsive layout for different screen sizes
- Clean widget composition

### State Management
Currently uses `StatefulWidget` for local state. For larger applications, consider:
- Provider
- Riverpod
- Bloc
- GetX

## Future Enhancements

- API integration for real-time data
- User authentication
- Push notifications
- Dark mode support
- Advanced analytics
- Product management screens
- Inventory scanning features

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [fl_chart Documentation](https://pub.dev/packages/fl_chart)
- [Material Design 3](https://m3.material.io/)
