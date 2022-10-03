class AuthException implements Exception {
  String cause;
  AuthException(this.cause);
}

class FirestoreException implements Exception {
  String cause;
  FirestoreException(this.cause);
}