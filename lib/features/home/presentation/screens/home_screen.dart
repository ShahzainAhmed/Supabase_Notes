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
      // With StreamBuilder
      body: StreamBuilder(
          stream: supabase.from("Notes").stream(primaryKey: ['id']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final notes = snapshot.data ?? [];

            if (notes.isEmpty) {
              return const Center(child: Text('No Notes Found'));
            }
            return ListView(
              children: [
                for (var note in notes)
                  ListTile(
                    onTap: () => Get.to(() => UpdateNotesScreen(note: note)),
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
                          } catch (e) {
                            debugPrint("Error deleting note: $e");
                          }
                        },
                        icon: Icon(Icons.delete)),
                  )
              ],
            );
          }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Get.to(() => AddNotesScreen()),
      ),
    );
  }
}


/* 

=====================================================
OLD APPROACH (WITHOUT REALTIME)
=====================================================

Uses:
- getNotes()
- List notes
- setState()
- Manual refresh

Data fetched once using:

await supabase.from("Notes").select();

=====================================================
NEW APPROACH (WITH REALTIME)
=====================================================

Uses:
- StreamBuilder
- stream(primaryKey: ['id'])

Automatically updates UI when:
- Note added
- Note updated
- Note deleted

No manual refresh required.
=====================================================

List notes = [];
  bool isLoading = false;

  // Or for Real Time Updates just use Stream Builder and delete the function getStreamNotes()

  // Use this for Real Time Updates with Supabase
  Future<void> getStreamNotes() async {
    try {
      supabase.from("Notes").stream(primaryKey: ['id']).listen((data) {
        setState(() {
          notes = data;
        });
      });
    } catch (e) {
      print("Error streaming notes: $e");
    }
  }

  // Use this for without Real Time Updates
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

  // Without StreamBuilder
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                for (var note in notes)
                  ListTile(
                    onTap: () => Get.to(() => UpdateNotesScreen(note: note)),
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

                            await getStreamNotes();
                          } catch (e) {
                            debugPrint("Error deleting note: $e");
                          }
                        },
                        icon: Icon(Icons.delete)),
                  )
              ],
            ),
 */