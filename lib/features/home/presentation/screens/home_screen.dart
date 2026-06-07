import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_project/core/supabase_client.dart';
import 'package:supabase_project/features/auth/presentation/screens/auth_screen.dart';
import 'package:supabase_project/features/notes/presentation/screens/add_notes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );

      Get.offAll(() => const AuthScreen());
    } catch (e) {
      debugPrint("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() => const AddNotesScreen()),
      ),
    );
  }
}
