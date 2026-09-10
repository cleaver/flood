import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Appearance'),
            trailing: Text('System'),
          ),
          ListTile(
            leading: Icon(Icons.open_in_browser_outlined),
            title: Text('Open original links'),
            trailing: Text('In app'),
          ),
          ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Downloaded articles'),
            trailing: Text('30 days'),
          ),
        ],
      ),
    );
  }
}
