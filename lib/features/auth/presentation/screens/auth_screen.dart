import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_project/core/supabase_client.dart';
import 'package:supabase_project/features/home/presentation/screens/home_screen.dart';

import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoginMode = true;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.toString().trim(),
      );

      if (response.user != null && response.session != null) {
        print("Login successful");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        Get.offAll(() => HomeScreen());
      }
    } catch (e) {
      print("Error logging in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _continueWithGoogle() async {
    try {
      // Google Sign In Code START
      GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: dotenv.env['WEB_CLIENT']!,
        clientId: Platform.isIOS
            ? dotenv.env['IOS_CLIENT']!
            : dotenv.env['ANDROID_CLIENT']!,
      );
      GoogleSignInAccount account = await googleSignIn.authenticate();
      String idToken = account.authentication.idToken ?? '';
      final authorization = await account.authorizationClient
              .authorizationForScopes(['email', 'profile']) ??
          await account.authorizationClient
              .authorizeScopes(['email', 'profile']);
      // Google Sign In Code END

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );
      if (response.user != null && response.session != null) {
        print("Continue with Google Success");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in successful')),
        );
        Get.to(() => HomeScreen());
      }
    } catch (e) {
      print("Failed with Google sign-in: $e");
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return; // if screen is gone, don't continue

      if (response.user != null) {
        print("session: ${response.session}");
        print("Signup successful");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      print("Error signing up: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  void _onForgotPassword() {
    // TODO: Connect this with Supabase password reset later.
    debugPrint('Forgot password tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _AuthHeader(),
                    const SizedBox(height: 32),
                    _AuthCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isLoginMode ? 'Welcome Back' : 'Create Account',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isLoginMode
                                ? 'Login to continue learning Supabase.'
                                : 'Sign up to start your Supabase journey.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.black54,
                                ),
                          ),
                          const SizedBox(height: 24),
                          AuthTextField(
                            controller: _emailController,
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 16),
                          AuthTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            obscureText: !_isPasswordVisible,
                            prefixIcon: Icons.lock_outline,
                            validator: _validatePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                          if (_isLoginMode) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _onForgotPassword,
                                child: const Text('Forgot Password?'),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : AuthPrimaryButton(
                                  text: _isLoginMode ? 'Login' : 'Sign Up',
                                  onPressed: _isLoginMode ? _login : _signUp,
                                ),
                          const SizedBox(height: 16),
                          AuthPrimaryButton(
                            text: "Continue with Google",
                            onPressed: _continueWithGoogle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isLoginMode
                                    ? "Don't have an account?"
                                    : 'Already have an account?',
                                style: const TextStyle(color: Colors.black54),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoginMode = !_isLoginMode;
                                  });
                                },
                                child: Text(_isLoginMode ? 'Sign Up' : 'Login'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email';
    }

    if (!email.contains('@')) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return 'Please enter your password';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 84,
          width: 84,
          decoration: BoxDecoration(
            color: const Color(0xFF2F80ED).withOpacity(0.12),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.lock_person_outlined,
            color: Color(0xFF2F80ED),
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Supabase Auth',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Clean starter UI for login, signup, and logout flow.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
              ),
        ),
      ],
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
