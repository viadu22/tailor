import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tableName = 'persons';
  final String _ctableName = 'clients';
  final String _htableName = 'history';
  final String _ptableName = 'progress';
  final String _comtableName = 'complete';
  final String _mtableName = 'payments';
  final String _histableName = 'moneyhistory';

  final String _id = 'id';
  final String _cattire = 'attire';
  final String _cidentity = 'identity';
  final String _cpercent = 'percent';
  final String _cprogress = 'progress';
  final String _cpayment = 'payment';
  final String _name = 'name';
  final String _email = 'email';
  final String _phone = 'phone';
  final String _password = 'password';
  final String _cunit = 'unit';
  final String _cheight = 'height';
  final String _clength = 'length';
  final String _cid = 'id';
  final String _cname = 'name';
  final String _cemail = 'email';
  final String _cgender = 'gender';
  final String _cage = 'age';
  final String _cphone = 'phone';
  final String _clocation = 'location';
  final String _cother = 'otherinfo';
  final String _cneck = 'neck';
  final String _cshoulder = 'shoulder';
  final String _cchest = 'chest';
  final String _cubust = 'underbust';
  final String _cwaist = 'waisttop';
  final String _cbwidth = 'backwidth';
  final String _cblength = 'backlength';
  final String _cflength = 'frontlength';
  final String _csleeve = 'sleeve';
  final String _cbicep = 'bicep';
  final String _cwrist = 'wrist';
  final String _carmhole = 'armhole';
  final String _cwaistd = 'waistdown';
  final String _chip = 'hip';
  final String _cseat = 'seat';
  final String _cfrise = 'frontrise';
  final String _cbrise = 'backrise';
  final String _coutseam = 'outseam';
  final String _cinseam = 'inseam';
  final String _ccalf = 'calf';
  final String _cthigh = 'thigh';
  final String _cknee = 'knee';
  final String _cankle = 'ankle';
  final String _cdatetime = 'datetime';
  final String _cdate = 'date';
  final String _ctime = 'time';
  final String _cdeadline = 'deadline';
  final String _ccurrentupdate = 'current_update';

  DatabaseService._constructor();

  // Future<void> printDbPath() async {
  //   final dbPath = await getDatabasesPath();
  //   final fullPath = join(dbPath, "real.db");

  //   print("📂 DATABASE PATH: $fullPath");
  // }

  // Future<Database> get clientdatabase async {
  //   if (_cdb != null) return _cdb!;
  //   _cdb = await _initCDB();
  //   return _cdb!;
  // }

  // Future<Database> _initCDB() async {
  //   sqfliteFfiInit();
  //   databaseFactory = databaseFactoryFfi;

  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, "clients.db");

  //   return await openDatabase(
  //     path,
  //     version: 1,
  //     onCreate: (db, version) async {
  //       await db.execute('''
  //         CREATE TABLE $_ctableName(
  //   $_cid INTEGER PRIMARY KEY AUTOINCREMENT,
  //   $_cname TEXT NOT NULL,
  //   $_cemail TEXT NOT NULL,
  //   $_cphone TEXT NOT NULL,
  //   $_cunit TEXT NOT NULL,
  //   $_cheight TEXT NOT NULL,
  //   $_clength TEXT NOT NULL,
  //   $_cgender TEXT NOT NULL,
  //   $_cage TEXT NOT NULL,
  //   $_clocation TEXT NOT NULL,
  //   $_cneck TEXT NOT NULL,
  //   $_cshoulder TEXT NOT NULL,
  //   $_cchest TEXT NOT NULL,
  //   $_cubust TEXT NOT NULL,
  //   $_cwaist TEXT NOT NULL,
  //   $_cbwidth TEXT NOT NULL,
  //   $_cblength TEXT NOT NULL,
  //   $_cflength TEXT NOT NULL,
  //   $_csleeve TEXT NOT NULL,
  //   $_cbicep TEXT NOT NULL,
  //   $_cwrist TEXT NOT NULL,
  //   $_carmhole TEXT NOT NULL,
  //   $_cwaistd TEXT NOT NULL,
  //   $_chip TEXT NOT NULL,
  //   $_cseat TEXT NOT NULL,
  //   $_cfrise TEXT NOT NULL,
  //   $_cbrise TEXT NOT NULL,
  //   $_coutseam TEXT NOT NULL,
  //   $_cinseam TEXT NOT NULL,
  //   $_cknee TEXT NOT NULL,
  //   $_cankle TEXT NOT NULL,
  //   $_cother TEXT NOT NULL
  // )
  //       ''');
  //     },
  //   );
  // }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "real.db");

    return await openDatabase(
      path,
      version: 1,

      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_tableName(
          $_id INTEGER PRIMARY KEY AUTOINCREMENT,
          $_name TEXT NOT NULL,
          $_email TEXT NOT NULL,
          $_phone INTEGER NOT NULL,
          $_password TEXT NOT NULL
        )
      ''');

        // await db.execute('DROP TABLE IF EXISTS $_ctableName');

        await db.execute('''
        CREATE TABLE $_ctableName(
          $_cid INTEGER PRIMARY KEY AUTOINCREMENT,
          $_cname TEXT NOT NULL,
          $_cattire TEXT,
          $_cidentity TEXT,
          $_cemail TEXT,
          $_cphone INTEGER,
          $_cunit TEXT,
          $_cheight TEXT,
          $_clength TEXT,
          $_cgender TEXT,
          $_cage INT,
          $_clocation TEXT,
          $_cneck TEXT,
          $_cshoulder TEXT,
          $_cchest TEXT,
          $_cubust TEXT,
          $_cwaist TEXT,
          $_cbwidth TEXT,
          $_cblength TEXT,
          $_cflength TEXT,
          $_csleeve TEXT,
          $_cbicep TEXT,
          $_cwrist TEXT,
          $_carmhole TEXT,
          $_cwaistd TEXT,
          $_chip TEXT,
          $_cseat TEXT,
          $_cfrise TEXT,
          $_cbrise TEXT,
          $_coutseam TEXT,
          $_cinseam TEXT,
          $_cthigh TEXT,
          $_ccalf TEXT,
          $_cknee TEXT,
          $_cankle TEXT,
          $_cother TEXT,
          $_cdatetime TEXT,
          $_cdeadline TEXT,
          $_ccurrentupdate TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE $_htableName(
          $_cid INTEGER PRIMARY KEY AUTOINCREMENT,
          $_cname TEXT NOT NULL,
          $_cemail TEXT,
          $_cphone INTEGER,
          $_cgender TEXT,
          $_cage INT,
          $_clocation TEXT,
          $_cdeadline TEXT,
          $_ccurrentupdate TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE $_ptableName(
          $_cid INTEGER PRIMARY KEY AUTOINCREMENT,
          $_cname TEXT NOT NULL,
          $_cidentity TEXT,
          $_cdeadline TEXT,
          $_cpercent TEXT,
          $_cprogress TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE $_comtableName(
          $_cid INTEGER PRIMARY KEY AUTOINCREMENT,
          $_cname TEXT NOT NULL,
          $_cidentity TEXT,
          $_cdeadline TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE $_mtableName(
          $_cid INTEGER PRIMARY KEY AUTOINCREMENT,
          $_cname TEXT NOT NULL,
          $_cidentity TEXT,
          $_cdeadline TEXT,
          $_cpayment REAL,
          $_ccurrentupdate TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE $_histableName(
          $_cid INTEGER PRIMARY KEY AUTOINCREMENT,
          $_cname TEXT NOT NULL,
          $_cidentity TEXT,
          $_cpayment TEXT,
          $_cdate TEXT,
          $_ctime TEXT
        )
      ''');
      },
    );
  }

  // Future<void> del() async {
  //   final db = await database;
  //   await db.delete('progress');
  // }

  Future<void> cashin(
    String cname,
    String cidentity,
    String cdeadline,
    double cpayment,
    String ccurrentupdate,
  ) async {
    final db = await database;

    await db.insert(_mtableName, {
      _cname: cname,
      _cidentity: cidentity,
      _cdeadline: cdeadline,
      _cpayment: cpayment,
      _ccurrentupdate: ccurrentupdate,
    });
  }

  Future<void> updateCash({
    required String cidentity,
    required double cpayment,
    required String ccurrentupdate,
    
  }) async {
    final db = await database;

    await db.update(
      _mtableName,
      { 'payment': cpayment, 'current_update': ccurrentupdate,},
      where: 'identity = ?',
      whereArgs: [cidentity],
    );
  }

  Future<void> updateCash2({
    required String cname,
    required String cidentity,
    required String cdeadline,
    
  }) async {
    final db = await database;

    await db.update(
      _mtableName,
      { 'name': cname,'identity': cidentity, 'deadline': cdeadline, },
      where: 'identity = ?',
      whereArgs: [cidentity],
    );
  }

  Future<void> historyin(
    String cname,
    String cidentity,
    String cpayment,
    String cdate,
    String ctime,
  ) async {
    final db = await database;

    await db.insert(_histableName, {
      _cname: cname,
      _cidentity: cidentity,
      _cpayment: cpayment,
      _cdate: cdate,
      _ctime: ctime,
    });
  }

  Future<void> penDd(
    String cname,
    String cidentity,
    String cdeadline,
    String cpercent,
    String cprogress,
  ) async {
    final db = await database;

    await db.insert(_ptableName, {
      _cname: cname,
      _cidentity: cidentity,
      _cdeadline: cdeadline,
      _cpercent: cpercent,
      _cprogress: cprogress,
    });
  }

  Future<void> finishProgress(
    String cname,
    String cidentity,
    String cdeadline,
  ) async {
    final db = await database;

    await db.insert(_comtableName, {
      _cname: cname,
      _cidentity: cidentity,
      _cdeadline: cdeadline,
    });
  }

  Future<List<String>> pendIdentity() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'progress',
      columns: ['identity'],
    );
    return result.map((row) => row['identity'] as String).toList();
  }

  Future<void> addTask(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    final db = await database;

    await db.insert(_tableName, {
      _name: name,
      _email: email,
      _phone: phone,
      _password: password,
    });
  }

  Future<void> newClient(
    String cunit,
    String cname,
    String cemail,
    String cphone,
    String clocation,
    String cage,
    String cgender,
    String cdatetime,
    String cdeadline,
  ) async {
    final db = await database;

    await db.insert(_ctableName, {
      'unit': cunit,
      'name': cname,
      'email': cemail,
      'phone': cphone,
      'location': clocation,
      'age': cage,
      'gender': cgender,
      'datetime': cdatetime,
      'deadline': cdeadline,
    });
  }

  Future<void> updatebio(
    String cname,
    String cemail,
    String cphone,
    String cgender,
    String cage,
    String clocation,
    String cdeadline,
    String ccurrentupdate,
  ) async {
    final db = await database;

    await db.insert(_htableName, {
      'name': cname,
      'email': cemail,
      'phone': cphone,
      'gender': cgender,
      'age': cage,
      'location': clocation,
      'deadline': cdeadline,
      'current_update': ccurrentupdate,
    });
  }

  Future<int> delClient(String cname) async {
    final db = await database;

    return await db.delete(_htableName, where: 'name = ?', whereArgs: [cname]);
  }

  Future<void> upDate({
    required String id,
    required String name,
    required String email,
    required String phone,
  }) async {
    final db = await database;

    await db.update(
      _tableName,
      {'name': name, 'email': email, 'phone': phone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> progressUpdate({
    required String perc,
    required String clicked,
    required String identity,
  }) async {
    final db = await database;

    await db.update(
      _ptableName,
      {'percent': perc, 'progress': clicked},
      where: 'identity = ?',
      whereArgs: [identity],
    );
  }

  Future<void> comPlete({
    required String cunit,
    required String cname,

    required String cattire,
    required String cidentity,
    required String cheight,
    required String clength,
    required String cneck,
    required String cshoulder,
    required String cchest,
    required String cubust,
    required String cwaist,
    required String cbwidth,
    required String cblength,
    required String cflength,
    required String csleeve,
    required String cbicep,
    required String cwrist,
    required String carmhole,
    required String cwaistd,
    required String chip,
    required String cseat,
    required String cfrise,
    required String cbrise,
    required String coutseam,
    required String cinseam,
    required String cthigh,
    required String ccalf,
    required String cknee,
    required String cankle,
    required String cother,
  }) async {
    final db = await database;

    await db.update(
      _ctableName,
      {
        'unit': cunit,
        'name': cname,
        'attire': cattire,
        'identity': cidentity,

        'height': cheight,
        'length': clength,
        'neck': cneck,
        'shoulder': cshoulder,
        'chest': cchest,
        'underbust': cubust,
        'waisttop': cwaist,
        'backwidth': cbwidth,
        'backlength': cblength,
        'frontlength': cflength,
        'sleeve': csleeve,
        'bicep': cbicep,
        'wrist': cwrist,
        'armhole': carmhole,
        'waistdown': cwaistd,
        'hip': chip,
        'seat': cseat,
        'frontrise': cfrise,
        'backrise': cbrise,
        'outseam': coutseam,
        'inseam': cinseam,
        'thigh': cthigh,
        'calf': ccalf,
        'knee': cknee,
        'ankle': cankle,
        'otherinfo': cother,
      },
      where: 'name = ?',
      whereArgs: [cname],
    );
  }

  Future<void> comPleteupdate({
    required int cid,
    required String cname,
    required String cattire,
    required String cidentity,
    required String cemail,
    required String cphone,
    required String cgender,
    required String cage,
    required String clocation,
    required String cdeadline,
    required String ccurrentupdate,

    required String cunit,
    required String cheight,
    required String clength,
    required String cneck,
    required String cshoulder,
    required String cchest,
    required String cubust,
    required String cwaist,
    required String cbwidth,
    required String cblength,
    required String cflength,
    required String csleeve,
    required String cbicep,
    required String cwrist,
    required String carmhole,
    required String cwaistd,
    required String chip,
    required String cseat,
    required String cfrise,
    required String cbrise,
    required String coutseam,
    required String cinseam,
    required String cthigh,
    required String ccalf,
    required String cknee,
    required String cankle,
    required String cother,
  }) async {
    final db = await database;

    await db.update(
      _ctableName,
      {
        'attire': cattire,
        'identity': cidentity,
        'name': cname,
        'email': cemail,
        'phone': cphone,
        'gender': cgender,
        'age': cage,
        'location': clocation,
        'deadline': cdeadline,
        'current_update': ccurrentupdate,

        'unit': cunit,
        'height': cheight,
        'length': clength,
        'neck': cneck,
        'shoulder': cshoulder,
        'chest': cchest,
        'underbust': cubust,
        'waisttop': cwaist,
        'backwidth': cbwidth,
        'backlength': cblength,
        'frontlength': cflength,
        'sleeve': csleeve,
        'bicep': cbicep,
        'wrist': cwrist,
        'armhole': carmhole,
        'waistdown': cwaistd,
        'hip': chip,
        'seat': cseat,
        'frontrise': cfrise,
        'backrise': cbrise,
        'outseam': coutseam,
        'inseam': cinseam,
        'thigh': cthigh,
        'calf': ccalf,
        'knee': cknee,
        'ankle': cankle,
        'otherinfo': cother,
      },
      where: 'id = ?',
      whereArgs: [cid],
    );
  }

  Future<void> upDatePass({
    required String id,
    required String password,
  }) async {
    final db = await database;

    await db.update(
      _tableName,
      {'password': password},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('history', where: null);
  }

  Future<List<Map<String, dynamic>>> getAllClientIds() async {
    final db = await database;

    return await db.query(
      'clients',
      columns: ['id', 'identity', 'name', 'deadline'],
    );
  }

  Future<List<Map<String, dynamic>>> getProgressIds() async {
    final db = await database;

    return await db.query('Progress', columns: ['id']);
  }

  Future<bool> loginUser(String email, String password) async {
    final db = await database;

    final result = await db.query(
      'persons',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getByName(String tableName, String name) async {
    final db = await database;

    final result = await db.query(
      tableName,
      where: 'name = ?',
      whereArgs: [name],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<int> deleteLastByName(String tableName, String name) async {
    final db = await database;

    final result = await db.query(
      tableName,
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [name],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isEmpty) return 0;

    final id = result.first['id'] as int;

    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteByIdentity(String identity) async {
    final db = await database;

    return await db.delete(
      'progress',
      where: 'identity = ?',
      whereArgs: [identity],
    );
  }

  Future<Map<String, dynamic>?> selectUser(int id) async {
    final db = await database;

    final result = await db.query('clients', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }
  Future<Map<String, dynamic>?> selectAmount(String table, int id) async {
    final db = await database;

    final result = await db.query('payments', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<Map<String, dynamic>?> selectPendingUser(int id) async {
    final db = await database;

    final result = await db.query('progress', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<Map<String, dynamic>?> selectUserName(String name) async {
    final db = await database;

    final result = await db.query(
      'clients',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<int> deleteClient(int id) async {
    final db = await database;

    return await db.delete('clients', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<String>> getAllNames() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'clients',
      columns: ['name'],
    );
    return result.map((row) => row['name'] as String).toList();
  }

  Future<List<String>> getAllIdentity() async {
    final db = await database;

    final result = await db.query('clients', columns: ['identity']);

    return result
        .map((row) => row['identity']?.toString() ?? '')
        .where((identity) => identity.isNotEmpty)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getAllData(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // Future<List<Map<String, dynamic>>> getAllProgress() async {
  //   final db = await database;
  //   return await db.query('progress');
  // }

  // Future<List<Map<String, dynamic>>> getAllComplete() async {
  //   final db = await database;
  //   return await db.query('complete');
  // }
}
