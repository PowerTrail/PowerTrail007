import 'package:flutter/material.dart';
import '../../../core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _confirmController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Sign Up'),
                ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      // Get auth provider synchronously before the await
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Perform async operation
      await authProvider.signIn(
        _emailController.text.trim(), 
        _passwordController.text.trim()
      );
      
      // After the await, check if still mounted before accessing context
      if (!mounted) return;
      
      // Now we can use context safely if needed
    } catch (e) {
      // After the await, check if still mounted before accessing context
      if (!mounted) return;
      
      // Now we can use context safely
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    } finally {
      // After the await, check if still mounted before calling setState
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }
}