import 'package:flutter/material.dart';

class WaiterDashboard extends StatefulWidget {
  const WaiterDashboard({super.key});

  @override
  _WaiterDashboardState createState() => _WaiterDashboardState();
}

class _WaiterDashboardState extends State<WaiterDashboard> {
  bool isDarkMode = false;
  bool isBiometricAuthEnabled = true;
  bool areNotificationsEnabled = false;

  final Color primaryColor = const Color(0xFF565657);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isDarkMode ? primaryColor.withOpacity(0.8) : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 400,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/waiter.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        Text(
                          'Abhisek Magar',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Senior Waiter',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildStatisticRow('Tables Served', '1066'),
                    buildStatisticRow('Joined Date', '2022/06/06'),
                    buildStatisticRow('Experience', '2 Years'),
                    buildStatisticRow('Employment', 'Full-time'),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 22.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildToggleRow(
                      'Dark Mode',
                      isDarkMode,
                      (newValue) => setState(() {
                        isDarkMode = newValue;
                      }),
                    ),
                    buildToggleRow(
                      'Biometric Auth',
                      isBiometricAuthEnabled,
                      (newValue) => setState(() {
                        isBiometricAuthEnabled = newValue;
                      }),
                    ),
                    buildToggleRow(
                      'Notifications',
                      areNotificationsEnabled,
                      (newValue) => setState(() {
                        areNotificationsEnabled = newValue;
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatisticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : primaryColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToggleRow(
      String label, bool currentValue, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : primaryColor,
            ),
          ),
          Switch(
            value: currentValue,
            onChanged: onChanged,
            activeColor: primaryColor,
            activeTrackColor: primaryColor.withOpacity(0.5),
            inactiveThumbColor: primaryColor.withOpacity(0.7),
            inactiveTrackColor: primaryColor.withOpacity(0.3),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
