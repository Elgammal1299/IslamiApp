part of 'khatmah_cubit.dart';

@immutable
sealed class KhatmahState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class KhatmahInitial extends KhatmahState {}

final class KhatmahLoading extends KhatmahState {}

final class KhatmahLoaded extends KhatmahState {
  final List<KhatmahModel> khatmahs;
  final KhatmahModel? activeKhatmah;

  KhatmahLoaded({
    required this.khatmahs,
    this.activeKhatmah,
  });

  @override
  List<Object?> get props => [khatmahs, activeKhatmah];
}

final class KhatmahCreated extends KhatmahState {
  final KhatmahModel khatmah;

  KhatmahCreated(this.khatmah);

  @override
  List<Object?> get props => [khatmah];
}

final class KhatmahError extends KhatmahState {
  final String message;

  KhatmahError(this.message);

  @override
  List<Object?> get props => [message];
}