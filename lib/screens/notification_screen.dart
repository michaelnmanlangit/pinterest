import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      type: NotificationType.like,
      title: 'Sarah liked your pin',
      subtitle: '"Beautiful sunset photography"',
      time: '2 min ago',
      imageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b48b?w=100&h=100&fit=crop&crop=face',
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      type: NotificationType.follow,
      title: 'Michael started following you',
      subtitle: 'Say hello!',
      time: '1 hour ago',
      imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      type: NotificationType.comment,
      title: 'Emma commented on your pin',
      subtitle: '"This is amazing! Where was this taken?"',
      time: '3 hours ago',
      imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face',
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      type: NotificationType.save,
      title: 'Alex saved your pin',
      subtitle: '"Modern kitchen design ideas"',
      time: '1 day ago',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      type: NotificationType.board,
      title: 'Lisa invited you to collaborate',
      subtitle: 'on "Dream Home Ideas" board',
      time: '2 days ago',
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop&crop=face',
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      type: NotificationType.trending,
      title: 'Your pin is trending!',
      subtitle: '"Cozy living room decor" has 500+ saves',
      time: '3 days ago',
      imageUrl: null,
      isRead: true,
    ),
  ];

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
          'Notifications',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'mark_all_read':
                  _markAllAsRead();
                  break;
                case 'settings':
                  _openNotificationSettings();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Text('Mark all as read'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Notification settings'),
              ),
            ],
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(notification);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'When people interact with your pins,\nyou\'ll see it here',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.removeWhere((n) => n.id == notification.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _notifications.insert(
                    _notifications.length,
                    notification,
                  );
                });
              },
            ),
          ),
        );
      },
      child: InkWell(
        onTap: () => _markAsRead(notification),
        child: Container(
          color: notification.isRead ? Colors.white : Colors.red.withOpacity(0.05),
          child: ListTile(
            leading: _buildNotificationIcon(notification),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.subtitle),
                const SizedBox(height: 4),
                Text(
                  notification.time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: _buildNotificationActions(notification),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationItem notification) {
    if (notification.imageUrl != null) {
      return Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(notification.imageUrl!),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type),
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getNotificationIconData(notification.type),
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundColor: _getNotificationColor(notification.type),
        child: Icon(
          _getNotificationIconData(notification.type),
          color: Colors.white,
        ),
      );
    }
  }

  Widget _buildNotificationActions(NotificationItem notification) {
    switch (notification.type) {
      case NotificationType.follow:
        return ElevatedButton(
          onPressed: () => _followBack(notification),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(80, 32),
          ),
          child: const Text('Follow', style: TextStyle(color: Colors.white)),
        );
      case NotificationType.board:
        return ElevatedButton(
          onPressed: () => _acceptInvitation(notification),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(80, 32),
          ),
          child: const Text('Accept', style: TextStyle(color: Colors.white)),
        );
      default:
        return const Icon(Icons.chevron_right, color: Colors.grey);
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Colors.red;
      case NotificationType.follow:
        return Colors.blue;
      case NotificationType.comment:
        return Colors.green;
      case NotificationType.save:
        return Colors.orange;
      case NotificationType.board:
        return Colors.purple;
      case NotificationType.trending:
        return Colors.amber;
    }
  }

  IconData _getNotificationIconData(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.follow:
        return Icons.person_add;
      case NotificationType.comment:
        return Icons.comment;
      case NotificationType.save:
        return Icons.bookmark;
      case NotificationType.board:
        return Icons.group;
      case NotificationType.trending:
        return Icons.trending_up;
    }
  }

  void _markAsRead(NotificationItem notification) {
    if (!notification.isRead) {
      setState(() {
        notification.isRead = true;
      });
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _followBack(NotificationItem notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Following user')),
    );
  }

  void _acceptInvitation(NotificationItem notification) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Board invitation accepted')),
    );
  }

  void _openNotificationSettings() {
    Navigator.pushNamed(context, '/notification-settings');
  }
}

enum NotificationType {
  like,
  follow,
  comment,
  save,
  board,
  trending,
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String subtitle;
  final String time;
  final String? imageUrl;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    this.imageUrl,
    this.isRead = false,
  });
}
