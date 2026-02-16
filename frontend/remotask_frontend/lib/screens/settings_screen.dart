import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_manager.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentRole = 'FREELANCER';
  bool _pushNotifications = true;
  bool _emailAlerts = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthManager>(context, listen: false);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ACCOUNT Section
            _buildSectionHeader('ACCOUNT'),
            SizedBox(height: 12),
            
            // Email
            _buildSettingCard(
              icon: Icons.email_outlined,
              iconColor: AppTheme.accentBlue,
              title: 'Email',
              subtitle: 'johngachara24@gmail.com',
            ),
            SizedBox(height: 12),
            
            // Current Role
            _buildSettingCard(
              icon: Icons.person_outline,
              iconColor: AppTheme.primaryPurple,
              title: 'Current Role',
              subtitle: 'You are logged in as a ${_currentRole.toLowerCase()}',
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _currentRole,
                  style: TextStyle(
                    color: AppTheme.accentBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            
            // Switch to Client button
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentRole = _currentRole == 'FREELANCER' ? 'CLIENT' : 'FREELANCER';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Switched to $_currentRole mode'),
                    backgroundColor: AppTheme.primaryGreen,
                  ),
                );
              },
              icon: Icon(Icons.swap_horiz),
              label: Text(
                _currentRole == 'FREELANCER' ? 'Switch to Client' : 'Switch to Freelancer',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentBlue,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 32),
            
            // PREFERENCES Section
            _buildSectionHeader('PREFERENCES'),
            SizedBox(height: 12),
            
            // Push Notifications
            _buildSettingCard(
              icon: Icons.notifications_outlined,
              iconColor: AppTheme.primaryPurple,
              title: 'Push Notifications',
              subtitle: 'Receive app notifications',
              trailing: Switch(
                value: _pushNotifications,
                onChanged: (value) => setState(() => _pushNotifications = value),
                activeColor: AppTheme.primaryPurple,
              ),
            ),
            SizedBox(height: 12),
            
            // Email Alerts
            _buildSettingCard(
              icon: Icons.mail_outline,
              iconColor: AppTheme.accentBlue,
              title: 'Email Alerts',
              subtitle: 'Get email notifications',
              trailing: Switch(
                value: _emailAlerts,
                onChanged: (value) => setState(() => _emailAlerts = value),
                activeColor: AppTheme.primaryPurple,
              ),
            ),
            SizedBox(height: 12),
            
            // Dark Mode
            _buildSettingCard(
              icon: Icons.dark_mode_outlined,
              iconColor: AppTheme.textSecondary,
              title: 'Dark Mode',
              subtitle: 'Toggle dark theme',
              trailing: Switch(
                value: _darkMode,
                onChanged: (value) => setState(() => _darkMode = value),
                activeColor: AppTheme.primaryPurple,
              ),
            ),
            SizedBox(height: 32),
            
            // SECURITY & PRIVACY Section
            _buildSectionHeader('SECURITY & PRIVACY'),
            SizedBox(height: 12),
            
            // Change Password
            _buildSettingCard(
              icon: Icons.lock_outline,
              iconColor: AppTheme.primaryGreen,
              title: 'Change Password',
              subtitle: 'Update your password',
              trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              onTap: () {
                // TODO: Navigate to change password screen
              },
            ),
            SizedBox(height: 12),
            
            // Privacy Policy
            _buildSettingCard(
              icon: Icons.privacy_tip_outlined,
              iconColor: AppTheme.accentBlue,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              onTap: () {
                // TODO: Navigate to privacy policy
              },
            ),
            SizedBox(height: 12),
            
            // Terms of Service
            _buildSettingCard(
              icon: Icons.description_outlined,
              iconColor: AppTheme.textSecondary,
              title: 'Terms of Service',
              subtitle: 'Read our terms',
              trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              onTap: () {
                // TODO: Navigate to terms of service
              },
            ),
            SizedBox(height: 32),
            
            // Logout button
            ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true) {
                  await auth.logout();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
            
            // App version
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
  
  Widget _buildSettingCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
