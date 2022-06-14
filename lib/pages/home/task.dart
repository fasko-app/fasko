import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fasko_mobile/models/fasko_user.dart';
import 'package:fasko_mobile/models/task.dart';
import 'package:fasko_mobile/models/user_data.dart';
import 'package:fasko_mobile/services/db.dart';
import 'package:flutter/material.dart';
import 'package:fasko_mobile/widgets/bar.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key, required this.toggleView, this.task}) : super(key: key);

  final Function toggleView;
  final Task? task;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

// icon 'check' for add
// icon 'done' for add
// icon 'create' for edit
// icon 'edit' for edit

class _TaskPageState extends State<TaskPage> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String description;
  late DateTime? date;
  late String level;
  late String? selectedList;
  Color listColor = const Color.fromARGB(255, 119, 119, 119);

  String newList = '';

  Future<void> _selectDate(BuildContext context) async {
    final dataTimeNow = DateTime.now();
    DateTime? dataPicker = await showDatePicker(
      context: context,
      initialDate: date ?? dataTimeNow,
      firstDate: DateTime(dataTimeNow.year),
      lastDate: DateTime(dataTimeNow.year + 10),
    );

    if (dataPicker != null && dataPicker != date) {
      setState(() {
        date = dataPicker;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      title = widget.task!.title;
      description = widget.task!.description;
      date = widget.task!.date?.toDate();
      level = widget.task!.level;
      selectedList = widget.task!.list;
    } else {
      title = '';
      description = '';
      date = null;
      level = 'A';
      selectedList = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<FaskoUser?>()!;
    final userData = context.watch<UserData>();
    final DatabaseService db = DatabaseService(uid: user.uid);

    return Scaffold(
      appBar: FaskoAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.toggleView('home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done, color: Color.fromARGB(255, 82, 202, 86)),
            onPressed: () async {
              if (_formKey.currentState!.validate() && selectedList != null) {
                widget.toggleView('home');
                if (widget.task == null) {
                  await db.addTask(title, description, level, selectedList!, false,
                      date == null ? null : Timestamp.fromDate(date!));
                } else {
                  await db.updateTask(widget.task!.id, title, description, level, selectedList!,
                      false, date == null ? null : Timestamp.fromDate(date!));
                }
              } else if (selectedList == null) {
                setState(() {
                  listColor = const Color.fromARGB(255, 193, 54, 86);
                });
              }
            },
          ),
          const Padding(padding: EdgeInsets.only(right: 5)),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 15),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        iconSize: 0,
                        value: level,
                        elevation: 1,
                        dropdownColor: Colors.white,
                        onChanged: (String? value) {
                          setState(() {
                            level = value!;
                          });
                        },
                        selectedItemBuilder: (context) {
                          return Task.levelColor.keys.map(
                            (value) {
                              return Text(
                                value,
                                style: TextStyle(
                                  color: Task.levelColor[value],
                                  fontSize: 26,
                                  height: 1.3,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ).toList();
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: 'A',
                            child: Text(
                              'A',
                              style: TextStyle(
                                color: Color.fromARGB(255, 238, 17, 17),
                                fontSize: 26,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: 'B',
                            child: Text(
                              'B',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 157, 10),
                                fontSize: 26,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.center,
                            value: 'C',
                            child: Text(
                              'C',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 233, 35),
                                fontSize: 26,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: title,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 30),
                        border: InputBorder.none,
                        hintText: 'Title',
                      ),
                      style: const TextStyle(fontSize: 26, height: 1.3),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() => title = value);
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                initialValue: description,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 15),
                  border: InputBorder.none,
                  hintText: 'Description',
                ),
                style: const TextStyle(fontSize: 18, height: 1.3),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Text(
                        selectedList ?? 'Choose list',
                        style: TextStyle(
                          fontSize: 18,
                          color: listColor,
                          height: 1.3,
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            final sheetUserData = context.watch<UserData?>();

                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom + 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: (sheetUserData != null
                                        ? sheetUserData.lists.map<Widget>((list) {
                                            return ListTile(
                                              contentPadding:
                                                  const EdgeInsets.only(left: 30, right: 20),
                                              title: Text(list,
                                                  style:
                                                      const TextStyle(fontSize: 18, height: 1.3)),
                                              trailing: IconButton(
                                                icon: const Icon(Icons.delete_outline),
                                                color: const Color.fromARGB(255, 193, 54, 86),
                                                onPressed: () async {
                                                  // delete list by updating
                                                  if (sheetUserData.lists.remove(list)) {
                                                    if (selectedList == list) {
                                                      widget.toggleView('home');
                                                      Navigator.pop(context);
                                                    }
                                                    await db.deleteList(sheetUserData.lists, list);
                                                  }
                                                },
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  selectedList = list;
                                                  listColor =
                                                      const Color.fromARGB(255, 119, 119, 119);
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          }).toList()
                                        : <Widget>[]) +
                                    [
                                      const Divider(height: 0),
                                      ListTile(
                                        contentPadding: const EdgeInsets.only(left: 30, right: 20),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            newList = newList.trim();
                                            if (newList.isNotEmpty) {
                                              userData.lists.add(newList);
                                              db.updateLists(userData.lists);
                                              setState(() {
                                                selectedList = newList;
                                              });
                                              Navigator.pop(context);
                                            } else {
                                              // show message
                                            }
                                          },
                                        ),
                                        title: TextField(
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'New list',
                                          ),
                                          style: const TextStyle(fontSize: 18, height: 1.3),
                                          onChanged: (value) {
                                            setState(() {
                                              newList = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    InkWell(
                      child: Text(
                        date != null ? '${date!.day}.${date!.month}.${date!.year}' : 'Choose date',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 119, 119, 119),
                          height: 1.3,
                        ),
                      ),
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
PopupMenuButton(
                      child: Text(
                        level,
                        style: TextStyle(
                          fontSize: 26,
                          height: 1.3,
                          color: Task.levelColor[level],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onSelected: (String value) {
                        setState(() {
                          level = value;
                        });
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'A',
                          child: Text(
                            'A',
                            style: TextStyle(color: Color.fromARGB(255, 238, 17, 17)),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'B',
                          child: Text(
                            'B',
                            style: TextStyle(color: Color.fromARGB(255, 255, 157, 10)),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'C',
                          child: Text(
                            'C',
                            style: TextStyle(color: Color.fromARGB(255, 255, 233, 35)),
                          ),
                        ),
                      ],
                    ),
*/



/*
Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: userData.lists.map<Widget>((list) {
                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 30),
                                        title: Text(list),
                                        trailing: const IconButton(
                                          padding: EdgeInsets.zero,
                                          alignment: Alignment.centerRight,
                                          icon: Icon(Icons.delete_outline),
                                          color:
                                              Color.fromARGB(255, 193, 54, 86),
                                          onPressed:
                                              null, // delete list by updating
                                        ),
                                        onTap: () {
                                          setState(() {
                                            this.list = list;
                                            listColor = const Color.fromARGB(
                                                255, 119, 119, 119);
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    }).toList() +
                                    [
                                      const Divider(height: 0),
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 30),
                                        title: const Text('Add list'),
                                        trailing: const Icon(Icons.add),
                                        onTap: () {}, // create list
                                      ),
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 30),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {},
                                        ),
                                        title: TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(top: 15),
                                            border: InputBorder.none,
                                            hintText: 'New list',
                                          ),
                                          style: const TextStyle(
                                              fontSize: 18, height: 1.3),
                                          onChanged: (value) {
                                            setState(() {
                                              description = value;
                                            });
                                          },
                                        ),
                                        onTap: () {}, // create list
                                      ),
                                    ],
                              ),
                            );
*/


/*
ListView.builder(
                              padding: EdgeInsets.all(10),
                              itemCount: userData.lists.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(userData.lists[index]),
                                  onTap: () {
                                    setState(() {
                                      list = userData.lists[index];
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
*/

/*
child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 30),
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
                style: const TextStyle(fontSize: 26, height: 1.3),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() => title = value);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 15, bottom: 30),
                  border: InputBorder.none,
                  hintText: 'Description',
                ),
                style: const TextStyle(fontSize: 18, height: 1.3),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              OutlinedButton.icon(
                onPressed: () {
                  _selectDate(context);
                },
                // put icon on right side by switch with labelй
                label: const Icon(
                  Icons.calendar_today,
                  color: Color.fromARGB(255, 102, 187, 106),
                ),
                icon: Text(_date == null ? '' : _date.toString()),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(60)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    side: MaterialStateProperty.all<BorderSide>(BorderSide(
                        color: _date == null
                            ? const Color.fromARGB(255, 224, 224, 224)
                            : const Color.fromARGB(255, 102, 187, 106)))),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          borderRadius: BorderRadius.circular(5),
                          elevation: 1,
                          style: const TextStyle(fontSize: 18, height: 1.3),
                          dropdownColor: Colors.white,
                          value: level,
                          items: const [
                            DropdownMenuItem(
                              value: 'A',
                              child: Text(
                                'A',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 238, 17, 17)),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'B',
                              child: Text(
                                'B',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 157, 10)),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'C',
                              child: Text(
                                'C',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 233, 35)),
                              ),
                            ),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              level = value ?? 'A';
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 224, 224, 224))),
                        child: DropdownButton<String>(
                          hint: const Text('List'),
                          dropdownColor: Colors.grey[100],
                          isDense: false,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          borderRadius: BorderRadius.circular(5),
                          elevation: 0,
                          value: list,
                          items: userData.lists.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              list = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
*/

/*
Row(
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      value: 'A',
                      items: const [
                        DropdownMenuItem(value: 'A', child: Text('A')),
                        DropdownMenuItem(value: 'B', child: Text('B')),
                        DropdownMenuItem(value: 'C', child: Text('C')),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          level = value ?? 'A';
                        });
                      },
                    ),
                  ),
                ],
              )
*/
