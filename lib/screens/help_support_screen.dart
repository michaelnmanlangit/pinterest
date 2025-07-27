import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

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
          'Help & Support',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick Help
          _buildSectionHeader('Quick Help'),
          _buildHelpTile(
            icon: Icons.help_outline,
            title: 'Frequently Asked Questions',
            subtitle: 'Find answers to common questions',
            onTap: () => _showFAQDialog(context),
          ),
          _buildHelpTile(
            icon: Icons.smart_toy,
            title: 'Chat with Support Bot',
            subtitle: 'Get instant help from our AI assistant',
            onTap: () => _showChatBotDialog(context),
          ),
          _buildHelpTile(
            icon: Icons.video_library,
            title: 'Video Tutorials',
            subtitle: 'Learn how to use Pinterest features',
            onTap: () => _showVideoTutorialsDialog(context),
          ),

          const SizedBox(height: 24),

          // Contact Support
          _buildSectionHeader('Contact Support'),
          _buildHelpTile(
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'Send us a detailed message',
            onTap: () => _openEmailSupport(),
          ),
          _buildHelpTile(
            icon: Icons.chat_outlined,
            title: 'Live Chat',
            subtitle: 'Chat with a support agent',
            onTap: () => _showLiveChatDialog(context),
          ),
          _buildHelpTile(
            icon: Icons.phone_outlined,
            title: 'Phone Support',
            subtitle: 'Call our support team',
            onTap: () => _showPhoneSupportDialog(context),
          ),

          const SizedBox(height: 24),

          // Community & Resources
          _buildSectionHeader('Community & Resources'),
          _buildHelpTile(
            icon: Icons.forum_outlined,
            title: 'Community Forum',
            subtitle: 'Connect with other Pinterest users',
            onTap: () => _openCommunityForum(),
          ),
          _buildHelpTile(
            icon: Icons.school_outlined,
            title: 'Pinterest Academy',
            subtitle: 'Learn Pinterest best practices',
            onTap: () => _openPinterestAcademy(),
          ),
          _buildHelpTile(
            icon: Icons.article_outlined,
            title: 'Help Center',
            subtitle: 'Browse our complete help documentation',
            onTap: () => _openHelpCenter(),
          ),

          const SizedBox(height: 24),

          // Report Issues
          _buildSectionHeader('Report Issues'),
          _buildHelpTile(
            icon: Icons.bug_report_outlined,
            title: 'Report a Bug',
            subtitle: 'Let us know about technical issues',
            onTap: () => _showBugReportDialog(context),
          ),
          _buildHelpTile(
            icon: Icons.flag_outlined,
            title: 'Report Content',
            subtitle: 'Report inappropriate content or spam',
            onTap: () => _showContentReportDialog(context),
          ),
          _buildHelpTile(
            icon: Icons.security_outlined,
            title: 'Security Issue',
            subtitle: 'Report security vulnerabilities',
            onTap: () => _showSecurityReportDialog(context),
          ),

          const SizedBox(height: 24),

          // Account Issues
          _buildSectionHeader('Account Issues'),
          _buildHelpTile(
            icon: Icons.lock_reset,
            title: 'Reset Password',
            subtitle: 'Trouble signing in to your account',
            onTap: () => _showPasswordResetDialog(context),
          ),
          _buildHelpTile(
            icon: Icons.account_circle_outlined,
            title: 'Account Recovery',
            subtitle: 'Recover a disabled or hacked account',
            onTap: () => _showAccountRecoveryDialog(context),
          ),
          _buildHelpTile(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            subtitle: 'Permanently delete your Pinterest account',
            onTap: () => _showDeleteAccountDialog(context),
          ),

          const SizedBox(height: 24),

          // App Information
          _buildSectionHeader('App Information'),
          _buildInfoCard(),

          const SizedBox(height: 24),

          // Feedback
          _buildSectionHeader('Feedback'),
          _buildHelpTile(
            icon: Icons.rate_review_outlined,
            title: 'Rate Our App',
            subtitle: 'Leave a review in the app store',
            onTap: () => _rateApp(),
          ),
          _buildHelpTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Share your thoughts and suggestions',
            onTap: () => _showFeedbackDialog(context),
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

  Widget _buildHelpTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
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

  Widget _buildInfoCard() {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.red),
                SizedBox(width: 12),
                Text(
                  'App Information',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text('Version: 1.0.0'),
            SizedBox(height: 4),
            Text('Build: 2025.1.1'),
            SizedBox(height: 4),
            Text('Platform: Flutter'),
            SizedBox(height: 4),
            Text('Last Updated: January 2025'),
          ],
        ),
      ),
    );
  }

  void _showFAQDialog(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I create a new board?',
        'answer': 'Tap the + icon at the bottom of the screen and select "Create Board".'
      },
      {
        'question': 'How do I save a pin?',
        'answer': 'Tap on any pin and then tap the "Save" button to add it to one of your boards.'
      },
      {
        'question': 'Can I make my account private?',
        'answer': 'Yes, go to Settings > Privacy Settings and toggle "Private Account".'
      },
      {
        'question': 'How do I report inappropriate content?',
        'answer': 'Tap the three dots on any pin and select "Report Pin".'
      },
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Frequently Asked Questions'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              final faq = faqs[index];
              return ExpansionTile(
                title: Text(faq['question']!),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(faq['answer']!),
                  ),
                ],
              );
            },
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

  void _showChatBotDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Support Bot'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text('Hi! I\'m here to help you with any questions about Pinterest.'),
            SizedBox(height: 16),
            Text('What would you like to know?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening chat bot...')),
              );
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  void _showVideoTutorialsDialog(BuildContext context) {
    final tutorials = [
      'Getting Started with Pinterest',
      'Creating Your First Board',
      'Finding Great Pins',
      'Pinterest for Business',
      'Advanced Pinterest Tips',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Video Tutorials'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: tutorials.map((tutorial) {
              return ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: Text(tutorial),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Playing: $tutorial')),
                  );
                },
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

  void _showLiveChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Live Chat'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text('Connect with a support agent for personalized help.'),
            SizedBox(height: 16),
            Text('Average wait time: 5 minutes'),
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
                const SnackBar(content: Text('Connecting to live chat...')),
              );
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  void _showPhoneSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phone Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text('Call us at:'),
            SizedBox(height: 8),
            Text(
              '1-800-PINTEREST',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Hours: Monday - Friday, 9 AM - 6 PM PST'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _makePhoneCall('1-800-746-8373');
            },
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Bug'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Brief description of the bug',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Please include steps to reproduce the issue and any error messages you see.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
                const SnackBar(content: Text('Bug report submitted')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showContentReportDialog(BuildContext context) {
    final reportReasons = [
      'Spam',
      'Inappropriate content',
      'Copyright violation',
      'Harassment',
      'Misinformation',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Content'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('What type of content are you reporting?'),
              const SizedBox(height: 16),
              ...reportReasons.map((reason) {
                return ListTile(
                  title: Text(reason),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reported for: $reason')),
                    );
                  },
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSecurityReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Report'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.security, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text('Thank you for helping keep Pinterest secure.'),
            SizedBox(height: 16),
            Text('For security vulnerabilities, please email:'),
            SizedBox(height: 8),
            Text(
              'security@pinterest.com',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openEmail('security@pinterest.com');
            },
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }

  void _showPasswordResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We\'ll send you a link to reset your password.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
                const SnackBar(content: Text('Password reset email sent')),
              );
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  void _showAccountRecoveryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Recovery'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('If your account has been hacked or disabled, we can help you recover it.'),
            SizedBox(height: 16),
            Text('Please provide as much information as possible about your account.'),
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
                const SnackBar(content: Text('Recovery request submitted')),
              );
            },
            child: const Text('Start Recovery'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'This will permanently delete your account and all your pins and boards.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('This action cannot be undone.'),
          ],
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
                const SnackBar(content: Text('Account deletion process started')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Your feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            Text(
              'Tell us what you love about Pinterest or how we can improve.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
                const SnackBar(content: Text('Feedback sent. Thank you!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _openEmailSupport() {
    _openEmail('support@pinterest.com');
  }

  void _openEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Pinterest Support Request',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _openCommunityForum() async {
    const url = 'https://help.pinterest.com/community';
    final Uri uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openPinterestAcademy() async {
    const url = 'https://business.pinterest.com/academy';
    final Uri uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openHelpCenter() async {
    const url = 'https://help.pinterest.com';
    final Uri uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _rateApp() {
    // This would typically open the app store
    // Note: context is not available in static context, so we'll just show a message
  }
}
