
import 'package:flutter/material.dart';
import 'package:route_88/core/settings/app_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final settings = AppSettings.instance;
  late final TextEditingController _serverController;
  String? _serverError;
  bool _savingServer = false;

  @override
  void initState() {
    super.initState();
    _serverController = TextEditingController(
      text: settings.serverUrl,
    );
  }

  @override
  void dispose() {
    _serverController.dispose();
    super.dispose();
  }

  Future<void> _saveServer() async {
    setState(() {
      _savingServer = true;
      _serverError = null;
    });

    try {
      await settings.setServerUrl(_serverController.text);
      _serverController.text = settings.serverUrl;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Server address saved on this device'),
        ),
      );
    } on FormatException catch (error) {
      if (mounted) {
        setState(() => _serverError = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _serverError = 'Unable to save server address');
      }
    } finally {
      if (mounted) {
        setState(() => _savingServer = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) => Scaffold(
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
            const Text('Map Preferences', style: _heading),
            const SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Search Radius'),
                    subtitle: Text(
                      '${settings.searchRadius.round()} miles',
                    ),
                  ),
                  Slider(
                    value: settings.searchRadius,
                    min: 10,
                    max: 100,
                    divisions: 9,
                    activeColor: const Color(0xFF123B66),
                    label: '${settings.searchRadius.round()} miles',
                    onChanged: (value) =>
                        settings.setSearchRadius(value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Traffic Preferences', style: _heading),
            const SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Show Incidents'),
                    value: settings.showIncidents,
                    activeThumbColor: const Color(0xFF123B66),
                    onChanged: (value) =>
                        settings.setShowIncidents(value),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Show Construction'),
                    value: settings.showConstruction,
                    activeThumbColor: const Color(0xFF123B66),
                    onChanged: (value) =>
                        settings.setShowConstruction(value),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Show Slowdowns'),
                    value: settings.showSlowdowns,
                    activeThumbColor: const Color(0xFF123B66),
                    onChanged: (value) =>
                        settings.setShowSlowdowns(value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Server Connection', style: _heading),
            const SizedBox(height: 16),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your Route-88 server URL'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _serverController,
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: 'Server URL',
                        hintText: 'https://server.example.com:8443',
                        border: const OutlineInputBorder(),
                        errorText: _serverError,
                      ),
                      onSubmitted: (_) => _saveServer(),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter the server address (or its /api/mobile URL). '
                      'This is saved only on this device.',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: _savingServer ? null : _saveServer,
                        child: const Text('Save Server'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('About', style: _heading),
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
      ),
    );
  }

  static const _heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xFF123B66),
  );
}
