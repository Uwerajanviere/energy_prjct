import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import '../models/project_model.dart';

class MyProjectsScreen extends StatelessWidget {
  final _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("My Projects")),
      body: user == null
          ? Center(child: Text("User not logged in"))
          : StreamBuilder<List<Project>>(
        stream: _dbService.getProjectsByOwnerId(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No projects uploaded yet."));
          }
          final projects = snapshot.data!;
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(project.title),
                  subtitle: Text(project.description),
                  trailing: Text("${project.goalAmount.toStringAsFixed(0)} RWF"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
