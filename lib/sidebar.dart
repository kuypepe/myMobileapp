// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/Goal_model.dart';
import 'models/goalList_provider.dart';

class Sidebar extends StatefulWidget {
  final Function(Goal) callback;

  const Sidebar({Key? key, required this.callback}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  TextEditingController yourTitle = TextEditingController();
  TextEditingController durationInDays = TextEditingController();
  late final goalListProvider;

  @override
  void initState() {
    super.initState();
    goalListProvider = Provider.of<GoalListProvider>(context, listen: false);
  }

  List<Widget> buildGoalTiles(BuildContext context) {
    List<Goal> goalList = goalListProvider.goalList;
    return goalList
        .map((e) => ListTile(
              title: Text(e.name!),
              onTap: () {
                widget.callback(e);
                Navigator.pop(context);
              },
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 212, 5, 164),
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Create Your goal'),
                            content: Container(
                              height:
                                  200, // Increased height to accommodate all fields
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 90, 0),
                                    child: Text('Input Your Title Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  TextField(
                                    controller: yourTitle,
                                    decoration: InputDecoration(
                                      hintText: 'Your workout title',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                                    child: Text('Input Your duration in days',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  TextField(
                                    controller: durationInDays,
                                    decoration: InputDecoration(
                                      hintText: 'Duration in Days',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              Container(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close),
                                  label: Text('Close'),
                                  style: ElevatedButton.styleFrom(
                                      // primary: Colors.red, // Make the button red
                                      ),
                                ),
                              ),
                              Container(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    String title = yourTitle.text;
                                    int days =
                                        int.tryParse(durationInDays.text) ?? 0;

                                    print(title);
                                    print(days);
                                    if (title.isNotEmpty && days > 0) {
                                      setState(() {
                                        goalListProvider.addGoal(title, days);
                                        yourTitle.clear();
                                        durationInDays.clear();
                                      });

                                      Navigator.pop(context);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Invalid Input'),
                                            content: Text(
                                                'Please enter a valid title and duration in days.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text('Add'),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.rule),
                    label: Text('Create Your Goal'),
                  ),
                ],
              ),
            ),
          ),
          // (goalListProvider.goalList.isEmpty ? const Text('No Data'):(...buildGoalTiles(context)))

          // ListTile(
          //   title: Text('ddd'),
          // )

          if (goalListProvider.goalList.isEmpty)
            Center(child: Text('No Data'))
          else
            ...buildGoalTiles(context),
        ],
      ),
    );
  }
}
