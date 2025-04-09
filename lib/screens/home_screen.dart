import 'package:flutter/material.dart';
import 'upload_project_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isInvestor;

  const HomeScreen({Key? key, this.isInvestor = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Renewable Energy Investment'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // TODO: Add logout logic
            },
          ),
        ],
      ),
      body: isInvestor ? InvestorView() : ProjectOwnerView(),
    );
  }
}

class InvestorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Investor View - List of Projects will appear here"),
    );
  }
}

class ProjectOwnerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => UploadProjectScreen()));
        },
        child: Text("Upload New Project"),
      ),
    );
  }
}

