import '../model/account.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../config/config.dart';

class AccountBookData {
  // WidgetsFlutterBinding.ensureInitialized();
  Future<Database> createDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), tokenTableName),
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE accounts(id TEXT PRIMARY KEY, title TEXT, account TEXT, password TEXT, comment TEXT)');
      },
    );
  }

  Future<void> clean() async {
    final db = await createDatabase();
    await db.delete(accountTableName);
    return;
  }

  Future<Account> addAccount(Account account) async {
    final db = await createDatabase();
    account.id = Uuid().v4();
    await db.insert(accountTableName, account.toJson());
    return account;
  }

  Future deleteAccount(Account account) async {
    final db = await createDatabase();
    await db.delete(
      accountTableName,
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<List<Account>> fetchAccounts() async {
    final db = await createDatabase();
    final accounts = await db.query(accountTableName);
    return List.generate(
        accounts.length, (index) => Account.fromJson(accounts[index]));
  }

  Future<Account> getAccountByID(String id) async {
    final db = await createDatabase();
    final accounts = await db.query(
      accountTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return Account.fromJson(accounts.first);
  }

  Future<Account> updateAccount(Account account) async {
    final db = await createDatabase();
    await db.update(
      accountTableName,
      account.toJson(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
    return account;
  }
}
