import 'package:flutter/material.dart';
import 'package:theming/app_theme.dart';
import 'package:theming/theme_option.dart';

void main() {
  // This could be loaded from storage e.g. with `shared_preferences`
  const themeOption = ThemeOption.system;
  runApp(MyApp(themeOption: themeOption));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required ThemeOption themeOption})
      : _themeNotifier = ValueNotifier(themeOption),
        super(key: key);

  final ValueNotifier<ThemeOption> _themeNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeOption>(
      valueListenable: _themeNotifier,
      child: MyHomePage(onThemeUpdate: onThemeUpdate),
      builder: (context, themeOption, child) {
        return MaterialApp(
          title: 'Theming Tutorial',
          theme: AppTheme.light,
          darkTheme: themeOption == ThemeOption.trueBlack
              ? AppTheme.trueBlack
              : AppTheme.dark,
          themeMode: themeOption.themeMode,
          home: child,
        );
      },
    );
  }

  void onThemeUpdate(ThemeOption themeOption) {
    _themeNotifier.value = themeOption;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.onThemeUpdate})
      : title = 'Theming',
        super(key: key);

  final String title;
  final Function(ThemeOption) onThemeUpdate;

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

  Future<ThemeOption?> _showThemePicker() {
    return showModalBottomSheet<ThemeOption>(
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
                  Navigator.pop(context, ThemeOption.light);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                leading: const Icon(Icons.brightness_2_outlined),
                onTap: () {
                  Navigator.pop(context, ThemeOption.dark);
                },
              ),
              ListTile(
                title: const Text('True black'),
                leading: const Icon(Icons.brightness_1_outlined),
                onTap: () {
                  Navigator.pop(context, ThemeOption.trueBlack);
                },
              ),
              ListTile(
                title: const Text('System'),
                leading: const Icon(Icons.settings_outlined),
                onTap: () {
                  Navigator.pop(context, ThemeOption.system);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
