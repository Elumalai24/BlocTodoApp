import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/todo.dart';

class DbHelper{
  Database? db;
  Future init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "MyDatabase.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table todos ( 
  id integer primary key autoincrement, 
  name text not null,
  age integer not null)
''');
        });
  }
  Future<Database?>  get database async{
if(db !=null){
return db;
}
return await init();
  }
  Future addTodo(Todo  todo)async{
//final db = await database;
  await db!.insert("todos", todo.toMap());
  }
  Future<List<Todo>?> getAllTodos()async{
    print("get called");
   await database;
   final queriedList =  await db?.query("todos");
   print("todos${queriedList}");
   final todos = queriedList?.map((e) => Todo.fromMap(e)).toList();
   print(todos);
       return todos;
  }
  Future deleteTodo(int? id)async{
     await db?.delete("todos", where: 'id = ?', whereArgs: [id]);
  }
  Future updateTodo(Todo todo)async{
    await db?.update("todos", todo.toMap(),
        where: 'id = ?', whereArgs: [todo.id]);
  }
 // Future delete
}
