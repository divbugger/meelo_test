import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:meelo/models/figure_status.dart';
import 'package:meelo/l10n/app_localizations.dart';

class FigureStatusService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();
  
  List<FigureStatus> _figureStatuses = [];
  bool _isLoading = false;

  List<FigureStatus> get figureStatuses => List.unmodifiable(_figureStatuses);
  bool get isLoading => _isLoading;

  Future<void> loadFigureStatuses() async {
    if (_supabase.auth.currentUser == null) return;

    _setLoading(true);
    try {
      final response = await _supabase
          .from('figure_status')
          .select()
          .eq('user_id', _supabase.auth.currentUser!.id)
          .order('figure_type', ascending: true);

      _figureStatuses = (response as List)
          .map((json) => FigureStatus.fromJson(json))
          .toList();
      
      // Initialize default figures if none exist
      if (_figureStatuses.isEmpty) {
        await _initializeDefaultFigures();
      }
      
      notifyListeners();
    } catch (error) {
      debugPrint('Error loading figure statuses: $error');
      // If error, try to initialize defaults
      await _initializeDefaultFigures();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _initializeDefaultFigures() async {
    if (_supabase.auth.currentUser == null) return;

    try {
      final defaultFigures = [
        FigureType.lifeStory,
        FigureType.familyAndFriends,
        FigureType.music,
      ];

      final figureStatusList = <FigureStatus>[];
      
      for (final figureType in defaultFigures) {
        final figureStatus = FigureStatus(
          id: _uuid.v4(),
          userId: _supabase.auth.currentUser!.id,
          figureType: figureType,
          isConnected: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        figureStatusList.add(figureStatus);
      }

      // Insert all default figures
      final jsonList = figureStatusList.map((figure) => figure.toJson()).toList();
      await _supabase.from('figure_status').insert(jsonList);

      _figureStatuses = figureStatusList;
      notifyListeners();
    } catch (error) {
      debugPrint('Error initializing default figures: $error');
    }
  }

  Future<bool> toggleFigureConnection(FigureType figureType) async {
    if (_supabase.auth.currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Find the figure status
      final existingStatusList = _figureStatuses.where((status) => 
          status.figureType == figureType).toList();
      
      if (existingStatusList.isEmpty) {
        throw Exception('Figure not found');
      }

      final existingStatus = existingStatusList.first;
      final newConnectionStatus = !existingStatus.isConnected;
      
      // Update in database
      final response = await _supabase
          .from('figure_status')
          .update({
            'is_connected': newConnectionStatus,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', existingStatus.id)
          .select();

      if (response.isEmpty) {
        throw Exception('Failed to update figure connection status');
      }

      // Update local state
      final index = _figureStatuses.indexWhere((status) => status.id == existingStatus.id);
      if (index != -1) {
        _figureStatuses[index] = existingStatus.copyWith(
          isConnected: newConnectionStatus,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }

      return true;
    } catch (error) {
      debugPrint('Error toggling figure connection: $error');
      
      if (error is Exception) {
        rethrow;
      } else if (error.toString().contains('network')) {
        throw Exception('Network error. Please check your internet connection and try again.');
      } else {
        throw Exception('Failed to update connection status. Please try again.');
      }
    }
  }

  bool isFigureConnected(FigureType figureType) {
    final statusList = _figureStatuses.where((status) => 
        status.figureType == figureType).toList();
    return statusList.isNotEmpty ? statusList.first.isConnected : false;
  }

  FigureStatus? getFigureStatus(FigureType figureType) {
    final statusList = _figureStatuses.where((status) => 
        status.figureType == figureType).toList();
    return statusList.isNotEmpty ? statusList.first : null;
  }

  List<FigureStatus> getConnectedFigures() {
    return _figureStatuses.where((status) => status.isConnected).toList();
  }

  int getConnectedCount() {
    return getConnectedFigures().length;
  }

  String getFigureTypeDisplayName(FigureType type, AppLocalizations localizations) {
    switch (type) {
      case FigureType.lifeStory:
        return localizations.lifeStory;
      case FigureType.familyAndFriends:
        return localizations.familyAndFriends;
      case FigureType.music:
        return localizations.music;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}