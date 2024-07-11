import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Security'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async{
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                context.go('/login');
              } catch (e) {
                print('Error logging out: $e');
              }
            },
          ),
        ],
      ),
    );
  }
}
