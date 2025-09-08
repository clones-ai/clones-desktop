// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_price_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTokenPriceHash() => r'4c31d42b8d1dc3c85f3c0536e14aef9eab2b4d91';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getTokenPrice].
@ProviderFor(getTokenPrice)
const getTokenPriceProvider = GetTokenPriceFamily();

/// See also [getTokenPrice].
class GetTokenPriceFamily extends Family<AsyncValue<double>> {
  /// See also [getTokenPrice].
  const GetTokenPriceFamily();

  /// See also [getTokenPrice].
  GetTokenPriceProvider call(
    String symbol,
  ) {
    return GetTokenPriceProvider(
      symbol,
    );
  }

  @override
  GetTokenPriceProvider getProviderOverride(
    covariant GetTokenPriceProvider provider,
  ) {
    return call(
      provider.symbol,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getTokenPriceProvider';
}

/// See also [getTokenPrice].
class GetTokenPriceProvider extends AutoDisposeFutureProvider<double> {
  /// See also [getTokenPrice].
  GetTokenPriceProvider(
    String symbol,
  ) : this._internal(
          (ref) => getTokenPrice(
            ref as GetTokenPriceRef,
            symbol,
          ),
          from: getTokenPriceProvider,
          name: r'getTokenPriceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getTokenPriceHash,
          dependencies: GetTokenPriceFamily._dependencies,
          allTransitiveDependencies:
              GetTokenPriceFamily._allTransitiveDependencies,
          symbol: symbol,
        );

  GetTokenPriceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
  }) : super.internal();

  final String symbol;

  @override
  Override overrideWith(
    FutureOr<double> Function(GetTokenPriceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetTokenPriceProvider._internal(
        (ref) => create(ref as GetTokenPriceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _GetTokenPriceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetTokenPriceProvider && other.symbol == symbol;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetTokenPriceRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `symbol` of this provider.
  String get symbol;
}

class _GetTokenPriceProviderElement
    extends AutoDisposeFutureProviderElement<double> with GetTokenPriceRef {
  _GetTokenPriceProviderElement(super.provider);

  @override
  String get symbol => (origin as GetTokenPriceProvider).symbol;
}

String _$convertTokenPriceHash() => r'389f50c742fee9d1d03613a652e7c02ee210bc6b';

/// See also [convertTokenPrice].
@ProviderFor(convertTokenPrice)
const convertTokenPriceProvider = ConvertTokenPriceFamily();

/// See also [convertTokenPrice].
class ConvertTokenPriceFamily extends Family<AsyncValue<double>> {
  /// See also [convertTokenPrice].
  const ConvertTokenPriceFamily();

  /// See also [convertTokenPrice].
  ConvertTokenPriceProvider call(
    String symbol,
    double amount,
  ) {
    return ConvertTokenPriceProvider(
      symbol,
      amount,
    );
  }

  @override
  ConvertTokenPriceProvider getProviderOverride(
    covariant ConvertTokenPriceProvider provider,
  ) {
    return call(
      provider.symbol,
      provider.amount,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'convertTokenPriceProvider';
}

/// See also [convertTokenPrice].
class ConvertTokenPriceProvider extends AutoDisposeFutureProvider<double> {
  /// See also [convertTokenPrice].
  ConvertTokenPriceProvider(
    String symbol,
    double amount,
  ) : this._internal(
          (ref) => convertTokenPrice(
            ref as ConvertTokenPriceRef,
            symbol,
            amount,
          ),
          from: convertTokenPriceProvider,
          name: r'convertTokenPriceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$convertTokenPriceHash,
          dependencies: ConvertTokenPriceFamily._dependencies,
          allTransitiveDependencies:
              ConvertTokenPriceFamily._allTransitiveDependencies,
          symbol: symbol,
          amount: amount,
        );

  ConvertTokenPriceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
    required this.amount,
  }) : super.internal();

  final String symbol;
  final double amount;

  @override
  Override overrideWith(
    FutureOr<double> Function(ConvertTokenPriceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConvertTokenPriceProvider._internal(
        (ref) => create(ref as ConvertTokenPriceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _ConvertTokenPriceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConvertTokenPriceProvider &&
        other.symbol == symbol &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConvertTokenPriceRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `symbol` of this provider.
  String get symbol;

  /// The parameter `amount` of this provider.
  double get amount;
}

class _ConvertTokenPriceProviderElement
    extends AutoDisposeFutureProviderElement<double> with ConvertTokenPriceRef {
  _ConvertTokenPriceProviderElement(super.provider);

  @override
  String get symbol => (origin as ConvertTokenPriceProvider).symbol;
  @override
  double get amount => (origin as ConvertTokenPriceProvider).amount;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
