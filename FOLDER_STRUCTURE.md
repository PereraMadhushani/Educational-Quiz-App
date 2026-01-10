# Project Folder Structure

## Overview
Science Quiz Master follows a clean, scalable architecture suitable for educational applications.

## Directory Structure

```
lib/
├── main.dart                 # App entry point
├── constants/               # App-wide constants
│   ├── app_colors.dart      # Color definitions
│   └── app_strings.dart     # String constants and labels
├── models/                  # Data models
│   ├── quiz_model.dart      # Quiz, Question, QuizResult models
│   └── user_model.dart      # User profile model
├── screens/                 # Full-page screens/views
│   ├── home_screen.dart     # Home/Dashboard screen
│   ├── quiz_screen.dart     # Quiz taking screen (to be created)
│   └── results_screen.dart  # Results display screen (to be created)
├── widgets/                 # Reusable UI components
│   ├── custom_button.dart   # Custom button widget
│   ├── quiz_card.dart       # Quiz card component
│   └── (more widgets)
├── services/                # Business logic & API
│   ├── quiz_service.dart    # Quiz data service
│   └── (more services)
├── providers/               # State management (Provider, Riverpod, etc.)
│   └── (provider files)
└── utils/                   # Utility functions
    ├── validators.dart      # Input validation helpers
    └── app_theme.dart       # Theme configuration

assets/
├── images/                  # Image assets
└── fonts/                   # Custom fonts

test/
└── widget_test.dart         # Widget tests
```

## Folder Descriptions

### `/lib/main.dart`
- Application entry point
- Sets up themes, routing, and root widget

### `/lib/constants/`
- Centralized color and string definitions
- Prevents hardcoding values throughout the app
- Makes theming and localization easier

### `/lib/models/`
- Data class definitions
- Quiz, Question, User models
- JSON serialization/deserialization

### `/lib/screens/`
- Full-page UI layouts
- One screen = one class
- Handle screen-specific state and navigation

### `/lib/widgets/`
- Reusable UI components
- Buttons, cards, dialogs, etc.
- Stateless or stateful widgets used across screens

### `/lib/services/`
- Business logic and API calls
- Quiz data fetching
- Database operations
- Authentication logic

### `/lib/providers/`
- State management solutions
- Provider, Riverpod, BLoC, GetX, etc.
- Global state management

### `/lib/utils/`
- Helper functions
- Validation logic
- Theme configuration
- Date/time utilities

### `/assets/`
- Images, icons, fonts
- Organized by type

## Best Practices

1. **Single Responsibility**: Each file/class has one purpose
2. **Reusability**: Components in `/widgets/` are reusable
3. **Separation of Concerns**: UI, business logic, and data are separate
4. **Scalability**: Easy to add new screens, services, and widgets
5. **Maintainability**: Clear organization makes code easier to find and maintain

## Adding New Features

### Add a New Quiz Type:
1. Create model in `/models/`
2. Create screen in `/screens/`
3. Create service in `/services/` if needed
4. Create widgets in `/widgets/`
5. Import in appropriate files

### Add a New Service:
1. Create file in `/services/`
2. Define service class with methods
3. Use in screens via providers or direct calls

### Add New UI Component:
1. Create file in `/widgets/`
2. Make it reusable and stateless when possible
3. Pass data via constructor parameters
4. Use in screens

## Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Methods**: `camelCase`
- **Constants**: `CONSTANT_CASE` or `PascalCase`

## Future Additions

- [ ] State management (Provider)
- [ ] Authentication service
- [ ] Database (SQLite/Hive)
- [ ] Analytics
- [ ] Notifications
- [ ] Offline support
