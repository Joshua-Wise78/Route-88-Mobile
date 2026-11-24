import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showIncidents = true;
  bool showConstruction = true;
  bool showSlowdowns = true;

  double searchRadius = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF123B66),
        foregroundColor: Colors.white,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Map Preferences',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF123B66),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  title: const Text('Search Radius'),
                  subtitle: Text(
                    '${searchRadius.round()} miles',
                  ),
                ),
                Slider(
                  value: searchRadius,
                  min: 10,
                  max: 100,
                  divisions: 9,
                  activeColor: const Color(0xFF123B66),
                  label: '${searchRadius.round()} miles',
                  onChanged: (value) {
                    setState(() {
                      searchRadius = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Traffic Preferences',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF123B66),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Show Incidents'),
                  value: showIncidents,
                  activeThumbColor: const Color(0xFF123B66),
                  onChanged: (value) {
                    setState(() {
                      showIncidents = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Show Construction'),
                  value: showConstruction,
                  activeThumbColor: const Color(0xFF123B66),
                  onChanged: (value) {
                    setState(() {
                      showConstruction = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Show Slowdowns'),
                  value: showSlowdowns,
                  activeThumbColor: const Color(0xFF123B66),
                  onChanged: (value) {
                    setState(() {
                      showSlowdowns = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF123B66),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Route-88'),
              subtitle: Text('Traffic and road event information'),
            ),
          ),
        ],
      ),
    );
  }
}
