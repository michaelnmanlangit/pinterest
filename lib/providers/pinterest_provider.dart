import 'package:flutter/foundation.dart';
import '../models/pin.dart';
import '../models/user.dart';
import '../models/board.dart';
import '../services/data_service.dart';

class PinterestProvider extends ChangeNotifier {
  final DataService _dataService = DataService();
  
  List<Pin> _pins = [];
  List<Pin> _filteredPins = [];
  List<User> _users = [];
  List<Board> _boards = [];
  String _searchQuery = '';
  String _selectedCategory = '';
  bool _isLoading = false;

  List<Pin> get pins => _filteredPins.isEmpty && _searchQuery.isEmpty && _selectedCategory.isEmpty 
      ? _pins : _filteredPins;
  List<User> get users => _users;
  List<Board> get boards => _boards;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    await _dataService.loadData();
    _pins = _dataService.pins;
    _users = _dataService.users;
    _boards = _dataService.boards;
    
    _isLoading = false;
    notifyListeners();
  }

  void searchPins(String query) {
    _searchQuery = query;
    _selectedCategory = '';
    
    if (query.isEmpty) {
      _filteredPins = [];
    } else {
      _filteredPins = _dataService.searchPins(query);
    }
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _searchQuery = '';
    
    if (category.isEmpty) {
      _filteredPins = [];
    } else {
      _filteredPins = _dataService.getPinsByCategory(category);
    }
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = '';
    _filteredPins = [];
    notifyListeners();
  }

  void toggleSavePin(String pinId) {
    _dataService.toggleSavePin(pinId);
    notifyListeners();
  }

  void toggleLikePin(String pinId) {
    _dataService.toggleLikePin(pinId);
    notifyListeners();
  }

  bool isPinSaved(String pinId) => _dataService.isPinSaved(pinId);
  bool isPinLiked(String pinId) => _dataService.isPinLiked(pinId);

  List<Pin> getSavedPins() => _dataService.getSavedPins();
  List<String> getCategories() => _dataService.getCategories();
  
  Pin? getPinById(String id) => _dataService.getPinById(id);
  User? getUserById(String id) => _dataService.getUserById(id);
  Board? getBoardById(String id) => _dataService.getBoardById(id);
  
  List<Pin> getRelatedPins(Pin currentPin) => _dataService.getRelatedPins(currentPin);
}
