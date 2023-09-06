class Todo {
  int? id;
  String? name;
  int? age;
  Todo({ this.id,  this.name,  this.age});

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "age": age};
  }

 static Todo fromMap(Map<String, dynamic> map) {
    return Todo(id: map["id"], name: map["name"], age: map["age"]);
  }
}
