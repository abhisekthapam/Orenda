import 'package:flutter/material.dart';
import 'package:orenda/views/theme_provider.dart';
import 'package:provider/provider.dart';

class WaiterDashboard extends StatelessWidget {
  const WaiterDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.isDarkMode ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildStatisticsSection(themeProvider),
              const Divider(thickness: 1),
              _buildSettingsSection(themeProvider, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
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
                  Colors.black.withOpacity(0.5),
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
    );
  }

  Widget _buildStatisticsSection(ThemeProvider themeProvider) {
    final TextStyle labelStyle =
        themeProvider.getTextStyle(fontSize: 16, isBold: false);
    final TextStyle valueStyle =
        themeProvider.getTextStyle(fontSize: 16, isBold: true);

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
              color: labelStyle.color,
            ),
          ),
          const SizedBox(height: 10),
          _buildStatisticRow('Tables Served', '1066', labelStyle, valueStyle),
          _buildStatisticRow(
              'Joined Date', '2022/06/06', labelStyle, valueStyle),
          _buildStatisticRow('Experience', '2 Years', labelStyle, valueStyle),
          _buildStatisticRow('Employment', 'Full-time', labelStyle, valueStyle),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
      ThemeProvider themeProvider, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          _buildToggleRow(
            'Dark Mode',
            themeProvider.isDarkMode,
            (newValue) {
              themeProvider.toggleTheme();
            },
            themeProvider.isDarkMode,
          ),
          _buildToggleRow(
            'Biometric Auth',
            true,
            (newValue) {},
            themeProvider.isDarkMode,
          ),
          _buildToggleRow(
            'Notifications',
            false,
            (newValue) {},
            themeProvider.isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticRow(
    String label,
    String value,
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle,
          ),
          Text(
            value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String label, bool currentValue,
      ValueChanged<bool> onChanged, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16, color: isDarkMode ? Colors.white : Colors.black),
          ),
          Switch(
            value: currentValue,
            onChanged: onChanged,
            activeColor: Colors.grey[600],
            activeTrackColor: Colors.grey[800],
            inactiveThumbColor: Colors.grey.withOpacity(0.7),
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
