import 'package:flutter/material.dart';
import 'package:wepin_flutter_widget_sdk/wepin_flutter_widget_sdk_type.dart';

class UserDrawer extends StatelessWidget {
  final String userEmail;
  final WepinLifeCycle wepinStatus;
  final String selectedLanguage;
  final String? selectedMode;
  final List<Map<String, String>> sdkConfigs;
  final Map<String, String> currency;
  final Function(String?) onModeChanged;
  final Function(String?) onLanguageChanged;

  const UserDrawer({
    Key? key,
    required this.userEmail,
    required this.wepinStatus,
    required this.selectedLanguage,
    required this.selectedMode,
    required this.sdkConfigs,
    required this.currency,
    required this.onModeChanged,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[700],
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'User Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Email: $userEmail',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Status: $wepinStatus',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.blueAccent),
            title: const Text('Mode', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: DropdownButton<String>(
              value: selectedMode,
              onChanged: onModeChanged,
              underline: Container(),
              style: const TextStyle(color: Colors.blueAccent),
              items: sdkConfigs.map((config) {
                return DropdownMenuItem<String>(
                  value: config['name'],
                  child: Text(config['name']!),
                );
              }).toList(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.blueAccent),
            title: const Text('Language', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              onChanged: onLanguageChanged,
              underline: Container(),
              style: const TextStyle(color: Colors.blueAccent),
              items: ['ko', 'en', 'ja'].map((language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
            ),
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
