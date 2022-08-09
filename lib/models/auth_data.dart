class AuthData {
  late final String id;
  late final String email;
  late final String name;
  late final String role;
  late final String token;

  AuthData.fromMap(Map map) {
    id = map['id'];
    email = map['email'];
    name = map['name'];
    role = map['role'];
    token = map['token'];
  }

  Map toMap() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role,
        'token': token,
      };
}
