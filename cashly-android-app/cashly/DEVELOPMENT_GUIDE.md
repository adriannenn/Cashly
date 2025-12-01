# Cashly - Development Guide

## Development Environment Setup

### Required Tools

1. **Flutter & Dart**
   - Flutter SDK 3.0.0+
   - Dart SDK 3.0.0+

2. **IDE**
   - Android Studio with Flutter plugin
   - OR VS Code with Flutter extension

3. **Version Control**
   - Git

### Recommended VS Code Extensions

- Flutter
- Dart
- Flutter Widget Snippets
- Bracket Pair Colorizer
- Error Lens

## Architecture

### Design Pattern

The app follows **MVC (Model-View-Controller)** architecture with **Provider** for state management:

- **Models**: Data structures (`lib/core/models/`)
- **Views**: UI screens (`lib/features/*/screens/`)
- **Controllers**: State management providers (`lib/core/providers/`)

### Project Structure

\`\`\`
lib/
├── core/
│   ├── constants/     # App-wide constants
│   ├── models/        # Data models (User, Budget, Transaction)
│   ├── providers/     # State management (Auth, Budget, Transaction, Theme)
│   ├── routes/        # Navigation routes
│   ├── services/      # Business logic (Database, API, SharedPrefs)
│   ├── theme/         # App theming
│   └── utils/         # Helper utilities (Validators, Helpers)
├── features/          # Feature modules
│   ├── auth/          # Authentication feature
│   ├── dashboard/     # Dashboard feature
│   ├── budget/        # Budget management feature
│   ├── transactions/  # Transaction tracking feature
│   ├── profile/       # User profile feature
│   ├── settings/      # Settings feature
│   └── about/         # About feature
├── widgets/           # Reusable widgets
└── main.dart          # App entry point
\`\`\`

## Development Guidelines

### Code Style

1. **Naming Conventions**
   - Classes: PascalCase (`UserModel`, `AuthProvider`)
   - Variables/Functions: camelCase (`getUserById`, `totalAmount`)
   - Constants: camelCase with const (`const primaryBlue`)
   - Private members: prefix with underscore (`_privateMethod`)

2. **File Naming**
   - Use snake_case: `user_model.dart`, `auth_provider.dart`
   - Screens: `*_screen.dart`
   - Widgets: `*_widget.dart` or descriptive name
   - Services: `*_service.dart`

3. **Import Organization**
   \`\`\`dart
   // 1. Dart SDK imports
   import 'dart:async';
   
   // 2. Flutter imports
   import 'package:flutter/material.dart';
   
   // 3. Package imports
   import 'package:provider/provider.dart';
   
   // 4. Relative imports
   import '../models/user_model.dart';
   \`\`\`

### State Management with Provider

#### Creating a Provider

\`\`\`dart
class BudgetProvider with ChangeNotifier {
  List<BudgetModel> _budgets = [];
  
  List<BudgetModel> get budgets => _budgets;
  
  Future<void> loadBudgets(String userId) async {
    _budgets = await DatabaseService.instance.getBudgetsByUserId(userId);
    notifyListeners(); // Update UI
  }
}
\`\`\`

#### Using Provider in Widgets

\`\`\`dart
// 1. Provide at app level (main.dart)
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => BudgetProvider()),
  ],
  child: MyApp(),
)

// 2. Access in widgets
Consumer<BudgetProvider>(
  builder: (context, budgetProvider, child) {
    return ListView.builder(
      itemCount: budgetProvider.budgets.length,
      itemBuilder: (context, index) {
        return BudgetCard(budget: budgetProvider.budgets[index]);
      },
    );
  },
)

// 3. Call methods
Provider.of<BudgetProvider>(context, listen: false).loadBudgets(userId);
\`\`\`

### Database Operations

#### Adding a New Table

1. Update `database_service.dart` - `_createDB` method:
\`\`\`dart
await db.execute('''
  CREATE TABLE new_table (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TEXT NOT NULL
  )
''');
\`\`\`

2. Increment database version in `app_constants.dart`

3. Implement CRUD methods in `DatabaseService`

#### CRUD Pattern

\`\`\`dart
// Create
Future<String> createItem(ItemModel item) async {
  final db = await database;
  final id = DateTime.now().millisecondsSinceEpoch.toString();
  await db.insert('items', item.toMap());
  return id;
}

// Read
Future<List<ItemModel>> getItems() async {
  final db = await database;
  final maps = await db.query('items');
  return maps.map((map) => ItemModel.fromMap(map)).toList();
}

// Update
Future<int> updateItem(ItemModel item) async {
  final db = await database;
  return db.update(
    'items',
    item.toMap(),
    where: 'id = ?',
    whereArgs: [item.id],
  );
}

// Delete
Future<int> deleteItem(String id) async {
  final db = await database;
  return db.delete(
    'items',
    where: 'id = ?',
    whereArgs: [id],
  );
}
\`\`\`

### Adding New Features

1. **Create Feature Directory**
   \`\`\`
   lib/features/new_feature/
   ├── screens/
   ├── widgets/
   └── models/ (if needed)
   \`\`\`

2. **Create Model** (if needed)
   \`\`\`dart
   class NewModel {
     final String id;
     final String name;
     
     NewModel({required this.id, required this.name});
     
     Map<String, dynamic> toMap() => {'id': id, 'name': name};
     factory NewModel.fromMap(Map<String, dynamic> map) => 
         NewModel(id: map['id'], name: map['name']);
   }
   \`\`\`

3. **Create Provider**
   \`\`\`dart
   class NewProvider with ChangeNotifier {
     // State and methods
   }
   \`\`\`

4. **Add Routes**
   \`\`\`dart
   // app_routes.dart
   static const String newFeature = '/new-feature';
   
   routes: {
     newFeature: (context) => NewFeatureScreen(),
   }
   \`\`\`

5. **Register Provider** (main.dart)
   \`\`\`dart
   MultiProvider(
     providers: [
       // ...
       ChangeNotifierProvider(create: (_) => NewProvider()),
     ],
   )
   \`\`\`

### Adding Charts

Using `fl_chart` package:

\`\`\`dart
import 'package:fl_chart/fl_chart.dart';

PieChart(
  PieChartData(
    sections: data.map((item) => 
      PieChartSectionData(
        value: item.value,
        title: item.label,
        color: item.color,
      )
    ).toList(),
  ),
)
\`\`\`

### Custom Widgets

Create reusable widgets in `lib/widgets/`:

\`\`\`dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  const CustomButton({
    required this.text,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
\`\`\`

## Testing

### Unit Tests

\`\`\`dart
// test/models/user_model_test.dart
void main() {
  group('UserModel', () {
    test('should create UserModel from map', () {
      final map = {
        'id': '1',
        'full_name': 'John Doe',
        'email': 'john@example.com',
      };
      
      final user = UserModel.fromMap(map);
      
      expect(user.id, '1');
      expect(user.fullName, 'John Doe');
    });
  });
}
\`\`\`

### Widget Tests

\`\`\`dart
// test/widgets/custom_button_test.dart
void main() {
  testWidgets('CustomButton displays text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Click Me',
            onPressed: () {},
          ),
        ),
      ),
    );
    
    expect(find.text('Click Me'), findsOneWidget);
  });
}
\`\`\`

## Debugging

### Print Debugging

\`\`\`dart
print('Debug: ${variable.toString()}');
debugPrint('More info: $info');
\`\`\`

### Logging

\`\`\`dart
import 'package:logger/logger.dart';

final logger = Logger();

logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
\`\`\`

### Flutter DevTools

\`\`\`bash
flutter pub global activate devtools
flutter pub global run devtools
\`\`\`

## Performance Optimization

### 1. Use const Constructors

\`\`\`dart
const Text('Static text'); // Better
Text('Static text');        // Avoid
\`\`\`

### 2. Avoid Rebuilding Widgets

\`\`\`dart
// Use Consumer for specific parts
Consumer<Provider>(
  builder: (context, provider, child) => Widget(),
)

// Instead of
Provider.of<Provider>(context); // Rebuilds entire widget
\`\`\`

### 3. Use ListView.builder

\`\`\`dart
// For large lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// Instead of
ListView(children: items.map((item) => ItemWidget(item)).toList())
\`\`\`

## Git Workflow

### Branch Naming

- Features: `feature/feature-name`
- Bugs: `bugfix/bug-description`
- Hotfixes: `hotfix/issue-description`

### Commit Messages

\`\`\`
feat: Add budget creation feature
fix: Fix transaction deletion bug
docs: Update README
style: Format code
refactor: Refactor auth provider
test: Add user model tests
\`\`\`

## Building for Release

### 1. Update Version

In `pubspec.yaml`:
\`\`\`yaml
version: 1.0.1+2  # version+build_number
\`\`\`

### 2. Build APK

\`\`\`bash
flutter build apk --release
\`\`\`

### 3. Build App Bundle (for Play Store)

\`\`\`bash
flutter build appbundle --release
\`\`\`

## Common Issues & Solutions

### Issue: Provider not found

**Solution**: Make sure provider is registered in `main.dart` before using it.

### Issue: Database not updating

**Solution**: 
1. Increment database version
2. Implement migration in `onUpgrade`
3. Or uninstall app to reset database

### Issue: UI not updating

**Solution**: Call `notifyListeners()` after state changes in providers.

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [FL Chart](https://pub.dev/packages/fl_chart)
- [SQLite](https://pub.dev/packages/sqflite)

## Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

---

Happy Coding!
