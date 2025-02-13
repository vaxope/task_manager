import 'package:flutter/material.dart';
import 'package:taskmanager/widgets/task_box.dart';
import 'package:taskmanager/widgets/task_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tasks = [];

  Future<void> _addTask() async {
    final newTransaction = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return const TaskBox();
      },
    );

    if (newTransaction != null) {
      setState(() {
        tasks.add({
          'task': newTransaction['task'],
          'date': newTransaction['date'],
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      'Today\'s Tasks',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  TaskItems(
                    tasks: tasks,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    title: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            color: Colors.black,
            size: 40,
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/images/defaultpfp.jpg"),
          )
        ],
      ),
    ),
  );
}

class TaskBox extends StatefulWidget {
  const TaskBox({super.key});

  @override
  State<TaskBox> createState() => _TaskBoxState();
}

class _TaskBoxState extends State<TaskBox> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskController,
            decoration: InputDecoration(labelText: 'Task'),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  labelText: _selectedDate == null
                      ? 'Pick a date'
                      : 'Selected Date: ${_selectedDate!.toLocal()}'
                          .split(' ')[0],
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_taskController.text.isEmpty || _selectedDate == null) {
              return;
            }
            final newTask = {
              'task': _taskController.text,
              'date': _selectedDate,
            };
            Navigator.of(context).pop(newTask);
          },
          child: Text('Add Task'),
        ),
      ],
    );
  }
}
