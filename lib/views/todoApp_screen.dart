import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class TodoAppScreen extends StatefulWidget {
  const TodoAppScreen({super.key});

  @override
  State<TodoAppScreen> createState() => _TodoAppScreenState();
}

class _TodoAppScreenState extends State<TodoAppScreen> {
  //--------------------------------------------
  ////......... Hive Database...............
  Box? todoList;
  //........................................

  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> items = [];
  bool isSelected = false;

  @override
  void initState() {
    todoList = Hive.box("todo_list");
    refreshItems();
    super.initState();
  }

// Show Data
  void refreshItems() {
    final data = todoList?.keys.map((key) {
      final item = todoList?.get(key);
      return {"key": key, "title": item["title"], "subtitle": item["subtitle"]};
    }).toList();

    setState(() {
      items = data!.reversed.toList();
      print("Total ${items.length} Items Created..");
    });
  }

// Add Data
  Future<void> createItem(Map<String, dynamic> newItem) async {
    await todoList?.add(newItem);
    refreshItems();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Added", style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black,
    ));
  }

  // Edit Data
  Future<void> updateItem(int itemkey, Map<String, dynamic> item) async {
    await todoList?.put(itemkey, item);
    refreshItems();
  }

  // Delete Data
  Future<void> deleteItem(int itemkey) async {
    await todoList?.delete(itemkey);
    refreshItems();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "An item has been deleted",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
    ));
  }

  void showForm(BuildContext context, int? itemkey) async {
// edit Icon button code
    if (itemkey != null) {
      final exisitingItem =
          items.firstWhere((element) => element["key"] == itemkey);
      titleController.text = exisitingItem["title"];
      subtitleController.text = exisitingItem["subtitle"];
    }

    if (isSelected == false) {
      titleController.clear();
      subtitleController.clear();
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) {
          return Container(
            decoration: const BoxDecoration(
                color: Color(0xff041955),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            height: 500,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 15,
                left: 15,
                right: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Title",
                        hintStyle: TextStyle(color: Color(0xff93B1FC))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    maxLines: 2,
                    controller: subtitleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Subtitle",
                        hintStyle: TextStyle(color: Color(0xff93B1FC))),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // call method for add item
                        if (itemkey == null) {
                          createItem({
                            "title": titleController.text,
                            "subtitle": subtitleController.text
                          });
                        }

                        // call method for update item
                        if (itemkey != null) {
                          updateItem(itemkey, {
                            "title": titleController.text,
                            "subtitle": subtitleController.text
                          });
                        }

                        // clear textfield
                        titleController.clear();
                        subtitleController.clear();
                        Navigator.of(context).pop();
                      },
                      child: itemkey == null
                          ? const Text("Create New")
                          : const Text("Update")),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3450A1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffEB07FF),
        onPressed: () {
          isSelected = false;
          showForm(context, null);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                "Your TODO is empty",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            )
          : Column(
              children: [
                Container(
                  color: const Color(0xff3450A1),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 50.0, bottom: 10, left: 20, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            child: TextFormField(
                              controller: searchController,
                              onChanged: (val) {
                                searchController.text = val;
                                print(searchController.text);
                              },
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xff93B1FC),
                                ),
                                filled: true,
                                fillColor: const Color(0xff3450A1),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Color(0xff93B1FC), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Color(0xff93B1FC), width: 1),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final currentItem = items[index];
                        return Card(
                          color: const Color(0xff041955),
                          margin:
                              const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              currentItem["title"],
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              currentItem["subtitle"],
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        isSelected = true;
                                        showForm(context, currentItem["key"]);
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Color(0xffEB07FF),
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        deleteItem(currentItem["key"]);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color(0xff237BFF),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }
}
