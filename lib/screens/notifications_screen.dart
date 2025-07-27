import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<NotificationItem> _allNotifications = [
    NotificationItem(
      type: NotificationType.like,
      user: 'Sarah Johnson',
      userAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop&crop=face',
      message: 'liked your Pin',
      pinImage: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=400&fit=crop',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationItem(
      type: NotificationType.follow,
      user: 'Alex Chen',
      userAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
      message: 'started following you',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationItem(
      type: NotificationType.save,
      user: 'Emma Wilson',
      userAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b48b?w=200&h=200&fit=crop&crop=face',
      message: 'saved your Pin to Home Decor',
      pinImage: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=400&fit=crop',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    NotificationItem(
      type: NotificationType.comment,
      user: 'Michael Brown',
      userAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
      message: 'commented on your Pin: "Love this design!"',
      pinImage: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300&h=400&fit=crop',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationItem(
      type: NotificationType.boardInvite,
      user: 'Lisa Garcia',
      userAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=200&fit=crop&crop=face',
      message: 'invited you to collaborate on Kitchen Ideas',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        title: Text(
          'Notifications',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification settings')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.red,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Updates'),
            Tab(text: 'Messages'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(_allNotifications),
          _buildNotificationsList(_allNotifications.where((n) => 
            n.type == NotificationType.like || 
            n.type == NotificationType.save ||
            n.type == NotificationType.comment
          ).toList()),
          _buildNotificationsList(_allNotifications.where((n) => 
            n.type == NotificationType.follow || 
            n.type == NotificationType.boardInvite
          ).toList()),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationItem> notifications) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When you get notifications, they\'ll show up here',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationTile(notification);
      },
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        tileColor: Colors.grey[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(notification.userAvatar),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  size: 12,
                  color: _getNotificationColor(notification.type),
                ),
              ),
            ),
          ],
        ),
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.inter(color: Colors.black, fontSize: 14),
            children: [
              TextSpan(
                text: notification.user,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' ${notification.message}'),
            ],
          ),
        ),
        subtitle: Text(
          _formatTimestamp(notification.timestamp),
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: notification.pinImage != null
            ? Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(notification.pinImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : null,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped notification from ${notification.user}')),
          );
        },
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.save:
        return Icons.bookmark;
      case NotificationType.comment:
        return Icons.chat_bubble;
      case NotificationType.boardInvite:
        return Icons.group;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Colors.red;
      case NotificationType.follow:
        return Colors.blue;
      case NotificationType.save:
        return Colors.green;
      case NotificationType.comment:
        return Colors.orange;
      case NotificationType.boardInvite:
        return Colors.purple;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${difference.inDays ~/ 7}w';
    }
  }
}

enum NotificationType {
  like,
  follow,
  save,
  comment,
  boardInvite,
}

class NotificationItem {
  final NotificationType type;
  final String user;
  final String userAvatar;
  final String message;
  final String? pinImage;
  final DateTime timestamp;

  NotificationItem({
    required this.type,
    required this.user,
    required this.userAvatar,
    required this.message,
    this.pinImage,
    required this.timestamp,
  });
}
