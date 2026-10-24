import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Keşfet ekranı için gelişmiş filtreleme ve sıralama modalı.
class ExploreFilterModal extends StatefulWidget {
  final String currentCategory;
  final double currentMinRating;
  final double currentMaxPrice;
  final String currentSortBy;
  final Function({
    required String category,
    required double minRating,
    required double maxPrice,
    required String sortBy,
  })
  onApply;

  const ExploreFilterModal({
    super.key,
    required this.currentCategory,
    required this.currentMinRating,
    required this.currentMaxPrice,
    required this.currentSortBy,
    required this.onApply,
  });

  static void show(
    BuildContext context, {
    required String currentCategory,
    required double currentMinRating,
    required double currentMaxPrice,
    required String currentSortBy,
    required Function({
      required String category,
      required double minRating,
      required double maxPrice,
      required String sortBy,
    })
    onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ExploreFilterModal(
        currentCategory: currentCategory,
        currentMinRating: currentMinRating,
        currentMaxPrice: currentMaxPrice,
        currentSortBy: currentSortBy,
        onApply: onApply,
      ),
    );
  }

  @override
  State<ExploreFilterModal> createState() => _ExploreFilterModalState();
}

class _ExploreFilterModalState extends State<ExploreFilterModal> {
  late String _selectedCategory;
  late double _selectedMinRating;
  late double _selectedMaxPrice;
  late String _selectedSortBy;

  final List<String> _categories = [
    'Tümü',
    'Köpek Oteli',
    'Köpek Gezdirme',
    'Gündüz Bakımı',
    'Evde Bakım',
    'Veteriner & Bakım',
  ];

  final List<String> _sortOptions = [
    'Önerilen',
    'Puan (En Yüksek)',
    'Fiyat (Artan)',
    'Mesafe (En Yakın)',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.currentCategory;
    _selectedMinRating = widget.currentMinRating;
    _selectedMaxPrice = widget.currentMaxPrice;
    _selectedSortBy = widget.currentSortBy;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkSurface
        : AppColors.surfaceContainerLowest;
    final cardBg = isDark
        ? AppColors.darkSurfaceContainer
        : AppColors.surfaceContainerLow;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: AppColors.floatingShadow,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sürükleme Çubuğu
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkOutlineVariant
                    : AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            // Başlık Satırı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkPrimaryContainer
                              : AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.tune,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Filtreler ve Sıralama',
                        style: AppTypography.titleCard.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: isDark
                        ? AppColors.darkOnSurfaceVariant
                        : AppColors.onSurfaceVariant,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // Filtre Seçenekleri Gövdesi
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategori Seçimi
                    Text(
                      'Hizmet Kategorisi',
                      style: AppTypography.headlineSection.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: cardBg,
                          labelStyle: AppTypography.bodyMedium.copyWith(
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                      ? AppColors.darkOnSurface
                                      : AppColors.onSurface),
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          onSelected: (_) {
                            setState(() => _selectedCategory = cat);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Sıralama Ölçütü
                    Text(
                      'Sıralama',
                      style: AppTypography.headlineSection.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sortOptions.map((opt) {
                        final isSelected = _selectedSortBy == opt;
                        return ChoiceChip(
                          label: Text(opt),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: cardBg,
                          labelStyle: AppTypography.bodyMedium.copyWith(
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                      ? AppColors.darkOnSurface
                                      : AppColors.onSurface),
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          onSelected: (_) {
                            setState(() => _selectedSortBy = opt);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Minimum Puan
                    Text(
                      'Minimum Puan',
                      style: AppTypography.headlineSection.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildRatingChip('Tümü', 0.0, isDark, cardBg),
                        const SizedBox(width: 8),
                        _buildRatingChip('4.0+ ⭐', 4.0, isDark, cardBg),
                        const SizedBox(width: 8),
                        _buildRatingChip('4.5+ ⭐', 4.5, isDark, cardBg),
                        const SizedBox(width: 8),
                        _buildRatingChip('4.8+ ⭐', 4.8, isDark, cardBg),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Maksimum Fiyat Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Maksimum Fiyat',
                          style: AppTypography.headlineSection.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '₺${_selectedMaxPrice.toInt()} / birim',
                          style: AppTypography.titleCard.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: isDark
                            ? AppColors.darkOutlineVariant
                            : AppColors.outlineVariant,
                        thumbColor: AppColors.primary,
                        overlayColor: AppColors.primary.withValues(alpha: 0.15),
                      ),
                      child: Slider(
                        value: _selectedMaxPrice,
                        min: 100,
                        max: 2000,
                        divisions: 19,
                        onChanged: (val) {
                          setState(() => _selectedMaxPrice = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Alt Butonlar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = 'Tümü';
                          _selectedMinRating = 0.0;
                          _selectedMaxPrice = 2000.0;
                          _selectedSortBy = 'Önerilen';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Temizle',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply(
                          category: _selectedCategory,
                          minRating: _selectedMinRating,
                          maxPrice: _selectedMaxPrice,
                          sortBy: _selectedSortBy,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Filtreleri Uygula',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingChip(
    String label,
    double rating,
    bool isDark,
    Color cardBg,
  ) {
    final isSelected = (_selectedMinRating - rating).abs() < 0.05;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedMinRating = rating),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                        ? AppColors.darkOutlineVariant.withValues(alpha: 0.5)
                        : AppColors.outlineVariant.withValues(alpha: 0.5)),
            ),
          ),
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkOnSurface : AppColors.onSurface),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
