class Project {
  final String id;
  final String name;
  final bool isDefault;
  
  Project({required this.id, required this.name, required this.isDefault});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
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
}