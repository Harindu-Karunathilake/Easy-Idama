import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRoleManagementScreen extends StatefulWidget {
  const UserRoleManagementScreen({super.key});

  @override
  _UserRoleManagementScreenState createState() => _UserRoleManagementScreenState();
}

class _UserRoleManagementScreenState extends State<UserRoleManagementScreen> {
  List<Map<String, String>> users = [
    {"name": "John Doe", "email": "john@email.com", "role": "Admin", "status": "Active"},
    {"name": "Jane Smith", "email": "jane@email.com", "role": "Agent", "status": "Pending"},
    {"name": "Mark Wilson", "email": "mark@email.com", "role": "Buyer", "status": "Suspended"},
  ];

  String searchQuery = "";

  void _editUser(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) {
        String selectedRole = user["role"]!;
        return AlertDialog(
          title: Text("Edit User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Name: ${user['name']}"),
              Text("Email: ${user['email']}"),
              DropdownButton<String>(
                value: selectedRole,
                onChanged: (String? newRole) {
                  setState(() {
                    selectedRole = newRole!;
                  });
                },
                items: ["Admin", "Agent", "Buyer", "Seller"].map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  user["role"] = selectedRole;
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deactivateUser(int index) {
    setState(() {
      users[index]["status"] = "Deactivated";
    });
  }

  void _activateUser(int index) {
    setState(() {
      users[index]["status"] = "Active";
    });
  }

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  void _addUser() {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    String selectedRole = "Buyer";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedRole,
                onChanged: (String? newRole) {
                  setState(() {
                    selectedRole = newRole!;
                  });
                },
                items: ["Admin", "Agent", "Buyer", "Seller"].map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                  try {
                    // Create user using Firebase Authentication
                    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: 'temporaryPassword123', // Password is temporary; user will reset it
                    );

                    // Store additional user data in Firestore
                    await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
                      'name': nameController.text,
                      'email': emailController.text,
                      'role': selectedRole,
                      'status': 'Pending', // User status is pending until they reset their password
                    });

                    // Send a password reset email to the new user
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);

                    setState(() {
                      users.add({
                        "name": nameController.text,
                        "email": emailController.text,
                        "role": selectedRole,
                        "status": "Pending", // Pending until password is set
                      });
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invite sent to ${emailController.text}")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
                    );
                  }
                }
              },
              child: Text("Send Invite"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredUsers = users
        .where((user) => user["name"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("User & Role Management"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 10),
            // User List
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  var user = filteredUsers[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Icon(Icons.person, color: Colors.blue),
                      ),
                      title: Text(user["name"]!),
                      subtitle: Text(user["email"]!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editUser(user),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(index),
                          ),
                          user["status"] == "Active"
                              ? IconButton(
                                  icon: Icon(Icons.remove_circle, color: Colors.orange),
                                  onPressed: () => _deactivateUser(index),
                                )
                              : IconButton(
                                  icon: Icon(Icons.check_circle, color: Colors.green),
                                  onPressed: () => _activateUser(index),
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _addUser,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}