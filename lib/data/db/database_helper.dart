import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/restaurant_detail.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavorite = 'favorite';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, "restaurant_favorite.db"),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavorite (
             id TEXT PRIMARY KEY,
             name TEXT,
             pictureId TEXT,
             city TEXT,
             rating REAL
           )     
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    if (_database == null) {
      return await _initializeDb();
    }

    return _database;
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(
      _tblFavorite,
      {
        'id': restaurant.id,
        'name': restaurant.name,
        'city': restaurant.city,
        'pictureId': restaurant.pictureId,
        'rating': restaurant.rating,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;

    if (db == null) {
      return [];
    }
    final List<Map<String, dynamic>> maps = await db.query(_tblFavorite);

    return List.generate(maps.length, (i) {
      return Restaurant(
        id: maps[i]['id'],
        name: maps[i]['name'],
        city: maps[i]['city'],
        pictureId: maps[i]['pictureId'],
        rating: maps[i]['rating'],
        description: '',
        address: '',
        categories: [],
        menus: Menus(foods: [], drinks: []),
        customerReviews: [],
      );
    });
  }

  Future<Map> getFavoriteById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db!.delete(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
