class Deposit {
  String contractId;
  String depositoId;
  String name;
  String accountId;
  int minMonth;
  int amount;
  double bonus;

  Deposit({
    required this.contractId,
    required this.depositoId,
    required this.name,
    required this.accountId,
    required this.minMonth,
    required this.amount,
    required this.bonus,
  });

  // Factory constructor to create an instance from JSON
  factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
      contractId: json['contract_id'] as String,
      depositoId: json['deposito_id'] as String,
      name: json['name'] as String,
      accountId: json['account_id'] as String,
      minMonth: json['min_month'] as int,
      amount: json['amount'] as int,
      bonus: json['bonus'] as double,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'contract_id': contractId,
      'deposito_id': depositoId,
      'name': name,
      'account_id': accountId,
      'min_month': minMonth,
      'amount': amount,
      'bonus': bonus,
    };
  }
}
