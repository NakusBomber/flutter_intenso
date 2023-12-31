import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_intenso/model/parfum.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

enum SortingTypes {
  popular,
  price,
  alphabet,
}

extension SortingTypesStringExtension on SortingTypes {
  String get nameField {
    switch (this) {
      case SortingTypes.popular:
        return ParfumFields.id;
      case SortingTypes.alphabet:
        return ParfumFields.title;
      case SortingTypes.price:
        return ParfumFields.price;
      default:
        return ParfumFields.id;
    }
  }

  String get name {
    switch (this) {
      case SortingTypes.popular:
        return 'Популярности';
      case SortingTypes.alphabet:
        return 'Алфавиту';
      case SortingTypes.price:
        return 'Повышению цены';
      default:
        return '';
    }
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const String tableName = 'parfums';
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final Directory dbDirectory = await getApplicationDocumentsDirectory();
    final path = join(dbDirectory.path, filePath);

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      final ByteData data = await rootBundle.load('assets/databases/$filePath');
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
      return await openDatabase(path, version: 1);
    }

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName (
	${ParfumFields.id}	INTEGER NOT NULL UNIQUE,
	${ParfumFields.article}	TEXT NOT NULL,
	${ParfumFields.urlImage}	TEXT,
	${ParfumFields.title}	TEXT NOT NULL,
	${ParfumFields.type}	TEXT,
	${ParfumFields.price}	REAL NOT NULL,
	${ParfumFields.url}	TEXT NOT NULL,
	PRIMARY KEY(${ParfumFields.id} AUTOINCREMENT)
)
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;

    db.close();
  }

  Future<Parfum> insert(Parfum parfum) async {
    final db = await instance.database;
    final id = await db.insert(tableName, parfum.toJson());

    return parfum.copy(id: id);
  }

  List<Object?> _getWhereArgs(
    Set<ParfumTypes>? filters,
    String? searchQuery,
  ) {
    List<String>? values = filters?.map((e) => e.name).toList();
    List<Object?> whereArgs = [];
    if (values != null) {
      whereArgs.addAll([...values]);
    }

    if (searchQuery != null) {
      final searchQueryUpper = searchQuery.toUpperCase();
      whereArgs.add('%$searchQueryUpper%');
    }
    return whereArgs;
  }

  String? _getWhere(
    Set<ParfumTypes>? filters,
    String? searchQuery,
  ) {
    List<String>? values = filters?.map((e) => e.name).toList();
    List<String> whereList = [];
    String? where;

    if (values != null) {
      String questionMarks = List.filled(values.length, '?').join(', ');
      whereList.add('${ParfumFields.type} IN ($questionMarks)');
    }

    if (searchQuery != null) {
      whereList.add('${ParfumFields.title} LIKE ?');
    }

    if (whereList.isNotEmpty) {
      where = whereList.join(' AND ');
    }

    return where;
  }

  Future<Parfum?> readId(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableName,
        columns: ParfumFields.values,
        where: '${ParfumFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Parfum.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Parfum>> readAll() async {
    final db = await instance.database;
    final result = await db.query(tableName);

    return result.map((json) => Parfum.fromJson(json)).toList();
  }

  Future<List<Parfum>> readWithOptions({
    Set<ParfumTypes>? filters,
    SortingTypes? sortType,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    final db = await instance.database;
    List<Object?> whereArgs = _getWhereArgs(filters, searchQuery);
    String? where = _getWhere(filters, searchQuery);
    String? sort;

    if (sortType != null) {
      sort = '${sortType.nameField} ASC';
    }

    final result = await db.query(
      tableName,
      columns: ParfumFields.values,
      where: where,
      whereArgs: whereArgs,
      orderBy: sort,
      limit: limit,
      offset: offset,
    );

    return result.map((json) => Parfum.fromJson(json)).toList();
  }

  Future<int> getCountEntry({
    Set<ParfumTypes>? filters,
    String? searchQuery,
  }) async {

    final db = await instance.database;
    final where = _getWhere(filters, searchQuery);
    final whereArgs = _getWhereArgs(filters, searchQuery);
    String query = '';

    if (where != null && where.isNotEmpty) {
      query = "WHERE $where";
    }

    final result = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM $tableName $query',
      whereArgs,
    ));

    if (result != null) {
      return result;
    }
    return 0;
  }
}
