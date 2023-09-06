import 'package:bloc_todo_app/bloc/todo_bloc.dart';
import 'package:bloc_todo_app/database/db_helper.dart';
import 'package:bloc_todo_app/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

class TodoScreen extends StatefulWidget {
  TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final DbHelper _dbHelper = DbHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _dbHelper.init();
  }
  @override
  Widget build(BuildContext context) {
    print("appp builder called");
    final bloc = BlocProvider.of<TodoBloc>(context);
    bloc.add(TodoGetEvent());
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),

      body:  BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if(state is LoadingState){
              return const Center(child: CircularProgressIndicator());
          }
          if(state is LoadedState){
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (BuildContext context, int index) {
                final todos = state.todos[index];
                return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(onPressed: (){
                            bloc.add(TodoUpdateEvent(Todo(name: "dhina", age: 23, id: todos.id)));
                          }, icon: Icon(Icons.edit)
                            ,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(todos.name.toString(), style: TextStyle(fontSize: 20),),
                              Text(todos.age.toString(), style: TextStyle(fontSize: 20),),
                            ],
                          ),

                          IconButton(onPressed: (){
                          bloc.add(TodoDeleteEvent(todos.id));
                          }, icon: Icon(Icons.delete)
                            ,),

                        ],
                      ),
                    ));
              },
            );
          }
         return SizedBox();
        }
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // _displayTextInputDialog(context);
          bloc.add(TodoAddEvent(Todo(name: "Lotus", age: 22)));
        },
      ),
    );
  }
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {
                // setState(() {
                //   valueText = value;
                // });
              },
             // controller: _textFieldController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  // setState(() {
                  //   codeDialog = valueText;
                  //   Navigator.pop(context);
                  // });
                },
              ),
            ],
          );
        });
  }
}
