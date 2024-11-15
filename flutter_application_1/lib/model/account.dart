class Account {
  int id;
  String username;
  String password;
  int role;

  Account({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  // Method to convert JSON to Account object
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      role: json['role'] as int,
    );
  }

  // Method to convert Account object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
    };
  }
}
