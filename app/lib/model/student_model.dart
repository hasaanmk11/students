class StudentModel {
  int? key;
  String name;
  String age;
  String images;
  StudentModel({
    required this.age,
    required this.name,
    this.key,
    required this.images,
  });

  static StudentModel fromMap(Map<String, Object?> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final age = map['age'] as String;
    final images = (map['image'] as String);

    return StudentModel(age: age, name: name, key: id, images: images);
  }
}
