import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool isDarkMode = true;
  bool isBiometricAuth = false;
  bool isNotificationsEnabled = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isBiometricAuth = prefs.getBool('biometricAuth') ?? false;
      isDarkMode = prefs.getBool('darkMode') ?? true;
      isNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('biometricAuth', isBiometricAuth);
    prefs.setBool('darkMode', isDarkMode);
    prefs.setBool('notificationsEnabled', isNotificationsEnabled);
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate using biometrics',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        setState(() {
          isBiometricAuth = true;
        });
        _savePreferences();
      } else {
        setState(() {
          isBiometricAuth = false;
        });
      }
    } catch (e) {
      print('Biometric authentication error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildStatisticsSection(),
              const Divider(thickness: 1),
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 120,
            backgroundImage: AssetImage('assets/images/profile.jpeg'),
          ),
          const SizedBox(height: 12),
          Text(
            'Abhisek Thapa',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          Text(
            'Senior Waiter',
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    List<Map<String, String>> statistics = [
      {'label': 'Tables Served', 'value': '1066'},
      {'label': 'Joined Date', 'value': '2022/06/06'},
      {'label': 'Experience', 'value': '2 Years'},
      {'label': 'Employment', 'value': 'Full-time'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ...statistics.map(
              (stat) => _buildStatisticRow(stat['label']!, stat['value']!)),
        ],
      ),
    );
  }

  Widget _buildStatisticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16, color: isDarkMode ? Colors.white : Colors.black),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          _buildSwitchTile(
            title: 'Dark Mode',
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
              _savePreferences();
            },
          ),
          _buildSwitchTile(
            title: 'Biometric Authentication',
            value: isBiometricAuth,
            onChanged: (value) {
              if (value) {
                _authenticate();
              } else {
                setState(() {
                  isBiometricAuth = false;
                });
                _savePreferences();
              }
            },
          ),
          _buildSwitchTile(
            title: 'Enable Notifications',
            value: isNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                isNotificationsEnabled = value;
              });
              _savePreferences();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
