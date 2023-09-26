import '../model/account.dart';
import 'package:uuid/uuid.dart';
import '../config/config.dart';
import 'scheme.dart';

class AccountBookData {
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

  Future<List<Account>> fetchAccounts(String key) async {
    final db = await createDatabase();
    final accounts = await db.query(accountTableName);
    if (key.isEmpty) {
      return List.generate(
          accounts.length, (index) => Account.fromJson(accounts[index]));
    }
    key = key.toLowerCase();
    final filteredAccounts = accounts
        .where((account) =>
            account['title'].toString().toLowerCase().contains(key) ||
            account['account'].toString().toLowerCase().contains(key) ||
            account['comment'].toString().toLowerCase().contains(key))
        .toList();

    return List.generate(filteredAccounts.length,
        (index) => Account.fromJson(filteredAccounts[index]));
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
