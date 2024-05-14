import 'package:flutter/material.dart';
import 'classes/classes.dart';
import 'sidebar.dart';

void main() {
  runApp(const MyApp());
  // Goal mygoal = Goal("My Workout routine", 30);
  // mygoal.addExerciseInDay(0, "15 Push up");
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String callbacktext = '';
  String tittlename = '';
  TextEditingController addExcerciseController = TextEditingController();

  void updateBodyText(String text) {
    setState(() {
      callbacktext = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Sidebar(callback: updateBodyText),
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Text(
            tittlename,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              //color: Colors.black,
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
            child: Column(
              children: [
                Text(callbacktext),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add your fucking excercise'),
                    content: TextField(
                      controller: addExcerciseController,
                    ),
                  );
                });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
