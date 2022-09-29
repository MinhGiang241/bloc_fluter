import 'package:bloc_app/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginErrors;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchNotes;

  const AppState({
    required this.isLoading,
    required this.loginErrors,
    required this.loginHandle,
    required this.fetchNotes,
  });

  const AppState.empty()
      : isLoading = false,
        loginErrors = null,
        loginHandle = null,
        fetchNotes = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginError': loginErrors,
        'loginHandle': loginHandle,
        'fetchNotes': fetchNotes
      }.toString();
}
