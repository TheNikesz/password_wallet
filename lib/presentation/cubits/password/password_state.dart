part of 'password_cubit.dart';

@immutable
abstract class PasswordState {
  const PasswordState();
}

class PasswordInitial extends PasswordState {
  const PasswordInitial();
}

class PasswordLoading extends PasswordState {
  const PasswordLoading();
}

class PasswordSuccess extends PasswordState {
  final List<Password> passwords;

  const PasswordSuccess(this.passwords);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PasswordSuccess &&
      listEquals(other.passwords, passwords);
  }

  @override
  int get hashCode => passwords.hashCode;
}

class PasswordFailure extends PasswordState {
  const PasswordFailure();
}
