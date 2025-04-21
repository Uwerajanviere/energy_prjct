import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';

class DatabaseService {
  final CollectionReference projectCollection =
  FirebaseFirestore.instance.collection('projects');

  // Upload a new project to Firestore
  Future<void> uploadProject(Project project) async {
    await projectCollection.doc(project.id).set(project.toMap());
  }

  // Get all projects (optional for general listing)
  Stream<List<Project>> getProjects() {
    return projectCollection.snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Project.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // ✅ Get projects uploaded by a specific owner (used in project owner dashboard)
  Stream<List<Project>> getProjectsByOwnerId(String ownerId) {
    return projectCollection
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Project.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
