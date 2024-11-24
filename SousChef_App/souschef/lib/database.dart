import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Recipe {
  final int? id;
  final String text;
  final String name;

  Recipe({
    this.id,
    required this.text,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'text': text, 'name': name,};
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      text: map['text'],
      name: map['name'],
    );
  }
}

class DatabaseHelper {
  static final _databaseName = 'recipelist_v2.db';
  static final _databaseVersion = 1;
  static final _table = 'recipes';

  static final DatabaseHelper instance = DatabaseHelper._private();

  DatabaseHelper._private();

  static late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, _databaseName);

    return await openDatabase(dbPath, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT,
        name TEXT
      )
    ''');
  }

  Future<int> insertRecipe(Recipe recipe) async {
    Database db = await instance.database;
    return await db.insert(_table, recipe.toMap());
  }

  Future<void> deleteRecipe(int id) async {
  Database db = await instance.database;
  await db.delete(_table, where: 'id = ?', whereArgs: [id]);
}

  Future<List<Recipe>> getRecipes() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_table);
    return List.generate(maps.length, (i) {
      return Recipe.fromMap(maps[i]);
    });
  }
}