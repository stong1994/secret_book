import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:base32/base32.dart';

Uint8List toBytes(int value) {
  var result = <int>[];
  var mask = 0xFF;
  var shifts = [56, 48, 40, 32, 24, 16, 8, 0];
  for (var shift in shifts) {
    result.add(((value >> shift) & mask));
  }
  return Uint8List.fromList(result);
}

int toUint32(Uint8List bytes) {
  return (bytes[0] << 24) + (bytes[1] << 16) + (bytes[2] << 8) + bytes[3];
}

Uint8List decodeBase32String(String input) {
  // Convert input string to uppercase and remove any spaces
  var inputNoSpacesUpper = input.toUpperCase().replaceAll(' ', '');

  // Decode base32 string
  var decodedBytes = base32.decode(inputNoSpacesUpper);

  return Uint8List.fromList(decodedBytes);
}

class authCode {
  String code;
  int expireSecond;

  authCode({required this.code, required this.expireSecond});
}

authCode getCode(String secret) {
  var inputNoSpaces = secret.replaceAll(" ", "");
  var inputNoSpacesUpper = inputNoSpaces.toUpperCase();
  var key = base32.decode(inputNoSpacesUpper);
  var epochSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  var code = oneTimePassword(key, toBytes(epochSeconds ~/ 30));
  var codeStr = code.toString().padLeft(6, '0');
  var secondsRemaining = 30 - (epochSeconds % 30);
  return authCode(code: codeStr, expireSecond: secondsRemaining);
}

int oneTimePassword(List<int> key, List<int> value) {
  // sign the value using HMAC-SHA1
  var hmacSha1 = Hmac(sha1, key);
  var hash = hmacSha1.convert(value);

  // We're going to use a subset of the generated hash.
  // Using the last nibble (half-byte) to choose the index to start from.
  // This number is always appropriate as it's maximum decimal 15, the hash will
  // have the maximum index 19 (20 bytes of SHA1) and we need 4 bytes.
  var offset = hash.bytes[hash.bytes.length - 1] & 0x0F;

  // get a 32-bit (4-byte) chunk from the hash starting at offset
  var hashParts = Uint8List.fromList(hash.bytes.sublist(offset, offset + 4));

  // ignore the most significant bit as per RFC 4226
  hashParts[0] = hashParts[0] & 0x7F;

  var number = ByteData.view(hashParts.buffer).getUint32(0);

  // size to 6 digits
  // one million is the first number with 7 digits so the remainder
  // of the division will always return < 7 digits
  var pwd = number % 1000000;

  return pwd;
}
