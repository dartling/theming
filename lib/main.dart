import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

void main() {
  // This could be loaded from storage e.g. with `shared_preferences`
  const themeMode = ThemeMode.system;
  runApp(MyApp(theme: themeMode));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required ThemeMode theme})
      : _themeNotifier = ValueNotifier(theme),
        super(key: key);

  final ValueNotifier<ThemeMode> _themeNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      child: MyHomePage(onThemeUpdate: onThemeUpdate),
      builder: (context, theme, child) {
        return MaterialApp(
          title: 'Theming Tutorial',
          theme: FlexThemeData.light(scheme: FlexScheme.hippieBlue),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.hippieBlue,
            darkIsTrueBlack: true,
          ),
          themeMode: theme,
          home: child,
        );
      },
    );
  }

  void onThemeUpdate(ThemeMode themeMode) {
    _themeNotifier.value = themeMode;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.onThemeUpdate})
      : title = 'Theming',
        super(key: key);

  final String title;
  final Function(ThemeMode) onThemeUpdate;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _selectTheme,
            icon: const Icon(Icons.brightness_4_outlined),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _selectTheme() async {
    final theme = await _showThemePicker();
    if (theme != null) {
      widget.onThemeUpdate(theme);
    }
  }

  Future<ThemeMode?> _showThemePicker() {
    return showModalBottomSheet<ThemeMode>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Light'),
                leading: const Icon(Icons.brightness_7_outlined),
                onTap: () {
                  Navigator.pop(context, ThemeMode.light);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                leading: const Icon(Icons.brightness_2_outlined),
                onTap: () {
                  Navigator.pop(context, ThemeMode.dark);
                },
              ),
              ListTile(
                title: const Text('System'),
                leading: const Icon(Icons.settings_outlined),
                onTap: () {
                  Navigator.pop(context, ThemeMode.system);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
