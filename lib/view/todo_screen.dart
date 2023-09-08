import 'package:bloc_todo_app/bloc/todo_bloc.dart';
import 'package:bloc_todo_app/database/db_helper.dart';
import 'package:bloc_todo_app/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final DbHelper _dbHelper = DbHelper();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dbHelper.init();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TodoBloc>(context);
    bloc.add(TodoGetEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is LoadedState) {
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (BuildContext context, int index) {
              final todos = state.todos[index];
              return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: ${todos.name.toString()}",
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              "Age: ${todos.age.toString()}",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            nameController.text = todos.name!;
                            ageController.text = todos.age.toString();
                            _showMyDialog(context, 2, todos.id);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            bloc.add(TodoDeleteEvent(todos.id));
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ));
            },
          );
        }
        return const SizedBox();
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nameController.text = "";
          ageController.text = "";
          _showMyDialog(context, 1, null);
          // bloc.add(TodoAddEvent(Todo(name: "Lotus", age: 22)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context, int state, int? id) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final bloc = BlocProvider.of<TodoBloc>(context);
        return AlertDialog(
          title: const Text('Enter Name and Age'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                String name = nameController.text;
                int age = int.tryParse(ageController.text) ??
                    0; // Handle invalid input.
                state == 1
                    ? bloc.add(TodoAddEvent(Todo(name: name, age: age)))
                    : bloc.add(
                        TodoUpdateEvent(Todo(name: name, age: age, id: id)));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
