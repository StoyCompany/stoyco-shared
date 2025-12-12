import 'package:flutter/foundation.dart';

/// Global service to manage social interaction state across the app.
///
/// This service provides a reactive way to handle authentication changes
/// and notify all social button widgets to refresh their state.
///
/// Usage:
/// ```dart
/// // Initialize in your app startup
/// final service = SocialInteractionService.instance;
///
/// // When user logs in/out
/// service.notifyAuthenticationChanged();
///
/// // Listen to auth changes in your widgets
/// service.addAuthListener(() {
///   // Reload social interactions
/// });
/// ```
class SocialInteractionService extends ChangeNotifier {
  SocialInteractionService._();

  static final SocialInteractionService _instance = SocialInteractionService._();
  static SocialInteractionService get instance => _instance;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  final List<VoidCallback> _authChangeListeners = [];

  /// Updates the authentication state and notifies all listeners.
  void setAuthenticationState(bool isAuthenticated) {
    if (_isAuthenticated != isAuthenticated) {
      _isAuthenticated = isAuthenticated;
      notifyListeners();
      _notifyAuthChangeListeners();
    }
  }

  /// Notifies all social interaction widgets that authentication state has changed.
  /// This will trigger a reload of interaction data (likes, shares, etc).
  void notifyAuthenticationChanged() {
    notifyListeners();
    _notifyAuthChangeListeners();
  }

  /// Adds a listener for authentication changes.
  /// Returns a function to remove the listener.
  VoidCallback addAuthListener(VoidCallback listener) {
    _authChangeListeners.add(listener);
    return () => _authChangeListeners.remove(listener);
  }

  /// Removes a specific authentication change listener.
  void removeAuthListener(VoidCallback listener) {
    _authChangeListeners.remove(listener);
  }

  void _notifyAuthChangeListeners() {
    // Create a copy to avoid concurrent modification
    final listeners = List<VoidCallback>.from(_authChangeListeners);
    for (final listener in listeners) {
      try {
        listener();
      } catch (e) {
        debugPrint('Error notifying auth listener: $e');
      }
    }
  }

  /// Clears all listeners (useful for testing).
  void clearListeners() {
    _authChangeListeners.clear();
  }
}

mixin AuthReactiveMixin {
  VoidCallback? _removeAuthListener;

  /// Call this in initState to start listening to auth changes.
  void initAuthListener(VoidCallback onAuthChanged) {
    _removeAuthListener = SocialInteractionService.instance.addAuthListener(
      onAuthChanged,
    );
  }

  /// Call this in dispose to stop listening to auth changes.
  void disposeAuthListener() {
    _removeAuthListener?.call();
  }
}


