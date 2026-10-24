import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/repositories/sitter_repository_interface.dart';
import '../models/models.dart';

class SitterRepository implements SitterRepositoryInterface {
  static const String _assetPath = 'assets/data/sitters.json';

  List<SitterListing>? _cachedSitters;

  /// Bakıcı verilerini assets/data/sitters.json dosyasından yükler.
  @override
  Future<List<SitterListing>> getSitters({bool forceRefresh = false}) async {
    if (_cachedSitters != null && !forceRefresh) {
      return _cachedSitters!;
    }

    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

      _cachedSitters = jsonList
          .map((item) => SitterListing.fromJson(item as Map<String, dynamic>))
          .toList();

      return _cachedSitters!;
    } catch (e) {
      // Yükleme başarısız olursa boş liste döndürülür.
      return [];
    }
  }

  /// Bakıcıları kategori ve arama kelimesine göre filtreler.
  @override
  Future<List<SitterListing>> searchSitters({
    String category = 'Tümü',
    String query = '',
  }) async {
    final all = await getSitters();
    return all.where((s) {
      final matchesCategory = category == 'Tümü' || s.category == category;
      final cleanQuery = query.trim().toLowerCase();
      final matchesSearch =
          cleanQuery.isEmpty ||
          s.name.toLowerCase().contains(cleanQuery) ||
          s.facilityTitle.toLowerCase().contains(cleanQuery) ||
          s.location.toLowerCase().contains(cleanQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  /// ID bilgisine göre ilgili bakıcıyı bulur.
  @override
  Future<SitterListing?> getSitterById(String id) async {
    final all = await getSitters();
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
