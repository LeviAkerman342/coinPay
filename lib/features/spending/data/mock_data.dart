class Transaction {
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final String iconUrl; 

  Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    this.iconUrl = '',
  });
}

final List<Transaction> mockSpendingTransactions = [
  Transaction(title: 'Netflix', subtitle: 'Jul 14 at 2:30pm', amount: -15.90, date: DateTime(2025, 7, 14)),
  Transaction(title: 'Google Play', subtitle: 'Jul 12 at 10:00am', amount: -9.99, date: DateTime(2025, 7, 12)),
  Transaction(title: 'Amazon', subtitle: 'Jul 10 at 18:45pm', amount: -89.00, date: DateTime(2025, 7, 10)),
 
];

final double totalSpent = 500.00;
final double availableBalance = 20000.00;

final List<double> dailySpending = [0, 50, 30, 100, 80, 150, 90];