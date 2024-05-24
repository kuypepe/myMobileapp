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
          title: Text('កែប្រែគំរោង'),
          content: Container(
            height: 200,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 90, 0),
                  child: Text(
                    'កែឈ្មោះគំរោងរបស់អ្នក',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: yourTitle,
                  decoration: InputDecoration(
                    hintText: 'ឈ្មោះគំរោងរបស់អ្នក',
                    border: OutlineInputBorder(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: Text(
                    'កែចំនួនថ្ងៃក្នុងគំរោងរបស់អ្នក',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: durationInDays,
                  decoration: InputDecoration(
                    hintText: 'ចំនួនថ្ងៃ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            Container(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
                label: Text('បោះបង់'),
                style: TextButton.styleFrom(),
              ),
            ),
            Container(
              child: TextButton.icon(
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
                            'ការបញ្ចូលឈ្មោះឬចំនួនថ្ងៃរបស់គំរោងមិនត្រឺមត្រូវ!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('បាទ/ចាស'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                icon: Icon(Icons.save),
                label: Text('រក្សាទុក'),
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
          title: Text('លុបគំរោង'),
          content: Text('តេីអ្នកចង់លុបគំរោងនេះមែនទេ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('បោះបង់'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  goalListProvider.removeGoal(goal);
                });
                Navigator.pop(context);
              },
              child: Text('បាទ/ចាស'),
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
                'ចំនួនថ្ងៃសរុប: ${goal.durationInDays}',
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
                            title: Text('បង្កេីតគំរោងថ្មី'),
                            content: Container(
                              height: 200,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 90, 0),
                                    child: Text('ឈ្មោះគំរោងរបស់អ្នក​ :​',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  TextField(
                                    controller: yourTitle,
                                    decoration: InputDecoration(
                                      hintText: 'ឈ្មោះគំរោង',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 70, 0),
                                    child: Text('ចំនួនថ្ងៃនៃគំរោងរបស់អ្នក :',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  TextField(
                                    controller: durationInDays,
                                    decoration: InputDecoration(
                                      hintText: 'ចំនួនថ្ងៃ',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              Container(
                                child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close),
                                  label: Text('បោះបង់'),
                                  style: TextButton.styleFrom(),
                                ),
                              ),
                              Container(
                                child: TextButton(
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
                                            title: Text('ការបញ្ចូលទិន្នន័យខុស'),
                                            content: Text(
                                              'ការបញ្ចូលទិន្នន័យគំរោងឬថ្ងៃមិនត្រឺមត្រូវ',
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
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add),
                                      SizedBox(
                                          width:
                                              8), // Add space between icon and label
                                      Text('បញ្ចូល'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.rule),
                    label: Text('បញ្ចូលទិន្នន័យថ្មី'),
                  ),
                ],
              ),
            ),
          ),
          if (goalListProvider.goalList.isEmpty)
            Center(child: Text('មិនទាន់មានគំរោង'))
          else
            ...buildGoalTiles(context),
        ],
      ),
    );
  }
}
