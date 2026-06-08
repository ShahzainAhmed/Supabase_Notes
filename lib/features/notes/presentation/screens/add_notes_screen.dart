import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_project/features/auth/presentation/widgets/auth_primary_button.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({super.key});

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  final title = TextEditingController();
  final description = TextEditingController();
  final supabase = Supabase.instance.client;
  bool isLoading = false;

  Future<void> addNote() async {
    try {
      setState(() {
        isLoading = true;
      });
      await supabase.from("Notes").insert({
        'title': title.text,
        'description': description.text,
      });
      print("Note added: ${title.text}, ${description.text}");
    } catch (e) {
      print("Error adding note: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notes"),
        // leading: IconButton(
        //   onPressed: widget.onTap,
        //   icon: Icon(Icons.arrow_back_ios_new),
        // ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            TextFormField(
              controller: title,
              decoration: InputDecoration(hintText: "Title"),
            ),
            SizedBox(height: 20.h),
            TextFormField(
              controller: description,
              decoration: InputDecoration(hintText: "Description"),
            ),
            SizedBox(height: 60.h),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : AuthPrimaryButton(text: "Add Note", onPressed: addNote),
          ],
        ),
      ),
    );
  }
}
