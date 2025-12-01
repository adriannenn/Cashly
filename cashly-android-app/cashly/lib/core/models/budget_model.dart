class BudgetModel {
  final String? id;
  final String userId;
  final String name;
  final double amount;
  final String category;
  final String period; // monthly, weekly, yearly
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  BudgetModel({
    this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.category,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'amount': amount,
      'category': category,
      'period': period,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      amount: map['amount'].toDouble(),
      category: map['category'],
      period: map['period'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      description: map['description'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  BudgetModel copyWith({
    String? id,
    String? userId,
    String? name,
    double? amount,
    String? category,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'amount': amount,
      'category': category,
      'period': period,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
    };
  }
}
