part of utils;

class SqlUtils{
  static final SqlUtils _sqlUtils = SqlUtils._internal();

  factory SqlUtils() {
    return _sqlUtils;
  }

  SqlUtils._internal();

  static void createDb(String tableId) async {
    var databaseFactory = databaseFactoryFfi;

    var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

    await db.execute('''
      CREATE TABLE $tableId (
          id INTEGER PRIMARY KEY,
          timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
          payload TEXT
      );
      ''');

  }


  static void clearTable(String tableId) async {
    var databaseFactory = databaseFactoryFfi;

    var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

    await db.execute('''
      DELETE FROM $tableId
      ''');

  }

  static void insert(String dB, String dt) async {
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

    await db.insert(dB, <String, dynamic>{'payload': dt});

  }

  static Future<dynamic> read(String dB) async {
    var result;
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    try {
      result = await db.query(dB);
    }catch(e){
    }

    return result;
  }

}