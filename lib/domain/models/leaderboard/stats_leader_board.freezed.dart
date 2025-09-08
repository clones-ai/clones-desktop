// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats_leader_board.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LeaderboardStats _$LeaderboardStatsFromJson(Map<String, dynamic> json) {
  return _LeaderboardStats.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardStats {
  int get totalWorkers => throw _privateConstructorUsedError;
  int get tasksCompleted => throw _privateConstructorUsedError;
  double get totalRewards => throw _privateConstructorUsedError;
  int get activeForges => throw _privateConstructorUsedError;
  double get totalUSDPayout => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardStatsCopyWith<LeaderboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardStatsCopyWith<$Res> {
  factory $LeaderboardStatsCopyWith(
          LeaderboardStats value, $Res Function(LeaderboardStats) then) =
      _$LeaderboardStatsCopyWithImpl<$Res, LeaderboardStats>;
  @useResult
  $Res call(
      {int totalWorkers,
      int tasksCompleted,
      double totalRewards,
      int activeForges,
      double totalUSDPayout});
}

/// @nodoc
class _$LeaderboardStatsCopyWithImpl<$Res, $Val extends LeaderboardStats>
    implements $LeaderboardStatsCopyWith<$Res> {
  _$LeaderboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalWorkers = null,
    Object? tasksCompleted = null,
    Object? totalRewards = null,
    Object? activeForges = null,
    Object? totalUSDPayout = null,
  }) {
    return _then(_value.copyWith(
      totalWorkers: null == totalWorkers
          ? _value.totalWorkers
          : totalWorkers // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalRewards: null == totalRewards
          ? _value.totalRewards
          : totalRewards // ignore: cast_nullable_to_non_nullable
              as double,
      activeForges: null == activeForges
          ? _value.activeForges
          : activeForges // ignore: cast_nullable_to_non_nullable
              as int,
      totalUSDPayout: null == totalUSDPayout
          ? _value.totalUSDPayout
          : totalUSDPayout // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeaderboardStatsImplCopyWith<$Res>
    implements $LeaderboardStatsCopyWith<$Res> {
  factory _$$LeaderboardStatsImplCopyWith(_$LeaderboardStatsImpl value,
          $Res Function(_$LeaderboardStatsImpl) then) =
      __$$LeaderboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalWorkers,
      int tasksCompleted,
      double totalRewards,
      int activeForges,
      double totalUSDPayout});
}

/// @nodoc
class __$$LeaderboardStatsImplCopyWithImpl<$Res>
    extends _$LeaderboardStatsCopyWithImpl<$Res, _$LeaderboardStatsImpl>
    implements _$$LeaderboardStatsImplCopyWith<$Res> {
  __$$LeaderboardStatsImplCopyWithImpl(_$LeaderboardStatsImpl _value,
      $Res Function(_$LeaderboardStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of LeaderboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalWorkers = null,
    Object? tasksCompleted = null,
    Object? totalRewards = null,
    Object? activeForges = null,
    Object? totalUSDPayout = null,
  }) {
    return _then(_$LeaderboardStatsImpl(
      totalWorkers: null == totalWorkers
          ? _value.totalWorkers
          : totalWorkers // ignore: cast_nullable_to_non_nullable
              as int,
      tasksCompleted: null == tasksCompleted
          ? _value.tasksCompleted
          : tasksCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalRewards: null == totalRewards
          ? _value.totalRewards
          : totalRewards // ignore: cast_nullable_to_non_nullable
              as double,
      activeForges: null == activeForges
          ? _value.activeForges
          : activeForges // ignore: cast_nullable_to_non_nullable
              as int,
      totalUSDPayout: null == totalUSDPayout
          ? _value.totalUSDPayout
          : totalUSDPayout // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaderboardStatsImpl implements _LeaderboardStats {
  const _$LeaderboardStatsImpl(
      {required this.totalWorkers,
      required this.tasksCompleted,
      required this.totalRewards,
      required this.activeForges,
      this.totalUSDPayout = 0.0});

  factory _$LeaderboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardStatsImplFromJson(json);

  @override
  final int totalWorkers;
  @override
  final int tasksCompleted;
  @override
  final double totalRewards;
  @override
  final int activeForges;
  @override
  @JsonKey()
  final double totalUSDPayout;

  @override
  String toString() {
    return 'LeaderboardStats(totalWorkers: $totalWorkers, tasksCompleted: $tasksCompleted, totalRewards: $totalRewards, activeForges: $activeForges, totalUSDPayout: $totalUSDPayout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaderboardStatsImpl &&
            (identical(other.totalWorkers, totalWorkers) ||
                other.totalWorkers == totalWorkers) &&
            (identical(other.tasksCompleted, tasksCompleted) ||
                other.tasksCompleted == tasksCompleted) &&
            (identical(other.totalRewards, totalRewards) ||
                other.totalRewards == totalRewards) &&
            (identical(other.activeForges, activeForges) ||
                other.activeForges == activeForges) &&
            (identical(other.totalUSDPayout, totalUSDPayout) ||
                other.totalUSDPayout == totalUSDPayout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalWorkers, tasksCompleted,
      totalRewards, activeForges, totalUSDPayout);

  /// Create a copy of LeaderboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardStatsImplCopyWith<_$LeaderboardStatsImpl> get copyWith =>
      __$$LeaderboardStatsImplCopyWithImpl<_$LeaderboardStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardStatsImplToJson(
      this,
    );
  }
}

abstract class _LeaderboardStats implements LeaderboardStats {
  const factory _LeaderboardStats(
      {required final int totalWorkers,
      required final int tasksCompleted,
      required final double totalRewards,
      required final int activeForges,
      final double totalUSDPayout}) = _$LeaderboardStatsImpl;

  factory _LeaderboardStats.fromJson(Map<String, dynamic> json) =
      _$LeaderboardStatsImpl.fromJson;

  @override
  int get totalWorkers;
  @override
  int get tasksCompleted;
  @override
  double get totalRewards;
  @override
  int get activeForges;
  @override
  double get totalUSDPayout;

  /// Create a copy of LeaderboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardStatsImplCopyWith<_$LeaderboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
