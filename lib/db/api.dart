
import '../model/secret.dart';
import '../model/account.dart';

abstract class SecretData {
  Future<void> clean();
  Future<List<Secret>> fetchSecrets();
  Future<Secret> addSecret(Secret secret);
  Future<Secret> updateSecret(Secret secret);
  Future deleteSecret(Secret secret);
}

abstract class AccountData {
  Future<void> clean();
  Future<List<Account>> fetchAccounts();
  Future<Account> addAccount(Account account);
  Future<Account> updateAccount(Account account);
  Future deleteAccount(Account account);
}
