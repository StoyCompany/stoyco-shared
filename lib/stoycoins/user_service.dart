import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

/// Service for managing user authentication and anonymous IDs
class UserService {

  /// Constructor
  UserService({FirebaseAuth? auth, Uuid? uuid})
      : _auth = auth ?? FirebaseAuth.instance,
        _uuid = uuid ?? const Uuid();
  final FirebaseAuth _auth;
  final Uuid _uuid;

  /// Gets the current user ID (authenticated or anonymous)
  String getCurrentUserId() {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return _generateAnonymousId();
  }

  /// Checks if the current user is authenticated
  bool isUserAuthenticated() => _auth.currentUser != null;

  /// Gets the current Firebase user
  User? getCurrentUser() => _auth.currentUser;

  /// Generates a unique anonymous ID
  String _generateAnonymousId() => 'anonymous_${_uuid.v4()}';

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
