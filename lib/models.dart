class Transaction {
  final String type;
  final String description;
  final double amount;
  final String category;
  final DateTime date;

  Transaction({
    required this.type,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('type') ||
        !json.containsKey('description') ||
        !json.containsKey('amount') ||
        !json.containsKey('category') ||
        !json.containsKey('date')) {
      throw FormatException('Missing required fields in Transaction JSON');
    }

    return Transaction(
      type: json['type'] as String,
      description: json['description'] as String,
      amount: (json['amount'] is num ? (json['amount'] as num).toDouble() : 0.0),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  @override
  String toString() {
    return 'Transaction(type: $type, description: $description, amount: $amount, category: $category, date: $date)';
  }
}

class Budget {
  final String category;
  final double limit;
  double spent;

  Budget({
    required this.category,
    required this.limit,
    this.spent = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'limit': limit,
      'spent': spent,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('category') || !json.containsKey('limit') || !json.containsKey('spent')) {
      throw FormatException('Missing required fields in Budget JSON');
    }

    return Budget(
      category: json['category'] as String,
      limit: (json['limit'] is num ? (json['limit'] as num).toDouble() : 0.0),
      spent: (json['spent'] is num ? (json['spent'] as num).toDouble() : 0.0),
    );
  }

  @override
  String toString() {
    return 'Budget(category: $category, limit: $limit, spent: $spent)';
  }
}
