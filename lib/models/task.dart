class Task {
  final String id;
  final String name;
  final bool isDefault;

  Task({required this.id, required this.name, required this.isDefault});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      isDefault: json['isDefault']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isDefault':isDefault,
    };
  }

  bool operator ==(dynamic other) =>
      other != null && other is Task && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}