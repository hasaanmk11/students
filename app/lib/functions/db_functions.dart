import 'package:app/model/student_model.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

ValueNotifier<List<StudentModel>> StudentListener = ValueNotifier([]);
ValueNotifier<List<StudentModel>> filteredStudents = ValueNotifier([]);

late Database _dataBase;
Future<void> InitilizeStudent() async {
  _dataBase = await openDatabase(
    "Students.db",
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE student (id INTEGER PRIMARY KEY, name TEXT,age TEXT,image TEXT)',
      );
    },
  );
}

Future<void> getAllsudents() async {
  final value = await _dataBase.rawQuery("SELECT * FROM student");
  final students = value.map((e) => StudentModel.fromMap(e));
  filteredStudents.value.clear();
  StudentListener.value.clear();

  StudentListener.value.addAll(students);
  filteredStudents.value.addAll(students);

  StudentListener.notifyListeners();
  filteredStudents.notifyListeners();
}

Future<void> AddStudents({
  required String name,
  required String age,
  required String image,
}) async {
  await _dataBase.rawInsert(
    'INSERT INTO student(name, age, image) VALUES(?, ?, ?)',
    [name, age, image],
  );
  await getAllsudents();
}

Future<void> deleteSudents(id) async {
  await _dataBase.rawDelete('DELETE FROM student WHERE id = ?', [id]);
  await getAllsudents();
}

Future<void> editStudents(
  int id,
  String newName,
  String newAge,
  String image,
) async {
  await _dataBase.rawUpdate(
    'UPDATE student SET name = ?, age = ?, image=? WHERE id = ?',
    [newName, newAge, image, id],
  );
  await getAllsudents();
}

TextEditingController searchController = TextEditingController();

void searchStudents(String query) {
  if (query.isEmpty) {
    filteredStudents.value.clear();
    filteredStudents.value.addAll(StudentListener.value);
  } else {
    filteredStudents.value =
        StudentListener.value
            .where(
              (student) =>
                  student.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
  }
  filteredStudents.notifyListeners();
}
