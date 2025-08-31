import 'package:clones_desktop/domain/models/factory/factory.dart';
import 'package:clones_desktop/domain/models/factory/factory_search_criteria.dart';
import 'package:clones_desktop/domain/models/factory/factory_search_result.dart';
import 'package:clones_desktop/domain/models/supported_token.dart';
import 'package:clones_desktop/infrastructure/factories.repository.dart';
import 'package:clones_desktop/utils/api_client.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'factory.g.dart';

@riverpod
FactoriesRepositoryImpl factoryRepository(
  Ref ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return FactoriesRepositoryImpl(apiClient);
}

@riverpod
Future<Map<String, dynamic>> createPool(
  Ref ref, {
  required String token,
  required String creator,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.createPool(token: token, creator: creator);
}

@riverpod
Future<Map<String, dynamic>> predictPoolAddress(
  Ref ref, {
  required String creator,
  required String token,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.predictPoolAddress(creator: creator, token: token);
}

@riverpod
Future<Map<String, dynamic>> estimateFactoryGas(
  Ref ref, {
  required String type,
  String? token,
  String? amount,
  String? creator,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.estimateGas(
    type: type,
    token: token,
    amount: amount,
    creator: creator,
  );
}

// TODO: remove this ?
@riverpod
Future<Map<String, dynamic>> getPoolInfo(
  Ref ref, {
  required String poolAddress,
  String? account,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.getPoolInfo(poolAddress: poolAddress, account: account);
}

@riverpod
Future<Map<String, dynamic>> fundPool(
  Ref ref, {
  required String poolAddress,
  required double amount,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.fundPool(poolAddress: poolAddress, amount: amount);
}

@riverpod
Future<Map<String, dynamic>> generateClaimSignature(
  Ref ref, {
  required String vaultAddress,
  required String account,
  required double cumulativeAmount,
  int? deadline,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.generateClaimSignature(
    vaultAddress: vaultAddress,
    account: account,
    cumulativeAmount: cumulativeAmount,
    deadline: deadline,
  );
}

@riverpod
Future<Map<String, dynamic>> generateBatchClaimData(
  Ref ref, {
  required List<Map<String, dynamic>> claims,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.generateBatchClaimData(claims: claims);
}

@riverpod
Future<Map<String, dynamic>> getPublisherInfo(
  Ref ref,
) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.getPublisherInfo();
}

@riverpod
Future<List<SupportedToken>> getSupportedTokens(Ref ref) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.getSupportedTokens();
}

@riverpod
Future<FactorySearchResult> searchFactories(
  Ref ref, {
  required FactorySearchCriteria criteria,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.searchFactories(criteria);
}

@riverpod
Future<FactorySearchResult> getUserFactories(
  Ref ref, {
  required String walletAddress,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.getUserFactories(walletAddress: walletAddress);
}

@riverpod
Future<Factory> getFactory(
  Ref ref, {
  required String factoryId,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.getFactory(factoryId);
}

@riverpod
Future<Factory> updateFactory(
  Ref ref, {
  required String factoryId,
  required String walletAddress,
  String? factoryName,
  String? description,
  List<String>? skills,
  FactoryStatus? status,
  double? pricePerDemo,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.updateFactory(
    factoryId: factoryId,
    walletAddress: walletAddress,
    name: factoryName,
    description: description,
    skills: skills,
    status: status,
    pricePerDemo: pricePerDemo,
  );
}

@riverpod
Future<FactorySearchResult> getFactoriesByCreator(
  Ref ref, {
  required String creatorAddress,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.getFactoriesByCreator(creatorAddress: creatorAddress);
}

@riverpod
Future<FactorySearchResult> searchFactoriesBySkills(
  Ref ref, {
  required List<String> skills,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.searchFactoriesBySkills(skills: skills);
}

@riverpod
Future<FactorySearchResult> searchFactoriesByToken(
  Ref ref, {
  required String tokenSymbol,
}) {
  final repository = ref.read(factoryRepositoryProvider);
  return repository.searchFactoriesByToken(tokenSymbol: tokenSymbol);
}
