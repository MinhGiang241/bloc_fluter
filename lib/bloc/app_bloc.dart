import 'package:bloc/bloc.dart';
import 'package:bloc_app/apis/login_api.dart';
import 'package:bloc_app/bloc/actions.dart';
import 'package:bloc_app/bloc/app_state.dart';
import 'package:bloc_app/models.dart';

import '../apis/note_api.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiPrptocol notesApi;

  AppBloc({required this.loginApi, required this.notesApi})
      : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        // Start Login
        emit(
          const AppState(
            loginHandle: null,
            fetchNotes: null,
            isLoading: true,
            loginErrors: null,
          ),
        );

        final loginHandle =
            await loginApi.login(email: event.email, password: event.password);

        emit(
          AppState(
            loginHandle: loginHandle,
            fetchNotes: null,
            isLoading: false,
            loginErrors: loginHandle == null ? LoginErrors.invalidHandle : null,
          ),
        );
      },
    );

    on<LoadNotesAction>(
      (event, emit) async {
        // start loading
        emit(
          AppState(
            loginHandle: state.loginHandle,
            fetchNotes: state.fetchNotes,
            isLoading: true,
            loginErrors: null,
          ),
        );

        // get the login handle
        final loginHandle = state.loginHandle;

        if (loginHandle != const LoginHandle.fooBar()) {
          emit(
            AppState(
              isLoading: false,
              loginErrors: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
              fetchNotes: null,
            ),
          );
          return;
        }
        // we have valid login handle and want to fetch note

        final notes = await notesApi.getNotes(loginHandle: loginHandle!);

        emit(
          AppState(
            fetchNotes: notes,
            loginErrors: null,
            isLoading: false,
            loginHandle: loginHandle,
          ),
        );
      },
    );
  }
}
