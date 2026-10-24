import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_state.dart';
import '../../../core/utils/image_storage_service.dart';
import '../../../core/widgets/paw_header_actions.dart';
import '../../../data/models/models.dart';
import '../../discovery/widgets/call_modal.dart';
import '../cubit/pets_cubit.dart';
import '../cubit/pets_state.dart';
import '../widgets/health_card_modal.dart';

/// Köpek Profili & Sağlık Ekranı — Clean Architecture ve PetsCubit ile beslenir.
class DogProfileScreen extends StatelessWidget {
  final PetsCubit? cubit;

  const DogProfileScreen({super.key, this.cubit});

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(value: cubit!, child: const _DogProfileView());
    }
    return BlocProvider(
      create: (_) => PetsCubit()..loadPetProfile(),
      child: const _DogProfileView(),
    );
  }
}

class _DogProfileView extends StatelessWidget {
  const _DogProfileView();

  Widget _buildPetImage(String path, {double size = 140}) {
    if (ImageStorageService.isAssetPath(path)) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (_, _, _) => Container(
          width: size,
          height: size,
          color: AppColors.surfaceContainerLow,
          child: const Icon(Icons.pets, color: AppColors.primary),
        ),
      );
    }
    if (kIsWeb) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (_, _, _) => Container(
          width: size,
          height: size,
          color: AppColors.surfaceContainerLow,
          child: const Icon(Icons.pets, color: AppColors.primary),
        ),
      );
    }
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      width: size,
      height: size,
      errorBuilder: (_, _, _) => Container(
        width: size,
        height: size,
        color: AppColors.surfaceContainerLow,
        child: const Icon(Icons.pets, color: AppColors.primary),
      ),
    );
  }

  Future<void> _handlePhotoPick(BuildContext context) async {
    final cubit = context.read<PetsCubit>();
    final appState = AppStateScope.of(context, listen: false);

    final savedPath = await cubit.pickAndSavePetPhoto();
    if (savedPath != null) {
      appState.updateDogPhoto(savedPath);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profil fotoğrafı başarıyla güncellendi ve kaydedildi! 🐾',
            ),
            backgroundColor: AppColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return BlocBuilder<PetsCubit, PetsState>(
      builder: (context, state) {
        final dog = state.dog ?? appState.currentDog;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Üst Başlık ve Sağ İkonlar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Köpek Profili & Sağlık',
                          style: AppTypography.headlineScreen,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.qr_code,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${dog.name} Mikroçip Dijital Kimlik Kodu: ${dog.microchip}',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.surfaceContainerLowest,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                  color: AppColors.outlineVariant.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Standart Profil ve Bildirim Başlık Aksiyonları
                          const PawHeaderActions(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Büyük Profil Fotoğrafı ve Fotoğraf Seçim Butonu
                  Center(
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () => _handlePhotoPick(context),
                          borderRadius: BorderRadius.circular(70),
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: AppColors.cardShadow,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: ClipOval(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  _buildPetImage(dog.photoPath, size: 140),
                                  if (state.isPhotoUpdating)
                                    Container(
                                      color: Colors.black.withValues(
                                        alpha: 0.4,
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () => _handlePhotoPick(context),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Text(dog.name, style: AppTypography.headlineHero),
                        const SizedBox(height: 2),
                        Text(
                          '${dog.breed} • Mikroçip: ${dog.microchip}',
                          style: AppTypography.bodyDefault,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Yaş, Ağırlık ve Cinsiyet İstatistik Kartları
                  Row(
                    children: [
                      _buildStatCard('Yaş', '${dog.ageYears} Yaş'),
                      const SizedBox(width: 10),
                      _buildStatCard('Ağırlık', '${dog.weightKg} kg'),
                      const SizedBox(width: 10),
                      _buildStatCard('Cinsiyet', dog.gender),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Profil Eylem Butonları
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showEditProfileDialog(context, dog);
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            'Profili Düzenle',
                            style: AppTypography.bodyMedium,
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Yeni köpek ekleme sihirbazı başlatıldı.',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Yeni Köpek Ekle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Kritik Sağlık & Alerji Uyarısı Kartı
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2F2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.error,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kritik Sağlık & Alerji Uyarısı',
                                style: AppTypography.titleCard.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dog.allergyNote,
                                style: AppTypography.bodyDefault.copyWith(
                                  color: const Color(0xFF701A1A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Aşı Takvimi Başlığı ve Sağlık Özeti Butonu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Aşı Takvimi & Kayıtlar',
                          style: AppTypography.headlineSection,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => HealthCardModal.show(context),
                        icon: const Icon(
                          Icons.medical_information_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          'Özeti Gör',
                          style: AppTypography.labelTag.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Aşı Listesi (Durum Değiştirme Destekli)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dog.vaccinations.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final v = dog.vaccinations[index];
                      final isDone = v.status == VaccineStatus.completed;
                      return InkWell(
                        onTap: () {
                          context.read<PetsCubit>().toggleVaccinationStatus(
                            v.id,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${v.title} durumu güncellendi: ${!isDone ? "Tamamlandı" : "Yaklaşıyor"}',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.outlineVariant.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isDone ? Icons.check_circle : Icons.event,
                                color: isDone
                                    ? AppColors.success
                                    : AppColors.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      v.title,
                                      style: AppTypography.titleCard,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${v.dueDate} • ${v.vetName}',
                                      style: AppTypography.caption,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDone
                                      ? AppColors.successContainer
                                      : AppColors.secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isDone ? 'Tamamlandı' : 'Yaklaşıyor',
                                  style: AppTypography.labelTag.copyWith(
                                    color: isDone
                                        ? AppColors.success
                                        : AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Beslenme & Davranış Özellikleri
                  Text(
                    'Beslenme & Davranış Özellikleri',
                    style: AppTypography.headlineSection,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.restaurant,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Günlük Beslenme Planı',
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Günde 2 öğün 280g kuzu etli kuru mama (sabah 08:30 / akşam 19:00). Bol taze su.',
                          style: AppTypography.bodyDefault,
                        ),
                        const Divider(
                          height: 20,
                          color: AppColors.outlineVariant,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite_border,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Sosyal Davranış & Karakter',
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dog.behaviorNote,
                          style: AppTypography.bodyDefault,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sorumlu Veteriner Kliniği Kartı
                  Text(
                    'Sorumlu Veteriner Kliniği',
                    style: AppTypography.headlineSection,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppColors.cardShadow,
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_hospital,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dog.clinicName,
                                style: AppTypography.titleCard,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Dr. Selin Bulut • Başhekim',
                                style: AppTypography.caption,
                              ),
                              Text(
                                dog.clinicPhone,
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => CallModal.show(
                            context,
                            contactName: '${dog.clinicName} (Dr. Selin Bulut)',
                            roleSubtitle:
                                'Veteriner Kliniği Acil & Randevu Hattı',
                            phoneNumber: dog.clinicPhone,
                          ),
                          icon: const Icon(Icons.phone, size: 16),
                          label: const Text('Hemen Ara'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context, Dog dog) {
    final weightController = TextEditingController(
      text: dog.weightKg.toString(),
    );
    final allergyController = TextEditingController(text: dog.allergyNote);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          '${dog.name} Profilini Düzenle',
          style: AppTypography.titleCard,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Ağırlık (kg)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: allergyController,
              decoration: const InputDecoration(labelText: 'Alerji / Özel Not'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newWeight =
                  double.tryParse(weightController.text) ?? dog.weightKg;
              final updated = dog.copyWith(
                weightKg: newWeight,
                allergyNote: allergyController.text,
              );
              context.read<PetsCubit>().updateDogProfile(updated);
              AppStateScope.of(context, listen: false).updateDog(updated);
              Navigator.of(ctx).pop();
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Text(label, style: AppTypography.caption),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTypography.titleCard.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
