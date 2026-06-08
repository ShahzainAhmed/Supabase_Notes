import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_project/core/supabase_client.dart';
import 'package:supabase_project/features/auth/presentation/screens/auth_screen.dart';
import 'package:supabase_project/features/notes/presentation/screens/add_notes_screen.dart';
import 'package:supabase_project/features/update_notes/presentation/screens/update_notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List notes = [];
  bool isLoading = false;

  Future<void> getNotes() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await supabase.from("Notes").select();
      setState(() {
        notes = result;
      });
      debugPrint("Notes: $notes");
    } catch (e) {
      debugPrint("Error fetching notes: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Home', style: TextStyle(color: Colors.white)),
          actions: [
            PopupMenuButton(
                iconColor: Colors.white,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () async {
                          await supabase.auth.signOut();
                          Get.offAll(() => const AuthScreen());
                        },
                        child: Text('Logout'),
                      ),
                    ])
          ]),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                for (var note in notes)
                  ListTile(
                    onTap: () => Get.to(() => UpdateNotesScreen(
                        note: note,
                        onTap: () async {
                          Get.back();
                          await getNotes();
                        })),
                    title: Text(note['title'] ?? 'No Title'),
                    subtitle: Text(note['description'] ?? 'No Description'),
                    trailing: IconButton(
                        onPressed: () async {
                          try {
                            await supabase
                                .from("Notes")
                                .delete()
                                .eq('id', note['id']);
                            debugPrint(
                              "Deleted note: ${note['title'] ?? 'No Title'}, ${note['description'] ?? 'No Description'}",
                            );

                            await getNotes();
                          } catch (e) {
                            debugPrint("Error deleting note: $e");
                          }
                        },
                        icon: Icon(Icons.delete)),
                  )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Get.to(() => AddNotesScreen(
              onTap: () async {
                Get.back();
                await getNotes();
              },
            )),
      ),
    );
  }
}
