import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) callback;
  const Sidebar({required this.callback});

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
                        callback('U have click');
                      },
                      icon: Icon(Icons.rule), // Icon for the button
                      label: Text('Create Your Goal'), // Text for the button
                    ),
                  ],
                ),
              )),
          Container(
            margin: EdgeInsets.all(5),
            child: ListTile(
              title: Text('Goal Number 1'),
              onTap: () {
                callback('Test');
              },
              leading: Icon(Icons.favorite),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: ListTile(
              title: Text('Goal Number 2'),
              onTap: () {},
              leading: Icon(Icons.music_note),
            ),
            
          )
        ],
      ),
    );
  }
}
