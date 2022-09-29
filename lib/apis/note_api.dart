import 'package:bloc_app/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NotesApiPrptocol {
  const NotesApiPrptocol();
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle});
}

@immutable
class NotesApi implements NotesApiPrptocol {
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => loginHandle == const LoginHandle.fooBar() ? mockNotes : null,
    );
  }
}
