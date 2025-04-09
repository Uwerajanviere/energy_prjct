class Project {
  final String id;
  final String title;
  final String description;
  final String type; // solar, wind, hydro
  final String location;
  final double goalAmount;
  final double currentAmount;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.goalAmount,
    required this.currentAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'location': location,
      'goalAmount': goalAmount,
      'currentAmount': currentAmount,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      location: map['location'],
      goalAmount: map['goalAmount'],
      currentAmount: map['currentAmount'],
    );
  }
}
