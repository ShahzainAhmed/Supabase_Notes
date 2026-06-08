import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_project/core/supabase_client.dart';
import 'package:supabase_project/features/auth/presentation/widgets/auth_primary_button.dart';

class UpdateNotesScreen extends StatefulWidget {
  final VoidCallback onTap;
  final Map<String, dynamic> note;
  const UpdateNotesScreen({super.key, required this.note, required this.onTap});

  @override
  State<UpdateNotesScreen> createState() => _UpdateNotesScreenState();
}

class _UpdateNotesScreenState extends State<UpdateNotesScreen> {
  final title = TextEditingController();
  final description = TextEditingController();
  bool isLoading = false;

  Future<void> updateNote() async {
    try {
      setState(() {
        isLoading = true;
      });
      await supabase.from("Notes").update({
        'title': title.text,
        'description': description.text,
      }).eq('id', widget.note['id']); // eq = equals to
      print("Note updated: ${title.text}, ${description.text}");
    } catch (e) {
      print("Error updating note: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    title.text = widget.note['title'] ?? "";
    description.text = widget.note['description'] ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Notes"),
        leading: IconButton(
          onPressed: widget.onTap,
          icon: Icon(Icons.arrow_back_ios_new),
        ),
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
                : AuthPrimaryButton(text: "Update Note", onPressed: updateNote),
          ],
        ),
      ),
    );
  }
}
