import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _pinLikes = true;
  bool _pinComments = true;
  bool _pinSaves = true;
  bool _followNotifications = true;
  bool _boardInvites = true;
  bool _trendingNotifications = false;
  bool _weeklyDigest = true;
  bool _marketingEmails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // General Notifications
          _buildSectionHeader('General'),
          _buildNotificationTile(
            title: 'Push Notifications',
            subtitle: 'Receive push notifications on your device',
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
          ),
          _buildNotificationTile(
            title: 'Email Notifications',
            subtitle: 'Receive notifications via email',
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
          ),

          const SizedBox(height: 24),

          // Activity Notifications
          _buildSectionHeader('Activity'),
          _buildNotificationTile(
            title: 'Pin Likes',
            subtitle: 'When someone likes your pins',
            value: _pinLikes,
            onChanged: (value) => setState(() => _pinLikes = value),
          ),
          _buildNotificationTile(
            title: 'Pin Comments',
            subtitle: 'When someone comments on your pins',
            value: _pinComments,
            onChanged: (value) => setState(() => _pinComments = value),
          ),
          _buildNotificationTile(
            title: 'Pin Saves',
            subtitle: 'When someone saves your pins',
            value: _pinSaves,
            onChanged: (value) => setState(() => _pinSaves = value),
          ),
          _buildNotificationTile(
            title: 'New Followers',
            subtitle: 'When someone follows you',
            value: _followNotifications,
            onChanged: (value) => setState(() => _followNotifications = value),
          ),
          _buildNotificationTile(
            title: 'Board Invites',
            subtitle: 'When someone invites you to collaborate on a board',
            value: _boardInvites,
            onChanged: (value) => setState(() => _boardInvites = value),
          ),

          const SizedBox(height: 24),

          // Discovery Notifications
          _buildSectionHeader('Discovery'),
          _buildNotificationTile(
            title: 'Trending Topics',
            subtitle: 'Get notified about trending pins and topics',
            value: _trendingNotifications,
            onChanged: (value) => setState(() => _trendingNotifications = value),
          ),
          _buildNotificationTile(
            title: 'Weekly Digest',
            subtitle: 'Weekly summary of your Pinterest activity',
            value: _weeklyDigest,
            onChanged: (value) => setState(() => _weeklyDigest = value),
          ),

          const SizedBox(height: 24),

          // Marketing
          _buildSectionHeader('Marketing'),
          _buildNotificationTile(
            title: 'Marketing Emails',
            subtitle: 'Receive emails about new features and tips',
            value: _marketingEmails,
            onChanged: (value) => setState(() => _marketingEmails = value),
          ),

          const SizedBox(height: 32),

          // Notification Schedule
          Card(
            elevation: 0,
            color: Colors.grey[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notification Schedule',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose when you want to receive notifications',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showScheduleDialog(context),
                          icon: const Icon(Icons.schedule),
                          label: const Text('Set Quiet Hours'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _disableAllNotifications(),
                  child: const Text('Disable All'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _saveSettings(),
                  child: const Text('Save Settings'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.red,
      ),
    );
  }

  void _showScheduleDialog(BuildContext context) {
    TimeOfDay? startTime = const TimeOfDay(hour: 22, minute: 0);
    TimeOfDay? endTime = const TimeOfDay(hour: 7, minute: 0);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Quiet Hours'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Set times when you don\'t want to receive notifications'),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('From: '),
                  TextButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: startTime!,
                      );
                      if (time != null) {
                        setDialogState(() => startTime = time);
                      }
                    },
                    child: Text(startTime!.format(context)),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('To: '),
                  TextButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: endTime!,
                      );
                      if (time != null) {
                        setDialogState(() => endTime = time);
                      }
                    },
                    child: Text(endTime!.format(context)),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Quiet hours set: ${startTime!.format(context)} - ${endTime!.format(context)}',
                    ),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _disableAllNotifications() {
    setState(() {
      _pushNotifications = false;
      _emailNotifications = false;
      _pinLikes = false;
      _pinComments = false;
      _pinSaves = false;
      _followNotifications = false;
      _boardInvites = false;
      _trendingNotifications = false;
      _weeklyDigest = false;
      _marketingEmails = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications disabled')),
    );
  }

  void _saveSettings() {
    // Here you would save the settings to preferences or backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification settings saved')),
    );
  }
}
