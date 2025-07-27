import 'dart:convert';
import 'package:flutter/services.dart';
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

  List<Pin> get pins => List.unmodifiable(_pins);
  List<User> get users => List.unmodifiable(_users);
  List<Board> get boards => List.unmodifiable(_boards);
  List<String> get savedPins => List.unmodifiable(_savedPins);
  List<String> get likedPins => List.unmodifiable(_likedPins);

  Future<void> loadData() async {
    await Future.wait([
      _loadPins(),
      _loadUsers(),
      _loadBoards(),
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
  }

  void toggleLikePin(String pinId) {
    if (_likedPins.contains(pinId)) {
      _likedPins.remove(pinId);
    } else {
      _likedPins.add(pinId);
    }
  }

  bool isPinSaved(String pinId) => _savedPins.contains(pinId);
  bool isPinLiked(String pinId) => _likedPins.contains(pinId);

  List<Pin> getSavedPins() {
    return _pins.where((pin) => _savedPins.contains(pin.id)).toList();
  }

  List<String> getCategories() {
    return _pins.map((pin) => pin.category).toSet().toList();
  }

  List<Pin> getRelatedPins(Pin currentPin, {int limit = 10}) {
    return _pins
        .where((pin) => 
            pin.id != currentPin.id && 
            (pin.category == currentPin.category ||
             pin.tags.any((tag) => currentPin.tags.contains(tag))))
        .take(limit)
        .toList();
  }
}
