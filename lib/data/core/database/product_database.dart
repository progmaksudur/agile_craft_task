import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductDatabase {
  static final ProductDatabase instance = ProductDatabase._init();
  static Database? _database;

  ProductDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(path, version: 1, onCreate: _createDB);
    } catch (e) {
      throw Exception("Error initializing database: $e");
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tenantId INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        isAvailable INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE temp_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        isAvailable INTEGER NOT NULL,
        isUpdate INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertProduct(Map<String, dynamic> product, {bool isTemp = false}) async {
    final db = await instance.database;
    return await db.insert(isTemp ? 'temp_products' : 'products', product, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchProducts({bool isTemp = false}) async {
    final db = await instance.database;
    return await db.query(isTemp ? 'temp_products' : 'products', orderBy: "id DESC");
  }

  Future<int> updateProduct(Map<String, dynamic> product, {bool isTemp = false}) async {
    final db = await instance.database;
    return await db.update(
      isTemp ? 'temp_products' : 'products',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteProduct(int id, {bool isTemp = false}) async {
    final db = await instance.database;
    return await db.delete(isTemp ? 'temp_products' : 'products', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTempProductById(int id) async {
    final db = await instance.database;
    await db.delete('temp_products', where: 'id = ?', whereArgs: [id]);
  }
}
