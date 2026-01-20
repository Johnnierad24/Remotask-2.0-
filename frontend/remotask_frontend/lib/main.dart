import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_manager.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/chats_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'widgets/account_dialog.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthManager()..loadToken(),
      child: RemotaskApp(),
    ),
  );
}

class RemotaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreelanceHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: Consumer<AuthManager>(
        builder: (context, auth, _) {
          if (!auth.isLoggedIn) {
            return LoginScreen(
              onLoginSuccess: (token) => auth.saveToken(token),
            );
          }
          return MainNavigation();
        },
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
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
