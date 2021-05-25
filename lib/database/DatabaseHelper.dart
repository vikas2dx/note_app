import 'package:note_app/model/NoteModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  static final _tableName = 'note';
  static final note_id = "note_id";
  static final title = "title";
  static final description = "description";
  static final time_stamp = "time_stamp";
  static final isSync = "is_sync";
  static final post_id = "post_id";
  static final is_update = "is_update";
  static final delete_sync = "delete_sync";
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $_tableName (
    $note_id INTEGER PRIMARY KEY AUTOINCREMENT,
    $title TEXT NOT NULL,
    $description TEXT,
    $time_stamp INTEGER,
    $isSync INTEGER,
    $post_id TEXT,
    $is_update INTEGER,
    $delete_sync INTEGER
    )
    ''');
  }

  Future<int> addNote(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<int> updateNote(Map<String, dynamic> row,int timeStamp) async {
    Database db = await instance.database;
    return await db.update(_tableName, row,where: time_stamp + "= $timeStamp");
  }

  Future<int> deleteNote(int timeStamp) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: time_stamp + "= $timeStamp");
  }

  Future<List<NoteModel>> fetchNote() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: time_stamp + " DESC",
    );
    List<NoteModel> list = List();
    for (int i = 0; i < maps.length; i++) {
      list.add(NoteModel(
          title: maps[i][title],
          description: maps[i][description],
          time_stamp: maps[i][time_stamp],
          is_sync: maps[i][isSync]));
    }
    return list;
  }

  Future<List<NoteModel>> fetchedUnSyncedAdd() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: isSync + "= 0",

    );
    List<NoteModel> list = List();
    for (int i = 0; i < maps.length; i++) {
      list.add(NoteModel(
          title: maps[i][title],
          description: maps[i][description],
          time_stamp: maps[i][time_stamp],
          is_sync: maps[i][isSync]));
    }
    print("Sync List $list");
    return list;
  }
  Future<List<NoteModel>> fetchedUnSyncedUpdate() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: is_update + "= 0",

    );
    List<NoteModel> list = List();
    for (int i = 0; i < maps.length; i++) {
      list.add(NoteModel(
          title: maps[i][title],
          description: maps[i][description],
          time_stamp: maps[i][time_stamp],
          is_sync: maps[i][delete_sync]));
    }
    print("Sync List $list");
    return list;
  }
  Future<List<NoteModel>> fetchedUnSyncedDelete() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: delete_sync + "= 0",

    );
    List<NoteModel> list = List();
    for (int i = 0; i < maps.length; i++) {
      list.add(NoteModel(
          title: maps[i][title],
          description: maps[i][description],
          time_stamp: maps[i][time_stamp],
        delete_sync: maps[i][delete_sync],
      ));
    }
    print("Sync List $list");
    return list;
  }

}
