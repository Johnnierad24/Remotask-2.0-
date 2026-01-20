import 'package:flutter/material.dart';
import '../api_service.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String token) onLoginSuccess;
  const LoginScreen({required this.onLoginSuccess});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final token = await ApiService.login(_email, _password);
    setState(() { _loading = false; });
    if (token != null) {
      widget.onLoginSuccess(token);
    } else {
      setState(() { _error = 'Invalid credentials'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign In', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 24),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (v) => _email = v,
                  validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onChanged: (v) => _password = v,
                  validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 characters',
                ),
                SizedBox(height: 24),
                if (_error != null) ...[
                  Text(_error!, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 12),
                ],
                ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
