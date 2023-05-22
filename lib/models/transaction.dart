enum TransactionType { withdraw, deposit }

class Transaction {
  final double amount;
  final TransactionType type;
  final DateTime date;

  Transaction(this.amount, this.type, this.date);
}
