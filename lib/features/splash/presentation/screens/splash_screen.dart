import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_project/core/supabase_client.dart';
import 'package:supabase_project/features/auth/presentation/screens/auth_screen.dart';
import 'package:supabase_project/features/home/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final session = supabase.auth.currentSession;

    if (!mounted) return;

    if (session != null) {
      print("Session is: $session");
      Get.offAll(() => const HomeScreen());
    } else {
      print("Session is not live: $session");
      Get.offAll(() => const AuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
