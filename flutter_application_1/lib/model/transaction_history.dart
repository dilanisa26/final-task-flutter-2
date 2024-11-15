class TransactionHistory {
  int id;
  int accountId;
  String transactionCategory;
  int amount;
  int inOut;
  DateTime timeStamp;

  TransactionHistory({
    required this.id,
    required this.accountId,
    required this.transactionCategory,
    required this.amount,
    required this.inOut,
    required this.timeStamp,
  });

  // Factory constructor to create an instance from JSON
  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      id: json['id'] as int,
      accountId: json['account_id'] as int,
      transactionCategory: json['transaction_category'] as String,
      amount: json['amount'] as int,
      inOut: json['in_out'] as int,
      timeStamp: DateTime.parse(json['time_stamp'] as String),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'transaction_category': transactionCategory,
      'amount': amount,
      'in_out': inOut,
      'time_stamp': timeStamp.toIso8601String(),
    };
  }
}
