import 'package:flutter/material.dart';
import 'package:supabase_project/features/auth/presentation/widgets/auth_primary_button.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onTap;
  const HomeScreen({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: AuthPrimaryButton(
          text: "Logout",
          onPressed: () => onTap(),
        ),
      ),
    );
  }
}
