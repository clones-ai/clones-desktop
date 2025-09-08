import 'package:clones_desktop/application/session/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_price_provider.g.dart';

@riverpod
Future<double> getTokenPrice(Ref ref, String symbol) async {
  try {
    final repository = ref.read(walletRepositoryProvider);
    final price = await repository.getTokenPriceUSD(symbol: symbol);
    return price;
  } catch (e) {
    throw Exception('Failed to fetch price for $symbol: $e');
  }
}

@riverpod
Future<double> convertTokenPrice(Ref ref, String symbol, double amount) async {
  try {
    final price = await ref.read(getTokenPriceProvider(symbol).future);
    return price * amount;
  } catch (e) {
    throw Exception('Failed to convert price for $symbol: $e');
  }
}
