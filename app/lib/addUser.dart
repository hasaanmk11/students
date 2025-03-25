import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:app/functions/db_functions.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Student"),
      content: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
              labelText: 'Type Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.calendar_today, color: Colors.deepPurple),
              labelText: 'Type Age',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          const SizedBox(height: 16),

          imagePath != null
              ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.file(
                  File(imagePath!),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
              : Text("No Image Selected"),

          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
              );
              if (result != null) {
                setState(() {
                  imagePath = result.files.single.path;
                });
                print("Image Path: $imagePath");
              } else {
                print("No file selected");
              }
            },
            icon: Icon(Icons.image),
            label: Text("Choose Image"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                ageController.text.isNotEmpty) {
              AddStudents(
                name: nameController.text,
                age: ageController.text,
                image: imagePath ?? '',
              );
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          child: Text("Add", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
