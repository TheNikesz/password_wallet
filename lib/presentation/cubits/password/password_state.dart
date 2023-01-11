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
  late bool isEdit;
  final List<Password> passwords;
  final List<Password> sharedPasswords;

  PasswordSuccess({
    this.isEdit = false,
    required this.passwords,
    required this.sharedPasswords,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PasswordSuccess &&
      listEquals(other.passwords, passwords) &&
      listEquals(other.sharedPasswords, sharedPasswords) &&
      other.isEdit == isEdit;
  }

  @override
  int get hashCode => passwords.hashCode ^ isEdit.hashCode;

  PasswordSuccess copyWith({
    bool? isEdit,
    List<Password>? passwords,
    List<Password>? sharedPasswords,
  }) {
    return PasswordSuccess(
      isEdit: isEdit ?? this.isEdit,
      passwords: passwords ?? this.passwords,
      sharedPasswords: sharedPasswords ?? this.sharedPasswords,
    );
  }
}

class PasswordFailure extends PasswordState {
  const PasswordFailure();
}
