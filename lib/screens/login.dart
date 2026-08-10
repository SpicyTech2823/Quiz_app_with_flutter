import 'package:flutter/material.dart';
import 'package:quiz_app/screens/home.dart';
import 'package:quiz_app/screens/register.dart';
import 'package:quiz_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showMessage('Please enter your email and password');
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      _showMessage('Login successful');
      // persist auth token and username for future sessions
      final token = result['data']?['token'] as String?;
      final user = result['data']?['user'] as Map<String, dynamic>?;
      final username = user?['username'] as String? ?? user?['name'] as String?;
      final email = user?['email'] as String? ?? _emailController.text.trim();
      if (token != null) {
        await AuthService.saveAuthToken(token);
      }
      if (username != null && username.isNotEmpty) {
        await AuthService.saveUsername(username);
      }
      if (email.isNotEmpty) {
        await AuthService.saveEmail(email);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainScreen(username: username ?? 'User'),
        ),
      );
    } else {
      _showMessage(result['message'] ?? 'Login failed');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
