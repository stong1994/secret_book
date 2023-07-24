import '../model/account.dart';
import 'api.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../config/config.dart';

class AccountBookData implements AccountData {
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

  @override
  Future<void> clean() async {
    final db = await createDatabase();
    await db.delete(accountTableName);
    return;
  }

  @override
  Future<Account> addAccount(Account account) async {
    final db = await createDatabase();
    account.id = Uuid().v4();
    await db.insert(accountTableName, account.toJson());
    return account;
  }

  @override
  Future deleteAccount(Account account) async {
    final db = await createDatabase();
    await db.delete(
      accountTableName,
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  @override
  Future<List<Account>> fetchAccounts() async {
    final db = await createDatabase();
    final accounts = await db.query(accountTableName);
    return List.generate(
        accounts.length, (index) => Account.fromJson(accounts[index]));
  }

  @override
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
