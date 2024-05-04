import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  // ------------------------------

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();

// ......... Hive Database........
  Box? studentBox;

  @override
  void initState() {
    studentBox = Hive.box("students");
    super.initState();
  }
  // ..............................

  // ==============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hive Database",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: idController,
                                        decoration: const InputDecoration(
                                            hintText: "Id"),
                                        keyboardType: TextInputType.number,
                                      ),
                                      TextFormField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                            hintText: "Name"),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            studentBox?.put(
                                                idController.text,
                                                nameController
                                                    .text); // Key value pair
                                            idController.clear();
                                            nameController.clear();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('ADD'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Text(
                        "Add Student",
                        style: TextStyle(fontSize: 18),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: idController,
                                        decoration: const InputDecoration(
                                            hintText: "Id"),
                                        keyboardType: TextInputType.number,
                                      ),
                                      TextFormField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                            hintText: "Name"),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            studentBox?.put(idController.text,
                                                nameController.text);
                                            idController.clear();
                                            nameController.clear();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('UPDATE'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Text(
                        "Update Student",
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: idController,
                                        decoration: const InputDecoration(
                                            hintText: "Id"),
                                        keyboardType: TextInputType.number,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            studentBox
                                                ?.delete(idController.text);
                                            idController.clear();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('DELETE'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Text(
                        "Delete Student",
                        style: TextStyle(fontSize: 18),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: idController,
                                        decoration: const InputDecoration(
                                            hintText: "Id"),
                                        keyboardType: TextInputType.number,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            print(studentBox
                                                ?.get(idController.text));
                                            idController.clear();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('SHOW'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Text(
                        "Show Student",
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              ),
            ),

            // Show All data
            ValueListenableBuilder(
                valueListenable: studentBox!.listenable(),
                builder: (context, Box mystudentdata, _) {
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: mystudentdata.keys.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(mystudentdata.keyAt(index)),
                            subtitle: Text(mystudentdata.getAt(index)),
                          );
                        }),
                  );
                })
          ],
        ),
      ),
    );
  }
}
