import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final int level;
  final bool confirmedEmail;

  String get name => '$firstName $lastName';

  const User({
    this.firstName: '',
    this.lastName: '',
    this.username: '',
    this.email: '',
    this.level: 0,
    this.confirmedEmail: false,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    return User(
      firstName: data['firstName'],
      lastName: data['lastName'],
      username: data['username'] ?? '',
      email: data['email'],
      level: data['level'],
      confirmedEmail: data['confirmedEmail'] ?? false,
    );
  }

  User copyLevel(int newLevel) {
    return User(
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      level: newLevel,
      confirmedEmail: confirmedEmail,
    );
  }

  @override
  List<Object> get props => [name, level, confirmedEmail, email];
}
