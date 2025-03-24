import 'dart:io';

import 'package:app/functions/db_functions.dart';
import 'package:flutter/material.dart';

class GridPage extends StatelessWidget {
  const GridPage({super.key});

  @override
  Widget build(BuildContext context) {
    getAllsudents();
    return Scaffold(
      appBar: AppBar(title: Text("Grid View")),
      body: ValueListenableBuilder(
        valueListenable: StudentListener,
        builder: (context, value, child) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: value.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.blue,

                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.file(
                      File(value[index].images),

                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Name: ${value[index].name}",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Age: ${value[index].age}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
