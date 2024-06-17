import 'package:flutter/material.dart';

class SearchForMembersProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  void clearSearch() {
    searchController.clear();
    _searchQuery = '';
    notifyListeners(); // Notify listeners of the change
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
