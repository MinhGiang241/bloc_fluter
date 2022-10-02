import 'package:bloc_app/apis/note_api.dart';
import 'package:bloc_app/bloc/app_bloc.dart';
import 'package:bloc_app/bloc/app_state.dart';
import 'package:bloc_app/dailogs/generic_dailog.dart';
import 'package:bloc_app/dailogs/loading_screen.dart';
import 'package:bloc_app/strings.dart';
import 'package:bloc_app/views/iterable_list.dart';
import 'package:bloc_app/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'apis/login_api.dart';
import 'bloc/actions.dart';
import 'models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => AppBloc(
          loginApi: LoginApi(),
          notesApi: NotesApi(),
        ),
        child: Scaffold(
          appBar: AppBar(title: const Text(homePage)),
          body: BlocConsumer<AppBloc, AppState>(
            listener: (context, appState) {
              // loading screen
              if (appState.isLoading) {
                LoadingScreen.instance()
                    .show(context: context, text: pleaseWait);
              } else {
                LoadingScreen.instance().hide();
              }

              final loginError = appState.loginErrors;
              if (loginError != null) {
                showGenericDailog(
                  context: context,
                  title: loginErrorDialogTitle,
                  content: loginErrorDialogContent,
                  optionBuilder: () => {ok: true},
                );
              }

              // if we are logged in , but we have no fetched noted , fetch them now
              if (appState.isLoading == false &&
                  appState.loginErrors == null &&
                  appState.loginHandle == const LoginHandle.fooBar() &&
                  appState.fetchNotes == null) {
                context.read<AppBloc>().add(const LoadNotesAction());
              }
            },
            builder: (context, appState) {
              final notes = appState.fetchNotes;
              if (notes == null) {
                return LoginView(
                  onLoginTapped: (email, password) {
                    context
                        .read<AppBloc>()
                        .add(LoginAction(email: email, password: password));
                  },
                );
              } else {
                return notes.toListView();
              }
            },
          ),
        ),
      ),
    );
  }
}
