import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/Goal_model.dart';
import 'sidebar.dart';
import 'models/goalList_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => GoalListProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        addExerciseController: TextEditingController(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final TextEditingController addExerciseController;

  const MyHomePage({Key? key, required this.addExerciseController})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Goal? mygoal;
  int selectedDay = 0;

  void selectGoal(Goal mygoal) {
    setState(() {
      this.mygoal = mygoal;
    });
  }

  Widget buildBody(BuildContext context) {
    return Consumer<GoalListProvider>(
      builder: (context, goalListProvider, child) {
        if (mygoal == null) {
          return Text('Create Your Goal now or select one!');
        } else if (mygoal!.goalList == null || mygoal!.goalList!.isEmpty) {
          return Text('No exercises found for the selected goal.');
        } else {
          return ListView.builder(
            itemCount: mygoal!.goalList!.length,
            itemBuilder: (context, index) {
              var dayExercises = mygoal!.goalList![index];
              return (dayExercises == null ||
                      dayExercises.exerciseList!.isEmpty)
                  ? ListTile(
                      title: Text('Day ${index + 1}: Please add exercise'),
                    )
                  : ExpansionTile(
                      title: Text("Day ${index + 1}:"),
                      children: dayExercises.exerciseList!.entries
                          .map<Widget>((entry) {
                        bool completed = entry.value!;
                        return Dismissible(
                          key: Key(entry.key!),
                          background: Container(
                              color: Colors.blue,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child:
                                        Icon(Icons.edit, color: Colors.white),
                                  ))),
                          secondaryBackground: Container(
                              color: Colors.red,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 16.0),
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  ))),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController editController =
                                      TextEditingController(text: entry.key);
                                  return AlertDialog(
                                    title: Text('Edit Exercise'),
                                    content: TextField(
                                      controller: editController,
                                      decoration: InputDecoration(
                                          hintText: 'Exercise name'),
                                    ),
                                    actions: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.close),
                                        label: Text('Close'),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            String oldKey = entry.key!;
                                            String newKey = editController.text;
                                            bool? value = dayExercises
                                                .exerciseList!
                                                .remove(oldKey);
                                            dayExercises.exerciseList![newKey] =
                                                value;
                                          });
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.save),
                                        label: Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return false; // Prevent Dismissible from dismissing the item
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Confirmation'),
                                    content: Text(
                                        'Are you sure you want to delete this exercise?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            dayExercises.exerciseList!
                                                .remove(entry.key);
                                          });
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            return false;
                          },
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              // Handle edit action
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              setState(() {
                                dayExercises.exerciseList!.remove(entry.key);
                              });
                            }
                          },
                          child: ListTile(
                            title: Text(
                              entry.key!,
                              // Apply decoration to text if exercise is completed
                              style: TextStyle(
                                decoration: completed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: Checkbox(
                              value: completed,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  if (newValue != null) {
                                    completed = newValue;
                                    dayExercises.exerciseList![entry.key] =
                                        newValue;
                                    print(
                                        'Exercise "${entry.key}" completion status: $newValue');
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(callback: selectGoal),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text(
          (mygoal == null) ? 'Select a goal or create one ' : mygoal!.name!,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: ElevatedButton.icon(
              onPressed: () {
                if (mygoal != null) {
                  int totalExercises = 0;
                  int completedExercises = 0;
                  for (var dayExercises in mygoal!.goalList!) {
                    if (dayExercises != null &&
                        dayExercises.exerciseList != null) {
                      totalExercises += dayExercises.exerciseList!.length;
                      dayExercises.exerciseList!.forEach((exercise, completed) {
                        if (completed == true) {
                          completedExercises++;
                        }
                      });
                    }
                  }

                  // Check if there are exercises before calculating progress
                  if (totalExercises > 0) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Exercise Progress'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Completed $completedExercises/$totalExercises'),
                              SizedBox(height: 10),
                              LinearProgressIndicator(
                                value: completedExercises / totalExercises,
                                backgroundColor: Colors.red,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('No Exercises'),
                          content:
                              Text('There are no exercises for this goal.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  // Dialog for no goal selected
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('No Goal Selected'),
                        content: Text('Please select or create a goal first.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              icon: Icon(
                Icons.add_chart,
                color: Color.fromARGB(255, 10, 37, 241),
              ),
              label: Text('Your Progress'),
            ),
          ),
        ],
      ),
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: buildBody(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mygoal == null) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('No Goal Selected'),
                  content: Text('Please select or create a goal first.'),
                  actions: [
                    Container(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: Text('Close'),
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text('Add your exercise'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text('Select Date:'),
                              SizedBox(width: 10),
                              DropdownButton<int>(
                                value: selectedDay,
                                items: List.generate(
                                  mygoal!.durationInDays!,
                                  (index) => DropdownMenuItem(
                                    value: index,
                                    child: Text('Day ${index + 1}'),
                                  ),
                                ),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedDay = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: widget.addExerciseController,
                            decoration: InputDecoration(
                                hintText: 'Name your exercise',
                                border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                      actions: [
                        Container(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: Text('Close'),
                            icon: Icon(Icons.close),
                          ),
                        ),
                        Container(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (widget
                                  .addExerciseController.text.isNotEmpty) {
                                // Use the provider to add the exercise
                                Provider.of<GoalListProvider>(context,
                                        listen: false)
                                    .addExerciseToGoal(mygoal!, selectedDay,
                                        widget.addExerciseController.text);
                                widget.addExerciseController.clear();
                                Navigator.pop(context);
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
            );
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
