import 'dart:io';

import 'package:app/addUser.dart';
import 'package:app/functions/db_functions.dart';
import 'package:app/gridpag.dart';
import 'package:app/model/student_model.dart';
import 'package:app/pageDlt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitilizeStudent();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    getAllsudents();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beautiful ListView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    getAllsudents();
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (query) => searchStudents(query),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                    labelText: 'Search here..',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: filteredStudents,
                  builder: (context, value, child) {
                    return value.isEmpty
                        ? Center(child: Text("No students found!"))
                        : ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              UserDtls(data: value[index]),
                                    ),
                                  );
                                },
                                subtitle: Text(value[index].age),
                                leading:
                                    value[index].images.isNotEmpty
                                        ? Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Colors.grey[300],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: Image.file(
                                              File(value[index].images),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                        : Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                          color: Colors.grey,
                                        ),

                                title: Text(
                                  value[index].name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        _showEditDialog(context, value[index]);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        deleteSudents(value[index].key);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                  },
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(actions: [AddUser()]);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    color: const Color.fromARGB(255, 52, 35, 35),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return GridPage();
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.grid_view_sharp, color: Colors.lightBlue),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showEditDialog(BuildContext context, StudentModel student) {
  ValueNotifier image = ValueNotifier(String);
  TextEditingController nameController = TextEditingController(
    text: student.name,
  );
  TextEditingController ageController = TextEditingController(
    text: student.age,
  );

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Edit Student"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Enter Name"),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: "Enter Age"),
              keyboardType: TextInputType.number,
            ),
            (student.images.isEmpty)
                ? Icon(Icons.person)
                : Container(
                  width: 50,
                  height: 50,
                  child: Image.file(File(student.images)),
                ),
            TextButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                );
                if (result != null) {
                  image.value = result.files.single.path;
                  image.notifyListeners();
                }
              },
              child: Text("Choose image"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              editStudents(
                student.key!,
                nameController.text,
                ageController.text,
                image.value,
              );
              Navigator.pop(context);
            },
            child: Text("Save", style: TextStyle(color: Colors.blue)),
          ),
        ],
      );
    },
  );
}
