import 'package:clones_desktop/application/shared_preferences_factory.dart';
import 'package:clones_desktop/infrastructure/privacy.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'privacy.g.dart';

@riverpod
PrivacyRepositoryImpl privacyRepository(
  Ref ref,
) {
  final sharedPreferencesFactory = ref.watch(sharedPreferencesFactoryProvider);
  return PrivacyRepositoryImpl(sharedPreferencesFactory);
}

@riverpod
Future<bool> isPrivacyAccepted(Ref ref) async {
  final privacyRepository = ref.read(privacyRepositoryProvider);
  return privacyRepository.isPrivacyAccepted();
}

@riverpod
Future<void> acceptPrivacy(Ref ref) async {
  final privacyRepository = ref.read(privacyRepositoryProvider);
  await privacyRepository.setPrivacyAccepted(true);
  // Invalidate the cache to force a re-read
  ref.invalidate(isPrivacyAcceptedProvider);
}

@riverpod
Future<void> rejectPrivacy(Ref ref) async {
  final privacyRepository = ref.read(privacyRepositoryProvider);
  await privacyRepository.setPrivacyAccepted(false);
  // Invalidate the cache to force a re-read
  ref.invalidate(isPrivacyAcceptedProvider);
}
