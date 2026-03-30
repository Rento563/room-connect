import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.tenant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            DropdownButton<UserRole>(
              value: _selectedRole,
              items: [
                DropdownMenuItem(value: UserRole.tenant, child: Text('Tenant')),
                DropdownMenuItem(
                  value: UserRole.landowner,
                  child: Text('Landowner'),
                ),
              ],
              onChanged: (value) => setState(() => _selectedRole = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _signup, child: const Text('Sign Up')),
          ],
        ),
      ),
    );
  }

  void _signup() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signup(
      _nameController.text,
      _emailController.text,
      _phoneController.text,
      _passwordController.text,
      _selectedRole,
    );
    if (!mounted) return;
    if (authProvider.isAuthenticated) {
      if (authProvider.currentUser!.role == UserRole.tenant) {
        context.go('/tenant_home');
      } else {
        context.go('/landowner_dashboard');
      }
    }
  }
}
