part of 'session_cubit.dart';

@immutable
abstract class SessionState {}

class SessionUnauthenticated extends SessionState {}

class SessionFailure extends SessionState {
  final String message;

  SessionFailure({required this.message});
}

class SessionAuthenticated extends SessionState {
   final Session session;

  SessionAuthenticated({required this.session});
}