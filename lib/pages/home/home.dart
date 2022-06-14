import 'package:fasko_mobile/models/fasko_user.dart';
import 'package:fasko_mobile/models/task.dart';
import 'package:fasko_mobile/models/user_data.dart';
import 'package:fasko_mobile/services/db.dart';
import 'package:fasko_mobile/services/local_storage.dart';
import 'package:fasko_mobile/widgets/task_list.dart';
import 'package:flutter/material.dart';
import 'package:fasko_mobile/widgets/bar.dart';
import "package:provider/provider.dart";
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.toggleView, required this.toTask}) : super(key: key);

  final Function toggleView;
  final Function toTask;

  @override
  State<HomePage> createState() => _HomePageState();
}

// icon 'dehaze' for burger
// icon 'drag handle' for burger
// icon 'delete sweep' for delete
// icon 'filter list'
// icon 'filter list alt'
// icon 'history' for start
// icon 'hourglass ...' for start
// icon 'access alarm' for start

// account_balance_wallet card_giftcard

class _HomePageState extends State<HomePage> {
  Function? sortCompare;
  List<String> showLists = [];
  final LocalStorageService localStorage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    localStorage.getSortCompare().then((value) {
      setState(() {
        sortCompare = value;
      });
    });
    localStorage.getShowLists().then((value) {
      setState(() {
        showLists = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<FaskoUser?>()!;
    final userData = context.watch<UserData>();

    return StreamProvider<List<Task>>.value(
      value: DatabaseService(uid: user.uid).tasks,
      initialData: const [],
      child: Scaffold(
        appBar: FaskoAppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () async =>
                  await launchUrl(Uri.parse('https://www.buymeacoffee.com/koshchei')),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.drag_handle),
              onPressed: () {
                widget.toggleView('settings');
              },
            ),
            const Padding(padding: EdgeInsets.only(right: 5)),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 7, right: 5),
                        decoration: BoxDecoration(
                          border: const Border(
                            top: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
                            bottom: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
                            left: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
                            right: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<Function>(
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              elevation: 1,
                              icon: const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(Icons.keyboard_arrow_down),
                              ),
                              hint: const Text('Sort by'),
                              value: sortCompare,
                              items: const [
                                DropdownMenuItem(value: Task.compareByDate, child: Text("Date")),
                                DropdownMenuItem(value: Task.compareByLevel, child: Text("Level")),
                              ],
                              onChanged: (Function? value) {
                                setState(() {
                                  sortCompare = value;
                                });
                                localStorage.setSortCompare(value);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 7, left: 5),
                        decoration: BoxDecoration(
                          border: const Border(
                            top: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
                            bottom: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
                            left: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
                            right: BorderSide(color: Color.fromARGB(255, 238, 238, 238)),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              elevation: 1,
                              icon: const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(Icons.keyboard_arrow_down),
                              ),
                              hint: const Text('Show'),
                              items: userData.lists
                                  .map((list) => DropdownMenuItem(
                                        value: list,
                                        child: Text(
                                          list,
                                          style: showLists.contains(list)
                                              ? const TextStyle(
                                                  color: Color.fromARGB(255, 193, 54, 86))
                                              : null,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  if (value != null) {
                                    showLists.contains(value)
                                        ? showLists.remove(value)
                                        : showLists.add(value);
                                  }
                                });
                                localStorage.setShowLists(showLists);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TaskList(toTask: widget.toTask, compare: sortCompare, showLists: showLists),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Navigator.pushNamed(context, '/task');
            widget.toTask(null);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color.fromARGB(255, 193, 54, 86),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
