import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mad/providers/favourite_provider.dart';
import 'package:mad/models/Property_model.dart';
import 'package:mad/pages/home.dart';
import 'package:mad/widgets/navbar.dart'; // Adjust the path as necessary

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteProperties = favoritesProvider.favoriteProperties;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Properties"),
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: favoriteProperties.isEmpty
          ? const Center(child: Text("No favorite properties yet"))
          : ListView.builder(
              itemCount: favoriteProperties.length,
              itemBuilder: (context, index) {
                final property = favoriteProperties[index];
                return ListTile(
                  leading: Image.asset(property.image, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(property.name),
                  subtitle: Text(property.location),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(property);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 2, // Set the appropriate index
        onTabChange: (index) {
          // Handle tab change
        },
      ), // Add your custom NavBar widget here
    );
  }
}
