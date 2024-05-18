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
                      title: Text('Day ${index + 1} :'),
                    )
                  : ExpansionTile(
                      title: Text("Day ${index + 1} :"),
                      children: dayExercises.exerciseList!.entries
                          .map<Widget>((entry) {
                        bool completed = entry.value!;
                        return ListTile(
                          title: Text(
                            entry.key!,
                            // Apply decoration to text if exercise is completed
                            style: TextStyle(
                              decoration:
                                  completed ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          trailing: Checkbox(
                            value: completed,
                            onChanged: (bool? newValue) {
                              setState(() {
                                if (newValue != null) {
                                  completed =
                                      newValue; // Update the local completed variable
                                  dayExercises.exerciseList![entry.key] =
                                      newValue; // Update the exercise completion status
                                  // Update exercise completion in the goal model
                                }
                              });
                            },
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
              onPressed: () {},
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
