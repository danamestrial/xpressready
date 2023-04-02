import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          user!.isAnonymous || user!.photoURL == null
              ? const Icon(
            Icons.account_circle,
            size: 80,
          )
              : Image.network(
            user!.photoURL as String,
            height: 80,
          ),
          const SizedBox(height: 10),
          Text(
            user!.displayName ?? user!.email!,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Email: ${user!.email}',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
