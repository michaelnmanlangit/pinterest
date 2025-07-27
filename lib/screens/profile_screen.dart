import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../providers/pinterest_provider.dart';
import '../services/auth_service.dart';
import '../widgets/pin_card.dart';
import '../utils/responsive_helper.dart';
import 'account_settings_screen.dart';
import 'notification_settings_screen.dart';
import 'privacy_settings_screen.dart';
import 'help_support_screen.dart';
import 'login_screen.dart';
import 'create_post_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer2<PinterestProvider, AuthService>(
        builder: (context, provider, authService, child) {
          final savedPins = provider.getSavedPins();
          final createdPins = provider.getCreatedPins();
          final currentUser = authService.currentUser;
          
          return CustomScrollView(
            slivers: [
              // Profile Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Profile Picture and Settings
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 40),
                          GestureDetector(
                            onTap: () {
                              _showChangeProfilePictureDialog(context);
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                currentUser?.avatar ?? 'https://images.unsplash.com/photo-1494790108755-2616b612b48b?w=200&h=200&fit=crop&crop=face',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                              _showSettingsBottomSheet(context, authService);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Profile Name and Stats
                      GestureDetector(
                        onTap: () {
                          _showEditProfileDialog(context, authService);
                        },
                        child: Text(
                          currentUser?.name ?? 'Your Profile',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          _showEditProfileDialog(context, authService);
                        },
                        child: Text(
                          currentUser?.username ?? '@yourhandle',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      if (currentUser?.bio != null && currentUser!.bio.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            _showEditProfileDialog(context, authService);
                          },
                          child: Text(
                            currentUser.bio,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      
                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn('Following', currentUser?.following.toString() ?? '234', () {
                            _showFollowingList(context);
                          }),
                          _buildStatColumn('Followers', _formatNumber(currentUser?.followers ?? 1200), () {
                            _showFollowersList(context);
                          }),
                          _buildStatColumn('Pins', savedPins.length.toString(), () {
                            _showAllPinsView(context);
                          }),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showEditProfileDialog(context, authService);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text('Edit profile'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              _showShareOptions(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Icon(Icons.share),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Tab Bar
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.all(3),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Saved'),
                      Tab(text: 'Created'),
                    ],
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              
              // Tab Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Saved Pins Tab
                    _buildPinsGrid(savedPins),
                    
                    // Created Pins Tab - Show user created pins
                    _buildPinsGrid(createdPins, isCreateTab: true),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Widget _buildStatColumn(String label, String count, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinsGrid(List pins, {bool isCreateTab = false}) {
    if (pins.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCreateTab ? Icons.add_circle_outline : Icons.bookmark_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nothing to show...yet!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isCreateTab ? 'Pins you create will live here' : 'Pins you save will live here',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            if (isCreateTab) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreatePostScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Create Pin'),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getHorizontalPadding(context)),
      child: MasonryGridView.count(
        crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
        mainAxisSpacing: ResponsiveHelper.getGridSpacing(context),
        crossAxisSpacing: ResponsiveHelper.getGridSpacing(context),
        itemCount: pins.length,
        itemBuilder: (context, index) {
          final pin = pins[index];
          return PinCard(pin: pin);
        },
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context, AuthService authService) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacySettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log out', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log out'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Log out'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  try {
                    await authService.logout();
                    if (context.mounted) {
                      // Navigate to login by replacing the entire app
                      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout failed: $e')),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AuthService authService) {
    final nameController = TextEditingController(text: authService.currentUser?.name ?? '');
    final usernameController = TextEditingController(text: authService.currentUser?.username ?? '');
    final bioController = TextEditingController(text: authService.currentUser?.bio ?? '');
    final websiteController = TextEditingController(text: authService.currentUser?.website ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authService.updateProfile(
                name: nameController.text,
                bio: bioController.text,
                website: websiteController.text,
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Share Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy profile link'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile link copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share via...'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening share options...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('Show QR code'),
              onTap: () {
                Navigator.pop(context);
                _showQRCodeDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeProfilePictureDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Change Profile Picture',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening camera...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening gallery...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Use Photo URL'),
              onTap: () {
                Navigator.pop(context);
                _showPhotoUrlDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile picture removed')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoUrlDialog(BuildContext context) {
    final urlController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Picture URL'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            labelText: 'Enter image URL',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (urlController.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile picture updated')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showFollowingList(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Following'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: 5, // Sample data
            itemBuilder: (context, index) {
              final users = [
                {'name': 'Sarah Johnson', 'username': '@sarah_j', 'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b48b?w=100&h=100&fit=crop&crop=face'},
                {'name': 'Michael Chen', 'username': '@mike_chen', 'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face'},
                {'name': 'Emma Wilson', 'username': '@emma_w', 'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face'},
                {'name': 'Alex Thompson', 'username': '@alex_t', 'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face'},
                {'name': 'Lisa Garcia', 'username': '@lisa_g', 'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop&crop=face'},
              ];
              
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['avatar'] as String),
                ),
                title: Text(user['name'] as String),
                subtitle: Text(user['username'] as String),
                trailing: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Unfollowed ${user['name']}')),
                    );
                  },
                  child: const Text('Following'),
                ),
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

  void _showFollowersList(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Followers'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: 8, // Sample data
            itemBuilder: (context, index) {
              final followers = [
                {'name': 'John Smith', 'username': '@john_s', 'avatar': 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&h=100&fit=crop&crop=face', 'following': false},
                {'name': 'Maria Rodriguez', 'username': '@maria_r', 'avatar': 'https://images.unsplash.com/photo-1551836022-deb4988cc6c0?w=100&h=100&fit=crop&crop=face', 'following': true},
                {'name': 'David Kim', 'username': '@david_k', 'avatar': 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=100&h=100&fit=crop&crop=face', 'following': false},
                {'name': 'Sophie Brown', 'username': '@sophie_b', 'avatar': 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=100&h=100&fit=crop&crop=face', 'following': true},
                {'name': 'James Wilson', 'username': '@james_w', 'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=face', 'following': false},
                {'name': 'Anna Lee', 'username': '@anna_l', 'avatar': 'https://images.unsplash.com/photo-1440133197387-5a6020d5ace2?w=100&h=100&fit=crop&crop=face', 'following': true},
                {'name': 'Ryan Taylor', 'username': '@ryan_t', 'avatar': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=100&h=100&fit=crop&crop=face', 'following': false},
                {'name': 'Jessica Miller', 'username': '@jessica_m', 'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop&crop=face', 'following': true},
              ];
              
              final follower = followers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(follower['avatar'] as String),
                ),
                title: Text(follower['name'] as String),
                subtitle: Text(follower['username'] as String),
                trailing: follower['following'] as bool
                    ? OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Unfollowed ${follower['name']}')),
                          );
                        },
                        child: const Text('Following'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Following ${follower['name']}')),
                          );
                        },
                        child: const Text('Follow'),
                      ),
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

  void _showAllPinsView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('All Pins'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Consumer<PinterestProvider>(
            builder: (context, provider, child) {
              final savedPins = provider.getSavedPins();
              return _buildPinsGrid(savedPins);
            },
          ),
        ),
      ),
    );
  }

  void _showQRCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code'),
        content: SizedBox(
          width: 200,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code, size: 80, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('QR Code'),
                  Text('Feature coming soon!', 
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
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
                const SnackBar(content: Text('QR code saved to gallery')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
