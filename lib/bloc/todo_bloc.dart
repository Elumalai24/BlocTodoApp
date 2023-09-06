import 'package:bloc_todo_app/bloc/todo_event.dart';
import 'package:bloc_todo_app/bloc/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/db_helper.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState>{
  TodoBloc(): super(LoadingState()){
    final DbHelper dbHelper = DbHelper();
    on<TodoGetEvent>((event, emit)async{
      emit(LoadingState());
    final todos = await dbHelper.getAllTodos();
      emit(LoadedState(todos!));
    });
    on<TodoAddEvent>((event, emit)async{
      print("add called");
      print(event.todo);
      //emit(LoadingState());
      await dbHelper.addTodo(event.todo);
      final todos = await dbHelper.getAllTodos();
      emit(LoadedState(todos!));
     // emit(LoadedState());
    });
    on<TodoDeleteEvent>((event, emit)async{
      await dbHelper.deleteTodo(event.id);
      final todos = await dbHelper.getAllTodos();
      emit(LoadedState(todos!));
    });
    on<TodoUpdateEvent>((event, emit)async{
      await dbHelper.updateTodo(event.todo);
      final todos = await dbHelper.getAllTodos();
      emit(LoadedState(todos!));
    });
  }
  // TodoBloc() : super(LoadingState());
  // final DbHelper dbHelper = DbHelper();
  // @override
  // // TODO: implement stream
  // Stream<TodoState> mapEventToState(TodoEvent event )async*{
  //   if(event is TodoAddEvent){
  //     await dbHelper.addTodo(event.todo);
  //     yield LoadingState();
  //
  //   }
  // }
}