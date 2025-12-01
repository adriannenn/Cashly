class TransactionModel {
  final String? id;
  final String userId;
  final String type; // income or expense
  final double amount;
  final String category;
  final String title;
  final String? note;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.category,
    required this.title,
    this.note,
    required this.date,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'amount': amount,
      'category': category,
      'title': title,
      'note': note,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      userId: map['user_id'],
      type: map['type'],
      amount: map['amount'].toDouble(),
      category: map['category'],
      title: map['title'],
      note: map['note'],
      date: DateTime.parse(map['date']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? type,
    double? amount,
    String? category,
    String? title,
    String? note,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      title: title ?? this.title,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'amount': amount,
      'category': category,
      'title': title,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  bool get isIncome => type.toLowerCase() == 'income';
  bool get isExpense => type.toLowerCase() == 'expense';
}
