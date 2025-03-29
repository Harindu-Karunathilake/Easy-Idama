import 'package:flutter/material.dart';
import 'package:mad/pages/admin/verifyListings.dart';
import 'user_management.dart'; 
import 'property_management.dart'; // Import the Property Management page

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Admin Dashboard!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserRoleManagementScreen()),
                );
              },
              child: Text('Manage Users & Roles'),
            ),
            SizedBox(height: 10), // Add spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PropertyManagementPage()), // Navigate to Property Management
                );
              },
              child: Text('Manage Properties'),
            ),
             SizedBox(height: 10), // Add spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerifyListingPage()), // Navigate to Property Management
                );
              },
              child: Text('Verify Listings'),
            ),
          ],
        ),
      ),
    );
  }
}