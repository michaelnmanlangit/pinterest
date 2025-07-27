import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pin.dart';
import '../models/user.dart';
import '../models/board.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Pin> _pins = [];
  List<User> _users = [];
  List<Board> _boards = [];
  final List<String> _savedPins = [];
  final List<String> _likedPins = [];
  final List<String> _hiddenPins = [];
  final List<String> _followedUsers = [];

  List<Pin> get pins => List.unmodifiable(_pins.where((pin) => !_hiddenPins.contains(pin.id)).toList());
  List<User> get users => List.unmodifiable(_users);
  List<Board> get boards => List.unmodifiable(_boards);
  List<String> get savedPins => List.unmodifiable(_savedPins);
  List<String> get likedPins => List.unmodifiable(_likedPins);

  Future<void> loadData() async {
    await Future.wait([
      _loadPins(),
      _loadUsers(),
      _loadBoards(),
      _loadUserData(), // Load saved data from SharedPreferences
    ]);
  }

  Future<void> _loadPins() async {
    try {
      final String response = await rootBundle.loadString('assets/data/pins.json');
      final List<dynamic> data = json.decode(response);
      _pins = data.map((json) => Pin.fromJson(json)).toList();
    } catch (e) {
      print('Error loading pins: $e');
    }
  }

  Future<void> _loadUsers() async {
    try {
      final String response = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> data = json.decode(response);
      _users = data.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  Future<void> _loadBoards() async {
    try {
      final String response = await rootBundle.loadString('assets/data/boards.json');
      final List<dynamic> data = json.decode(response);
      _boards = data.map((json) => Board.fromJson(json)).toList();
    } catch (e) {
      print('Error loading boards: $e');
    }
  }

  List<Pin> searchPins(String query) {
    if (query.isEmpty) return _pins;
    
    final lowerQuery = query.toLowerCase();
    return _pins.where((pin) =>
        pin.title.toLowerCase().contains(lowerQuery) ||
        pin.description.toLowerCase().contains(lowerQuery) ||
        pin.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
        pin.category.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<Pin> getPinsByCategory(String category) {
    return _pins.where((pin) => pin.category == category).toList();
  }

  Pin? getPinById(String id) {
    try {
      return _pins.firstWhere((pin) => pin.id == id);
    } catch (e) {
      return null;
    }
  }

  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  Board? getBoardById(String id) {
    try {
      return _boards.firstWhere((board) => board.id == id);
    } catch (e) {
      return null;
    }
  }

  void toggleSavePin(String pinId) {
    if (_savedPins.contains(pinId)) {
      _savedPins.remove(pinId);
    } else {
      _savedPins.add(pinId);
    }
    _saveUserData(); // Persist changes
  }

  void toggleLikePin(String pinId) {
    if (_likedPins.contains(pinId)) {
      _likedPins.remove(pinId);
    } else {
      _likedPins.add(pinId);
    }
    _saveUserData(); // Persist changes
  }

  bool isPinSaved(String pinId) => _savedPins.contains(pinId);
  bool isPinLiked(String pinId) => _likedPins.contains(pinId);

  List<Pin> getSavedPins() {
    return _pins.where((pin) => _savedPins.contains(pin.id)).toList();
  }

  List<Pin> getCreatedPins() {
    return _pins.where((pin) => pin.authorName == 'You').toList();
  }

  List<String> getCategories() {
    return _pins.map((pin) => pin.category).toSet().toList();
  }

  List<Pin> getRelatedPins(Pin currentPin, {int limit = 10}) {
    return _pins
        .where((pin) => 
            pin.id != currentPin.id && 
            !_hiddenPins.contains(pin.id) &&
            (pin.category == currentPin.category ||
             pin.tags.any((tag) => currentPin.tags.contains(tag))))
        .take(limit)
        .toList();
  }

  void hidePin(String pinId) {
    if (!_hiddenPins.contains(pinId)) {
      _hiddenPins.add(pinId);
      _saveUserData(); // Persist changes
    }
  }

  void unhidePin(String pinId) {
    _hiddenPins.remove(pinId);
  }

  List<Pin> getAllPins() {
    return List.unmodifiable(_pins);
  }

  void toggleFollowUser(String userId) {
    if (_followedUsers.contains(userId)) {
      _followedUsers.remove(userId);
    } else {
      _followedUsers.add(userId);
    }
    _saveUserData(); // Persist changes
  }

  bool isUserFollowed(String userId) => _followedUsers.contains(userId);

  List<String> getFollowedUsers() => List.unmodifiable(_followedUsers);

  // JSON Persistence Methods
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load saved pins
      final savedPinsJson = prefs.getString('saved_pins');
      if (savedPinsJson != null) {
        final List<dynamic> savedList = json.decode(savedPinsJson);
        _savedPins.clear();
        _savedPins.addAll(savedList.cast<String>());
      }
      
      // Load liked pins
      final likedPinsJson = prefs.getString('liked_pins');
      if (likedPinsJson != null) {
        final List<dynamic> likedList = json.decode(likedPinsJson);
        _likedPins.clear();
        _likedPins.addAll(likedList.cast<String>());
      }
      
      // Load hidden pins
      final hiddenPinsJson = prefs.getString('hidden_pins');
      if (hiddenPinsJson != null) {
        final List<dynamic> hiddenList = json.decode(hiddenPinsJson);
        _hiddenPins.clear();
        _hiddenPins.addAll(hiddenList.cast<String>());
      }
      
      // Load followed users
      final followedUsersJson = prefs.getString('followed_users');
      if (followedUsersJson != null) {
        final List<dynamic> followedList = json.decode(followedUsersJson);
        _followedUsers.clear();
        _followedUsers.addAll(followedList.cast<String>());
      }
      
      // Load user created pins
      final userPinsJson = prefs.getString('user_pins');
      if (userPinsJson != null) {
        final List<dynamic> userPinsList = json.decode(userPinsJson);
        final userPins = userPinsList.map((json) => Pin.fromJson(json)).toList();
        _pins.addAll(userPins);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save user preferences
      await prefs.setString('saved_pins', json.encode(_savedPins));
      await prefs.setString('liked_pins', json.encode(_likedPins));
      await prefs.setString('hidden_pins', json.encode(_hiddenPins));
      await prefs.setString('followed_users', json.encode(_followedUsers));
      
      // Save user created pins
      final userCreatedPins = _pins.where((pin) => pin.authorName == 'You').toList();
      final userPinsJson = userCreatedPins.map((pin) => pin.toJson()).toList();
      await prefs.setString('user_pins', json.encode(userPinsJson));
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Create Post Functionality
  Future<Pin> createPost({
    required String title,
    required String description,
    required String imageUrl,
    required List<String> tags,
    required String category,
    String? boardId,
  }) async {
    final newPin = Pin(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      imageUrl: imageUrl,
      authorName: 'You',
      authorAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b48b?w=100&h=100&fit=crop&crop=face',
      likes: 0,
      saves: 0,
      comments: 0,
      tags: tags,
      category: category,
      createdAt: DateTime.now(),
    );
    
    _pins.insert(0, newPin); // Add to beginning of list
    await _saveUserData(); // Persist to storage
    return newPin;
  }

  // Get sample image URLs for post creation
  List<String> getSampleImageUrls() {
    return [
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=600&fit=crop',
      'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&h=600&fit=crop',
      'https://images.unsplash.com/photo-1506197603052-3cc9c3a201bd?w=400&h=600&fit=crop',
      'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400&h=600&fit=crop',
      'https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=400&h=600&fit=crop',
      'https://images.unsplash.com/photo-1448375240586-882707db888b?w=400&h=600&fit=crop',
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=800&fit=crop',
      'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400&h=500&fit=crop',
      'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=400&h=700&fit=crop',
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=900&fit=crop',
      'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&h=600&fit=crop',
      'https://images.unsplash.com/photo-1500622944204-b135684e99fd?w=400&h=800&fit=crop',
      'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400&h=500&fit=crop',
      'https://images.unsplash.com/photo-1502780402662-acc01917f4eb?w=400&h=700&fit=crop',
      'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=400&h=600&fit=crop',
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=650&fit=crop',
      'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=550&fit=crop',
      'https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=400&h=750&fit=crop',
      'https://images.unsplash.com/photo-1516205651411-aef33a44f7c2?w=400&h=600&fit=crop',
      'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?w=400&h=800&fit=crop',
    ];
  }

  // Get categories for post creation
  List<String> getPostCategories() {
    return [
      'Architecture',
      'Art',
      'Beauty',
      'Design',
      'DIY',
      'Fashion',
      'Food',
      'Gardening',
      'Health',
      'Home Decor',
      'Illustration',
      'Nature',
      'Photography',
      'Technology',
      'Travel',
      'Wedding',
    ];
  }
}
