import '../model/todo.dart';

abstract class TodoEvent {}

class TodoAddEvent extends TodoEvent {
  Todo todo;
  TodoAddEvent(this.todo);
}

class TodoGetEvent extends TodoEvent {}

class TodoUpdateEvent extends TodoEvent {
  Todo todo;
  TodoUpdateEvent(this.todo);
}

class TodoDeleteEvent extends TodoEvent {
  int? id;
  TodoDeleteEvent(this.id);
}
