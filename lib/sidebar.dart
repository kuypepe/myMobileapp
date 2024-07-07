import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:set_your_goal_app/models/Goal_model.dart';
import 'package:set_your_goal_app/models/goalList_provider.dart';

class Sidebar extends StatefulWidget {
  final Function(Goal) callback;

  const Sidebar({Key? key, required this.callback}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  TextEditingController yourTitle = TextEditingController();
  TextEditingController durationInDays = TextEditingController();
  DateTime? startDate; // Added field for Start Date
  late final GoalListProvider goalListProvider;

  @override
  void initState() {
    super.initState();
    goalListProvider = Provider.of<GoalListProvider>(context, listen: false);
  }

  void showEditGoalDialog(Goal goal) {
    yourTitle.text = goal.name!;
    durationInDays.text = goal.durationInDays.toString();
    startDate = goal.startDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('កែប្រែគំរោង'),
              content: SingleChildScrollView(
                child: Container(
                  height: 280, // Increase the height to accommodate new field
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
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                        child: Text(
                          'កែកាលបរិច្ឆេទចាប់ផ្តើមគំរោងរបស់អ្នក',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (newDate != null) {
                            setState(() {
                              startDate = newDate;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            startDate != null
                                ? "${startDate!.day.toString().padLeft(2, '0')}/${startDate!.month.toString().padLeft(2, '0')}/${startDate!.year}"
                                : 'Choose Start Date',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('បោះបង់'),
                ),
                TextButton(
                  onPressed: () {
                    String title = yourTitle.text;
                    int days = int.tryParse(durationInDays.text) ?? 0;

                    if (title.isNotEmpty && days > 0 && startDate != null) {
                      setState(() {
                        goalListProvider.updateGoal(
                            goal, title, days, startDate!);
                        yourTitle.clear();
                        durationInDays.clear();
                        startDate = null;
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
                                child: Text('បាទ/ចាស'),
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
                      Icon(Icons.save),
                      SizedBox(width: 8), // Add space between icon and label
                      Text('រក្សាទុក'),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Refresh the goal list after dialog is closed
      setState(() {});
    });
  }

  void showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('បង្កេីតគំរោងថ្មី'),
              content: SingleChildScrollView(
                child: Container(
                  height: 280, // Increase the height to accommodate new field
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 90, 0),
                        child: Text(
                          'ឈ្មោះគំរោងរបស់អ្នក​ :​',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        child: Text(
                          'ចំនួនថ្ងៃនៃគំរោងរបស់អ្នក :',
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
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                        child: Text(
                          'កំណត់កាលបរិច្ឆេទចាប់ផ្តើមគំរោងរបស់អ្នក',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (newDate != null) {
                            setState(() {
                              startDate = newDate;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            startDate != null
                                ? "${startDate!.day.toString().padLeft(2, '0')}/${startDate!.month.toString().padLeft(2, '0')}/${startDate!.year}"
                                : 'Choose Start Date',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('បោះបង់'),
                ),
                TextButton(
                  onPressed: () {
                    String title = yourTitle.text;
                    int days = int.tryParse(durationInDays.text) ?? 0;

                    if (title.isNotEmpty && days > 0 && startDate != null) {
                      setState(() {
                        goalListProvider.addGoal(title, days, startDate!);
                        yourTitle.clear();
                        durationInDays.clear();
                        startDate = null;
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
                                child: Text('បាទ/ចាស'),
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
                      SizedBox(width: 8), // Add space between icon and label
                      Text('បញ្ចូល'),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Refresh the goal list after dialog is closed
      setState(() {});
    });
  }

  List<Widget> buildGoalTiles(BuildContext context) {
    return goalListProvider.goalList.map((goal) {
      return Dismissible(
        key: Key(goal.name!),
        background: Container(
          color: Colors.blue,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(Icons.edit, color: Colors.white),
            ),
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Edit action
            showEditGoalDialog(goal);
            return false;
          } else if (direction == DismissDirection.endToStart) {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ការលុបគំរោង'),
                  content: Text('តើអ្នកពិតជាចង់លុបគំរោងនេះមែនទេ?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'បោះបង់',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          goalListProvider.removeGoal(goal);
                        });
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        'លុប',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
            // Prevent Dismissible from dismissing the item
          }
          return false;
        },
        child: Card(
          child: ListTile(
            title: Text(goal.name!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ចំនួនថ្ងៃសរុប: ${goal.durationInDays}​​ ថ្ងៃ', // Display the total number of days
                ),
                Text(
                    'កាលបរិច្ឆេទ: ${goal.getDateRange()}'), // Ensure this method correctly returns the date range
              ],
            ),
            onTap: () {
              widget.callback(goal);
              Navigator.pop(context);
            },
          ),
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
                      showAddGoalDialog();
                    },
                    icon: Icon(Icons.format_list_numbered_outlined),
                    label: Text('បង្កេីតគំរោងថ្មី'),
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
