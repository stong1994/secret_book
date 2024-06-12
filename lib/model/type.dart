enum DataType {
  account,
  token,
  google_auth,
}

DataType getDataTypeFromString(String type) {
switch (type) {
   case 'account':
     return DataType.account;
   case 'token':
     return DataType.token;
   case 'google_auth':
     return DataType.google_auth;
   default:
     throw ArgumentError('Invalid type string: $type');
}
}

