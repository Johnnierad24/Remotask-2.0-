import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'register_screen.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String token) onLoginSuccess;
  const LoginScreen({required this.onLoginSuccess});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    
    try {
      final response = await _apiService.login(_email, _password);
      final token = response['token'] as String?;
      
      setState(() { _loading = false; });
      
      if (token != null) {
        widget.onLoginSuccess(token);
      } else {
        setState(() { _error = 'Login failed: No token received'; });
      }
    } catch (e) {
      setState(() { 
        _loading = false; 
        _error = 'Invalid credentials or server error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.work,
                    size: 40,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                SizedBox(height: 24),
                
                // App name
                Text(
                  'CANARY',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Welcome back! Let\'s get to work',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 40),
                
                // Login form card
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Continue to your dashboard',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32),
                        
                        // Email field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined, color: AppTheme.textSecondary),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (v) => _email = v,
                          validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
                        ),
                        SizedBox(height: 16),
                        
                        // Password field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline, color: AppTheme.textSecondary),
                          ),
                          obscureText: true,
                          onChanged: (v) => _password = v,
                          validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 characters',
                        ),
                        SizedBox(height: 24),
                        
                        // Error message
                        if (_error != null) ...[
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _error!,
                              style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                        
                        // Login button
                        ElevatedButton(
                          onPressed: _loading ? null : _login,
                          child: _loading 
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text('Sign In'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Forgot password
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password
                            },
                            child: Text('Forgot password?'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(
                              onRegisterSuccess: widget.onLoginSuccess,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
