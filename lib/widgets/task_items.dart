import 'package:flutter/material.dart';

class TaskItems extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;

  const TaskItems({super.key, required this.tasks});

  @override
  State<TaskItems> createState() => _TaskItemsState();
}

class _TaskItemsState extends State<TaskItems> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                String formattedDate = _formatDate(widget.tasks[index]['date']);

                return TaskCard(
                  task: widget.tasks[index]['task'],
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

  void _editTask(BuildContext context, int index) {
    TextEditingController taskController =
        TextEditingController(text: widget.tasks[index]['task']);
    DateTime selectedDate = widget.tasks[index]['date'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: InputDecoration(labelText: 'Task'),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context, (date) {
                  setState(() {
                    selectedDate = date;
                  });
                }),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Due Date: ${_formatDate(selectedDate)}',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.tasks[index]['task'] = taskController.text;
                  widget.tasks[index]['date'] = selectedDate;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, Function(DateTime) onDatePicked) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDatePicked(picked);
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
                onTap: () {
                  _editTask(context, index);
                },
              ),
              ListTile(
                leading: Icon(Icons.check),
                title: Text('Mark as Completed'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
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
        leading: Icon(Icons.circle_outlined),
        title: Text(task),
        subtitle: Text('Due: $date'),
        onTap: onTap,
      ),
    );
  }
}
