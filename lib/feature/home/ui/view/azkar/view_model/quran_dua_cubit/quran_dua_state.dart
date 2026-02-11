part of 'quran_dua_cubit.dart';

abstract class QuranDuaState extends Equatable {
  const QuranDuaState();

  @override
  List<Object?> get props => [];
}

class QuranDuaInitial extends QuranDuaState {}

class QuranDuaLoading extends QuranDuaState {}

class QuranDuaLoaded extends QuranDuaState {
  final List<QuranDuaModel> duas;
  final int currentIndex;

  const QuranDuaLoaded(this.duas, this.currentIndex);

  @override
  List<Object?> get props => [currentIndex];
}

class QuranDuaError extends QuranDuaState {
  final String message;

  const QuranDuaError(this.message);

  @override
  List<Object?> get props => [message];
}
