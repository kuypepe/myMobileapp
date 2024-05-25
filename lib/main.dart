import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/Goal_model.dart';
import 'models/goalList_provider.dart';
import 'sidebar.dart';

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
          return Text('សូមជ្រេីសរេីសគំរោងឬបង្កេីតថ្មី');
        } else if (mygoal!.goalList == null || mygoal!.goalList!.isEmpty) {
          return Text('');
        } else {
          return ListView.builder(
            itemCount: mygoal!.goalList!.length,
            itemBuilder: (context, index) {
              var dayExercises = mygoal!.goalList![index];
              return (dayExercises == null ||
                      dayExercises.exerciseList!.isEmpty)
                  ? ListTile(
                      title: Text(
                        'ថ្ងៃ ${index + 1}:'.padRight(25) + "មិនមានទិន្នន័យ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : ExpansionTile(
                      title: Text(
                        "ថ្ងៃ ${index + 1}:".padRight(25) +
                            "${dayExercises.exerciseList!.values.where((completed) => completed == true).length} / ${dayExercises.exerciseList!.length} បានរួចរាល់",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      textColor: Colors.blue,
                      children: dayExercises.exerciseList!.entries
                          .map<Widget>((entry) {
                        bool completed = entry.value!;
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Dismissible(
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
                                      child: Icon(Icons.delete,
                                          color: Colors.white),
                                    ))),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    TextEditingController editController =
                                        TextEditingController(text: entry.key);
                                    return AlertDialog(
                                      title: Text('កែទិន្នន័យក្នុងគំរោង'),
                                      content: TextField(
                                        controller: editController,
                                        decoration: InputDecoration(
                                          hintText: 'ឈ្មោះទិន្នន័យ',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'បោះបង់',
                                            style: TextStyle(
                                                color: Colors
                                                    .red), // កំណត់ពណ៌នៅក្នុងប៊ូតុង
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            String oldKey = entry.key!;
                                            String newKey = editController.text;

                                            if (dayExercises.exerciseList!
                                                .containsKey(newKey)) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Exercise with this name already exists!'),
                                              ));
                                            } else {
                                              // Create a LinkedHashMap to maintain order
                                              LinkedHashMap<String?, bool?>
                                                  updatedMap = LinkedHashMap<
                                                      String?, bool?>();

                                              // Iterate through the existing map
                                              dayExercises.exerciseList!
                                                  .forEach((key, value) {
                                                if (key == oldKey) {
                                                  updatedMap[newKey] =
                                                      value; // Add new key-value pair
                                                } else {
                                                  updatedMap[key] =
                                                      value; // Retain other key-value pairs
                                                }
                                              });

                                              // Replace the old map with the updated map
                                              dayExercises.exerciseList =
                                                  updatedMap;

                                              setState(() {}); // Refresh the UI
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text(
                                            'រក្សាទុក',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
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
                                      title: Text('ការលុបទិន្នន័យ'),
                                      content: Text(
                                          'តេីអ្នកចង់លុបទិន្នន័យនេះមែនទេ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text(
                                            'បោះបង់',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              dayExercises.exerciseList!
                                                  .remove(entry.key);
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
        backgroundColor: const Color.fromARGB(255, 212, 5, 164),
        title: Container(
          margin: EdgeInsets.only(right: 0),
          child: Text(
            (mygoal == null) ? '' : mygoal!.name!,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
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
                        double percentage =
                            (completedExercises / totalExercises) * 100;
                        return AlertDialog(
                          title: Text('ដំណេីរការនៃគំរោង'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'បានជោគជ័យ $completedExercises/$totalExercises'),
                              SizedBox(height: 10),
                              LinearProgressIndicator(
                                value: completedExercises / totalExercises,
                                backgroundColor: Colors.red,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'អ្នកបានសម្រេចគំរោង ${percentage.toStringAsFixed(2)}%',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('បោះបង់'),
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
                          title: Text('មិនមានទិន្នន័យ'),
                          content: Text('គំរោងនេះមិនទាន់មានទិន្នន័យ'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('បោះបង់'),
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
                        title: Text('មិនមានគំរោង'),
                        content: Text('សូមជ្រេីសរេិសគំរោងឬបង្កេីតគំរោងថ្មី'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('បោះបង់'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              icon: Icon(
                Icons.check,
                color: Color.fromARGB(255, 0, 244, 37),
              ),
              label: Text('ដំណេីរការ'),
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
                  title: Text('មិនមានគំរោង'),
                  content: Text('សូមជ្រេីសរេិសគំរោងឬបង្កេីតគំរោងថ្មី'),
                  actions: [
                    Container(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: Text('បោះបង់'),
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
                      title: Text('បញ្ចូលទិន្នន័យ'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text('ជ្រេីសរេីសថ្ងៃនៃគំរោង:'),
                              SizedBox(width: 10),
                              DropdownButton<int>(
                                value: selectedDay,
                                items: List.generate(
                                  mygoal!.durationInDays!,
                                  (index) => DropdownMenuItem(
                                    value: index,
                                    child: Text('ថ្ងៃ ${index + 1}'),
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
                                hintText: 'ឈ្នោះរបស់ទិន្នន័យ',
                                border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                      actions: [
                        Container(
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                            label: Text('បោះបង់'),
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                          ),
                        ),
                        Container(
                          child: TextButton.icon(
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
                            label: Text('បញ្ចូល'),
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
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
