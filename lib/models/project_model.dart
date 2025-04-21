class Project {
  final String id;
  final String title;
  final String description;
  final String type; // solar, wind, hydro
  final String location;
  final double goalAmount;
  final double currentAmount;
  final String ownerEmail;
  final String ownerId;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.goalAmount,
    required this.currentAmount,
    required this.ownerEmail,
    required this.ownerId,
  });

  // Convert to Firestore-friendly map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'location': location,
      'goalAmount': goalAmount,
      'currentAmount': currentAmount,
      'ownerEmail': ownerEmail,
      'ownerId': ownerId,
    };
  }

  // Create a Project from Firestore map
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      location: map['location'],
      goalAmount: (map['goalAmount'] as num).toDouble(),
      currentAmount: (map['currentAmount'] as num).toDouble(),
      ownerEmail: map['ownerEmail'] ?? '',
      ownerId: map['ownerId'] ?? '',
    );
  }
}
