import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> uploadProject(Project project) async {
    await _db.collection('projects').doc(project.id).set(project.toMap());
  }
}
