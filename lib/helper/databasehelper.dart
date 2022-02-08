import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_test/model/item.dart';
import 'package:sqlite_test/model/walletItem.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database, _walletDatabase;
  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> get walletDatabase async =>
      _walletDatabase ??= await _initWalletDatabase();

  Future<Database> _initDatabase() async {
    Directory documentoryDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentoryDirectory.path, 'ItemData.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<Database> _initWalletDatabase() async {
    Directory documentoryDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentoryDirectory.path, 'ItemWallet.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onWalletCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Item(
      id INTEGER PRIMARY KEY,
      name TEXT,
      price TEXT,
      quantity INTEGER
    )
    ''');
  }

  Future _onWalletCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Wallet(
      id INTEGER PRIMARY KEY,
      title TEXT,
      description TEXT,
      date TEXT,
      amount INTEGER
    )
    ''');
  }

  Future<List<Item>> getItemData() async {
    Database db = await instance.database;
    var itemData = await db.query('Item', orderBy: 'name');
    List<Item> itemList = itemData.isNotEmpty
        ? itemData.map((data) => Item.fromMap(data)).toList()
        : [];
    return itemList;
  }

  Future<List<WalletItem>> getWalletData() async {
    Database db = await instance.walletDatabase;
    var walletData = await db.query('Wallet', orderBy: 'title');
    List<WalletItem> walletList = walletData.isNotEmpty
        ? walletData.map((data) => WalletItem.fromMap(data)).toList()
        : [];
    return walletList;
  }

  Future add(Item item) async {
    Database db = await instance.database;
    return await db.insert('Item', item.toMap());
  }

  Future addWallet(WalletItem walletItem) async {
    Database db = await instance.walletDatabase;
    return await db.insert('Wallet', walletItem.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('Item', where: 'id = ? ', whereArgs: [id]);
  }

  Future<int> removeWallet(int id) async {
    Database db = await instance.walletDatabase;
    return await db.delete('Wallet', where: 'id = ? ', whereArgs: [id]);
  }

  Future<int> update(Item item) async {
    Database db = await instance.database;
    return await db
        .update('Item', item.toMap(), where: 'id = ? ', whereArgs: [item.id]);
  }

  Future<int> updateWallet(WalletItem walletItem) async {
    Database db = await instance.walletDatabase;
    return await db.update('Wallet', walletItem.toMap(),
        where: 'id = ? ', whereArgs: [walletItem.id]);
  }
}
