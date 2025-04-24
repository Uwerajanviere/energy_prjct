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
      return const Center(
        child: Text(
          "User not logged in",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFE0E0), // Light pink background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// --- Hero Section ---
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Renewable Energy Investment",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Welcome to the Renewable Energy Investment Platform",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "This platform connects renewable energy innovators like you with people and organizations ready to invest in clean, green projects "
                          " Whether it's solar, wind, or hydro power—this is your space to shine, share your vision, and find the right backers.",
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// --- How It Helps Section ---
            /// --- How It Helps Section (Updated Style) ---
            Center(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How This App Helps You",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Bullet 1
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.cloud_upload, color: Colors.green, size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Upload your green energy project and showcase it to potential investors.",
                            style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /// Bullet 2
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.visibility, color: Colors.green, size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Get discovered by individuals and organizations looking to invest in eco-friendly ideas.",
                            style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /// Bullet 3
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.bar_chart, color: Colors.green, size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Track engagement and funding progress in real time.",
                            style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /// Bullet 4
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.group, color: Colors.green, size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Receive support from a global community passionate about sustainable development.",
                            style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// --- Project List Header ---
            Text(
              "Your Uploaded Projects",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),

            /// --- Projects Stream ---
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: StreamBuilder<List<Project>>(
                stream: _dbService.getProjectsByOwnerId(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No projects uploaded yet.",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    );
                  }

                  final projects = snapshot.data!;

                  return GridView.builder(
                    itemCount: projects.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final project = projects[index];

                      return Card(
                        color: const Color(0xFFC8F5CB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 3,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            // TODO: Handle project tap
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.energy_savings_leaf, color: primaryColor, size: 28),
                                const SizedBox(height: 8),
                                Text(
                                  project.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  project.description,
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money, size: 18, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      project.goalAmount.toStringAsFixed(0),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
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
        ),
      ),
    );
  }
}
