import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';

class DatabaseService {
  final _projectsRef = FirebaseFirestore.instance.collection('projects');

  Future<void> uploadProject(Project project) async {
    await _projectsRef.doc(project.id).set(project.toMap());
  }

  Stream<List<Project>> getUserProjects(String userId) {
    return _projectsRef
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Project.fromMap(doc.data())).toList());
  }
}
