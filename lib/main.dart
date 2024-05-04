import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database_crud_operations/views/student_crud_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  //-------------- Hive initialization -------------------
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  //-------------- Create Hive Database ------------------
  await Hive.openBox("students");
  // -----------------------------------------------------

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive CRUD Operations',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Crud(),
    );
  }
}
