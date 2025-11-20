import 'package:flutter/material.dart';
import '../models/lead_model.dart';
import '../services/database_service.dart';

class LeadProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService.instance;
  
  List<Lead> _leads = [];
  List<Lead> _filteredLeads = [];
  String _currentFilter = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  List<Lead> get leads => _filteredLeads;
  String get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;

  // Load all leads
  Future<void> loadLeads() async {
    _isLoading = true;
    notifyListeners();

    try {
      _leads = await _dbService.getAllLeads();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading leads: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new lead
  Future<void> addLead(Lead lead) async {
    try {
      final newLead = await _dbService.createLead(lead);
      _leads.insert(0, newLead);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding lead: $e');
      rethrow;
    }
  }

  // Update existing lead
  Future<void> updateLead(Lead lead) async {
    try {
      await _dbService.updateLead(lead);
      final index = _leads.indexWhere((l) => l.id == lead.id);
      if (index != -1) {
        _leads[index] = lead.copyWith(updatedAt: DateTime.now());
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating lead: $e');
      rethrow;
    }
  }

  // Delete lead
  Future<void> deleteLead(int id) async {
    try {
      await _dbService.deleteLead(id);
      _leads.removeWhere((lead) => lead.id == id);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting lead: $e');
      rethrow;
    }
  }

  // Filter leads by status
  void filterLeads(String status) {
    _currentFilter = status;
    _applyFilters();
    notifyListeners();
  }

  // Search leads
  void searchLeads(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Apply filters and search
  void _applyFilters() {
    _filteredLeads = _leads.where((lead) {
      final matchesFilter = _currentFilter == 'All' || lead.status == _currentFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          lead.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }
}
