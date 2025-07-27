import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({Key? key}) : super(key: key);

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _privateAccount = false;
  bool _hideFromSearch = false;
  bool _personalizedAds = true;
  bool _dataForAds = true;
  bool _socialRecommendations = true;
  bool _activitySharing = true;
  String _searchPrivacy = 'Everyone';
  String _messagePrivacy = 'Everyone';

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
          'Privacy Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Privacy
          _buildSectionHeader('Account Privacy'),
          _buildPrivacyTile(
            title: 'Private Account',
            subtitle: 'Only approved followers can see your pins and boards',
            value: _privateAccount,
            onChanged: (value) => setState(() => _privateAccount = value),
          ),
          _buildPrivacyTile(
            title: 'Hide from Search Engines',
            subtitle: 'Prevent search engines from showing your profile',
            value: _hideFromSearch,
            onChanged: (value) => setState(() => _hideFromSearch = value),
          ),

          const SizedBox(height: 24),

          // Communication Privacy
          _buildSectionHeader('Communication'),
          _buildDropdownTile(
            icon: Icons.search,
            title: 'Who can find you by search',
            value: _searchPrivacy,
            options: ['Everyone', 'Only friends', 'Nobody'],
            onChanged: (value) => setState(() => _searchPrivacy = value!),
          ),
          _buildDropdownTile(
            icon: Icons.message,
            title: 'Who can message you',
            value: _messagePrivacy,
            options: ['Everyone', 'Only people you follow', 'Nobody'],
            onChanged: (value) => setState(() => _messagePrivacy = value!),
          ),

          const SizedBox(height: 24),

          // Data Privacy
          _buildSectionHeader('Data & Advertising'),
          _buildPrivacyTile(
            title: 'Personalized Ads',
            subtitle: 'See ads based on your Pinterest activity',
            value: _personalizedAds,
            onChanged: (value) => setState(() => _personalizedAds = value),
          ),
          _buildPrivacyTile(
            title: 'Use Your Data for Ads',
            subtitle: 'Use your activity to improve ad targeting',
            value: _dataForAds,
            onChanged: (value) => setState(() => _dataForAds = value),
          ),
          _buildPrivacyTile(
            title: 'Social Recommendations',
            subtitle: 'Let Pinterest suggest you to others',
            value: _socialRecommendations,
            onChanged: (value) => setState(() => _socialRecommendations = value),
          ),
          _buildPrivacyTile(
            title: 'Activity Sharing',
            subtitle: 'Share your activity with partners for better recommendations',
            value: _activitySharing,
            onChanged: (value) => setState(() => _activitySharing = value),
          ),

          const SizedBox(height: 24),

          // Data Management
          _buildSectionHeader('Data Management'),
          _buildActionTile(
            icon: Icons.download,
            title: 'Download Your Data',
            subtitle: 'Get a copy of all your Pinterest data',
            onTap: () => _showDataDownloadDialog(context),
          ),
          _buildActionTile(
            icon: Icons.history,
            title: 'Clear Search History',
            subtitle: 'Remove all your search history',
            onTap: () => _showClearHistoryDialog(context),
          ),
          _buildActionTile(
            icon: Icons.block,
            title: 'Blocked Accounts',
            subtitle: 'Manage blocked users',
            onTap: () => _showBlockedAccountsScreen(context),
          ),

          const SizedBox(height: 24),

          // Third-party Apps
          _buildSectionHeader('Third-party Apps'),
          _buildActionTile(
            icon: Icons.apps,
            title: 'Connected Apps',
            subtitle: 'Manage apps connected to your account',
            onTap: () => _showConnectedAppsScreen(context),
          ),
          _buildActionTile(
            icon: Icons.api,
            title: 'Developer Apps',
            subtitle: 'Apps you\'ve created or authorized',
            onTap: () => _showDeveloperAppsScreen(context),
          ),

          const SizedBox(height: 32),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _resetToDefaults(),
                  child: const Text('Reset to Defaults'),
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

  Widget _buildPrivacyTile({
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

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showDataDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Your Data'),
        content: const Text(
          'We\'ll prepare a file with all your Pinterest data including pins, boards, and account information. This may take up to 48 hours.',
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
                const SnackBar(content: Text('Data download request submitted')),
              );
            },
            child: const Text('Request Download'),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Search History'),
        content: const Text(
          'Are you sure you want to clear all your search history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search history cleared')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showBlockedAccountsScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Blocked Accounts'),
        content: const SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You haven\'t blocked any accounts yet.'),
              SizedBox(height: 16),
              Text(
                'Blocked users won\'t be able to follow you, see your pins, or send you messages.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showConnectedAppsScreen(BuildContext context) {
    final connectedApps = [
      {'name': 'Instagram', 'connected': true},
      {'name': 'Facebook', 'connected': false},
      {'name': 'Twitter', 'connected': false},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connected Apps'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: connectedApps.map((app) {
              return ListTile(
                title: Text(app['name'] as String),
                trailing: app['connected'] as bool
                    ? TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${app['name']} disconnected')),
                          );
                        },
                        child: const Text('Disconnect'),
                      )
                    : TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${app['name']} connected')),
                          );
                        },
                        child: const Text('Connect'),
                      ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeveloperAppsScreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Developer Apps'),
        content: const SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You haven\'t authorized any developer apps yet.'),
              SizedBox(height: 16),
              Text(
                'Apps you authorize will appear here. You can revoke access at any time.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      _privateAccount = false;
      _hideFromSearch = false;
      _personalizedAds = true;
      _dataForAds = true;
      _socialRecommendations = true;
      _activitySharing = true;
      _searchPrivacy = 'Everyone';
      _messagePrivacy = 'Everyone';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings reset to defaults')),
    );
  }

  void _saveSettings() {
    // Here you would save the settings to preferences or backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings saved')),
    );
  }
}
