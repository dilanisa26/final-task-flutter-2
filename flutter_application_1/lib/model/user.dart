class User {
  int id;
  int accountId;
  int accountNumber;
  String name;
  String address;
  int idCard;
  String mothersName;
  DateTime dateOfBirth;
  String gender;
  int balance;

  User({
    required this.id,
    required this.accountId,
    required this.accountNumber,
    required this.name,
    required this.address,
    required this.idCard,
    required this.mothersName,
    required this.dateOfBirth,
    required this.gender,
    required this.balance,
  });

  // Factory constructor to create an instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      accountId: json['account_id'] as int,
      accountNumber: json['account_number'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      idCard: json['id_card'] as int,
      mothersName: json['mothers_name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String,
      balance: json['balance'] as int,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'account_number': accountNumber,
      'name': name,
      'address': address,
      'id_card': idCard,
      'mothers_name': mothersName,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'balance': balance,
    };
  }
}
