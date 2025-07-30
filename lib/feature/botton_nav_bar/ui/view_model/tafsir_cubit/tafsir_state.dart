part of 'tafsir_cubit.dart';

@immutable
sealed class TafsirByAyahState  extends Equatable {
  @override
  List<Object?> get props => [];
}

final class TafsirInitial extends TafsirByAyahState {}

// 🔄 حالة التحميل
class TafsirByAyahLoading extends TafsirByAyahState {}

// ✅ حالة نجاح - تفسير آية معينة
class TafsirByAyahLoaded extends TafsirByAyahState {
  final TafsirByAyah tafsirByAyah;
  TafsirByAyahLoaded(this.tafsirByAyah);
  @override
  List<Object?> get props => [tafsirByAyah];
}

// ❌ حالة الفشل
class TafsirByAyahError extends TafsirByAyahState {
  final String message;
  TafsirByAyahError(this.message);
  @override
  List<Object?> get props => [message];
}
