import 'package:flutter/material.dart';

class TaskItems extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;

  const TaskItems({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  tasks[index]['task'],
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(Icons.task, color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }
}
