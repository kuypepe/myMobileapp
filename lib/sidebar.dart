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
  late final GoalListProvider goalListProvider;

  @override
  void initState() {
    super.initState();
    goalListProvider = Provider.of<GoalListProvider>(context, listen: false);
  }

  void showEditGoalDialog(Goal goal) {
    yourTitle.text = goal.name!;
    durationInDays.text = goal.durationInDays.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Your Goal'),
          content: Container(
            height: 200,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 90, 0),
                  child: Text('Edit Your Title Name',
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
                  child: Text('Edit Your duration in days',
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
                  keyboardType: TextInputType.number,
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
                style: ElevatedButton.styleFrom(),
              ),
            ),
            Container(
              child: ElevatedButton.icon(
                onPressed: () {
                  String title = yourTitle.text;
                  int days = int.tryParse(durationInDays.text) ?? 0;

                  if (title.isNotEmpty && days > 0) {
                    setState(() {
                      // Update the goal using GoalListProvider
                      goalListProvider.updateGoal(goal, title, days);
                    });
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Invalid Input'),
                          content: Text(
                            'Please enter a valid title and duration in days.',
                          ),
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
                icon: Icon(Icons.save),
                label: Text('Save'),
              ),
            ),
          ],
        );
      },
    );
  }

  void showDeleteGoalDialog(Goal goal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Goal'),
          content: Text('Are you sure you want to delete this goal?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  goalListProvider.removeGoal(goal);
                });
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> buildGoalTiles(BuildContext context) {
    List<Goal> goalList = goalListProvider.goalList;
    return goalList.map((goal) {
      return Dismissible(
        key: Key(goal.id),
        background: Container(
          color: Colors.blue,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.edit, color: Colors.white),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            showEditGoalDialog(goal);
            return false;
          } else if (direction == DismissDirection.endToStart) {
            showDeleteGoalDialog(goal);
            return false;
          }
          return false;
        },
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(goal.name!),
              SizedBox(height: 4),
              Text(
                'Duration in Days: ${goal.durationInDays}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          onTap: () {
            widget.callback(goal);
            Navigator.pop(context);
          },
        ),
      );
    }).toList();
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
                              height: 200,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 90, 0),
                                    child: Text('Your Title Name',
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
                                    child: Text('Your duration in days',
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
                                    keyboardType: TextInputType.number,
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
                                  style: ElevatedButton.styleFrom(),
                                ),
                              ),
                              Container(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    String title = yourTitle.text;
                                    int days =
                                        int.tryParse(durationInDays.text) ?? 0;

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
                                              'Please enter a valid title and duration in days.',
                                            ),
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
          if (goalListProvider.goalList.isEmpty)
            Center(child: Text('No Data'))
          else
            ...buildGoalTiles(context),
        ],
      ),
    );
  }
}
