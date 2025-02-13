import 'package:flutter/material.dart';

class TaskItems extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;

  const TaskItems({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                String formattedDate = _formatDate(tasks[index]['date']);

                return TaskCard(
                  task: tasks[index]['task'],
                  date: formattedDate,
                  onTap: () => _taskOptions(context, index),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}

void _taskOptions(BuildContext context, int index) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext ctx) {
      return Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Task'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Mark as Completed'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
              onTap: () {},
            ),
          ],
        ),
      );
    },
  );
}

class TaskCard extends StatelessWidget {
  final String task;
  final String date;
  final VoidCallback onTap;

  const TaskCard(
      {super.key, required this.task, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.task_alt_rounded),
        title: Text(task),
        subtitle: Text('Due: $date'),
        onTap: onTap,
      ),
    );
  }
}
