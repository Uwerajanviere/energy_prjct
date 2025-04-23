import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/database_service.dart';
import 'upload_project_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isInvestor;

  const HomeScreen({Key? key, this.isInvestor = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF4CAF50); // Green theme for energy

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Renewable Energy Platform'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isInvestor ? InvestorView() : ProjectOwnerView(),
      floatingActionButton: !isInvestor // Show button only for project owners
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UploadProjectScreen()),
          );
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.cloud_upload, size: 30),
      )
          : null,
    );
  }
}

class InvestorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Investor View\nList of Projects will appear here!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Colors.black54),
      ),
    );
  }
}

class ProjectOwnerView extends StatelessWidget {
  final _dbService = DatabaseService();
  final Color primaryColor = const Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(
          "User not logged in",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Project>>(
            stream: _dbService.getProjectsByOwnerId(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No projects uploaded yet.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              }

              final projects = snapshot.data!;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 items per row
                  crossAxisSpacing: 8, // Smaller spacing between items
                  mainAxisSpacing: 8, // Smaller spacing between items
                  childAspectRatio: 0.75, // Adjusted to make the items smaller and balanced
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Card(
                    margin: EdgeInsets.zero,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Color(0xFFf4f8f7), // Soft grey background color
                    child: InkWell(
                      onTap: () {
                        // Handle project tap if needed
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.energy_savings_leaf,
                              color: primaryColor,
                              size: 30, // Smaller icon size
                            ),
                            const SizedBox(height: 4),
                            Text(
                              project.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // Smaller text for the title
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              project.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12, // Smaller description text
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.attach_money, size: 18, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  "${project.goalAmount.toStringAsFixed(0)} RWF",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
