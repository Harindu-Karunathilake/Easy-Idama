import 'package:flutter/material.dart';
import 'package:mad/services/firestore_service.dart';
import 'package:mad/services/auth_service.dart';

class UserRoleManagementScreen extends StatefulWidget {
  @override
  _UserRoleManagementScreenState createState() => _UserRoleManagementScreenState();
}

class _UserRoleManagementScreenState extends State<UserRoleManagementScreen> {
  final UserManagementService _userManagementService = UserManagementService();
  final AuthService _authService = AuthService();

  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      List<Map<String, dynamic>> fetchedUsers = await _userManagementService.fetchUsers();
      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error loading users: $e")));
    }
  }

  void _deleteUser(String uid, String email) async {
    try {
      await _userManagementService.deleteUser(uid);
      await _authService.deleteUserAuth(email);
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting user: $e")));
    }
  }

  void _changeUserRole(String uid) {
  showDialog(
    context: context,
    builder: (context) {
      String selectedRole = "user"; // Default role selection
      return AlertDialog(
        title: Text("Change User Role"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DropdownButton<String>(
              value: selectedRole,
              onChanged: (String? newRole) {
                if (newRole != null) {
                  setState(() {
                    selectedRole = newRole; // Update the selected role
                  });
                }
              },
              items: ["admin", "user"].map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _userManagementService.updateUserRole(uid, selectedRole);
                _loadUsers();
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating role: $e")));
              }
            },
            child: Text("Save"),
          ),
        ],
      );
    },
  );
}


  void _toggleUserStatus(String uid, String currentStatus) async {
    String newStatus = currentStatus == "active" ? "inactive" : "active";
    try {
      await _userManagementService.updateUserStatus(uid, newStatus);
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating status: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Management")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ListTile(
              title: Text(user["name"]),
              subtitle: Text("${user["email"]} - ${user["role"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _changeUserRole(user["uid"]),
                  ),
                  IconButton(
                    icon: Icon(user["status"].toLowerCase() == "active" ? Icons.check_circle : Icons.block, 
                        color: user["status"].toLowerCase() == "active" ? Colors.green : Colors.orange),
                    onPressed: () => _toggleUserStatus(user["uid"], user["status"]),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(user["uid"], user["email"]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
