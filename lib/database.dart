import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'todo.dart';

Future<Database> Connect() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'database1.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE IF NOT EXISTS todos(id INTEGER PRIMARY KEY, title TEXT, complete INTEGER)",
      );
    },
    version: 1,
  );
  return database;
}

void Add(Todo item) async {
  final Database db = await Connect();
  await db.insert(
    'todos',
    item.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Todo>> GetAll() async {
  final Database db = await Connect();
  final List<Map<String, dynamic>> maps = await db.query('todos');
  return List.generate(maps.length, (i) {
    return Todo(
      id: maps[i]['id'],
      title: maps[i]['title'],
      complete: maps[i]['complete'],
    );
  });
}

Future<void> Del(int id) async {
  final db = await Connect();
  await db.delete(
    'todos',
    where: "id = ?",
    whereArgs: [id],
  );
}

Future<void> Set(Todo item) async {
  final db = await Connect();
  await db.update(
    'todos',
    item.toMap(),
    where: "id = ?",
    whereArgs: [item.id],
  );
}
