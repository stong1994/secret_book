import '../model/secret.dart';

abstract class SecretData {
  Future<void> clean();
  Future<List<Secret>> fetchSecrets();
  Future<Secret> addSecret(Secret secret);
  Future<Secret> updateSecret(Secret secret);
  Future deleteSecret(Secret secret);
}
