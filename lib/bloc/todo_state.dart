import 'package:bloc_todo_app/model/todo.dart';

abstract class TodoState {}

class LoadingState extends TodoState {}

class LoadedState extends TodoState {
  List<Todo> todos;
  LoadedState(this.todos);
}

class ErrorState extends TodoState {
  String error;
  ErrorState(this.error);
}
