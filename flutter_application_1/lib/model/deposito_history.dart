class DepositHistory {
  int id;
  String depositId;
  int accountId;
  String depositName;
  int amount;
  int timePeriod;
  DateTime timeStamp;

  DepositHistory({
    required this.id,
    required this.depositId,
    required this.accountId,
    required this.depositName,
    required this.amount,
    required this.timePeriod,
    required this.timeStamp,
  });

  // Factory constructor to create an instance from JSON
  factory DepositHistory.fromJson(Map<String, dynamic> json) {
    return DepositHistory(
      id: json['id'] as int,
      depositId: json['deposit_id'] as String,
      accountId: json['account_id'] as int,
      depositName: json['deposit_name'] as String,
      amount: json['amount'] as int,
      timePeriod: json['time_period'] as int,
      timeStamp: DateTime.parse(json['time_stamp'] as String),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deposit_id': depositId,
      'account_id': accountId,
      'deposit_name': depositName,
      'amount': amount,
      'time_period': timePeriod,
      'time_stamp': timeStamp.toIso8601String(),
    };
  }
}
