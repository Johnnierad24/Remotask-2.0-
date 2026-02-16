import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'auth_manager.dart';
import 'screens/home_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/chats_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'widgets/account_dialog.dart';
import 'theme/app_theme.dart';
import 'services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initialize();
  // Optionally: initialize real-time service globally if needed
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthManager()..loadToken(),
      child: RemotaskApp(),
    ),
  );
}

class RemotaskApp extends StatefulWidget {
  @override
  State<RemotaskApp> createState() => _RemotaskAppState();
}

class _RemotaskAppState extends State<RemotaskApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CANARY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('sw'),
        Locale('fr'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Consumer<AuthManager>(
        builder: (context, auth, _) {
          if (!auth.isLoggedIn) {
            return LoginScreen(
              onLoginSuccess: (token) => auth.saveToken(token),
            );
          }
          return MainNavigation(onLocaleChanged: setLocale);
        },
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final void Function(Locale)? onLocaleChanged;
  const MainNavigation({Key? key, this.onLocaleChanged}) : super(key: key);
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    ProjectsScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAccountDialog() {
    final auth = Provider.of<AuthManager>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AccountDialog(
        email: 'jimmymn782@gmail.com',
        onLogout: () async {
          Navigator.of(context).pop();
          await auth.logout();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remotask'),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) => widget.onLocaleChanged?.call(locale),
            itemBuilder: (context) => [
              const PopupMenuItem(value: Locale('en'), child: Text('English')),
              const PopupMenuItem(value: Locale('sw'), child: Text('Swahili')),
              const PopupMenuItem(value: Locale('fr'), child: Text('French')),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          _screens[_selectedIndex],
          if (_selectedIndex == 3) // Profile tab
            Positioned(
              right: 24,
              top: 48,
              child: IconButton(
                icon: Icon(Icons.settings, color: Colors.blue),
                onPressed: _showAccountDialog,
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
