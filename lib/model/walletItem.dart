import 'dart:convert';

class WalletItem {
  final int? id;
  final String? title;
  final String? description;
  final String? date;
  final int? amount;
  WalletItem({
    this.id,
    this.title,
    this.description,
    this.date,
    this.amount,
  });

  WalletItem copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    int? amount,
  }) {
    return WalletItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'amount': amount,
    };
  }

  factory WalletItem.fromMap(Map<String, dynamic> map) {
    return WalletItem(
      id: map['id']?.toInt(),
      title: map['title'],
      description: map['description'],
      date: map['date'],
      amount: map['amount']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletItem.fromJson(String source) =>
      WalletItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WalletItem(id: $id, title: $title, description: $description, date: $date, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletItem &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.date == date &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        date.hashCode ^
        amount.hashCode;
  }
}
