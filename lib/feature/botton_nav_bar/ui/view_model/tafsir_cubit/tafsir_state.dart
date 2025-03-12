part of 'tafsir_cubit.dart';

@immutable
sealed class TafsirByAyahState {}

final class TafsirInitial extends TafsirByAyahState {}



// 🔄 حالة التحميل
class TafsirByAyahLoading extends TafsirByAyahState {}



// ✅ حالة نجاح - تفسير آية معينة
class TafsirByAyahLoaded extends TafsirByAyahState {
  final TafsirByAyah tafsirByAyah;
   TafsirByAyahLoaded(this.tafsirByAyah);

}



// ❌ حالة الفشل
class TafsirByAyahError extends TafsirByAyahState {
  final String message;
   TafsirByAyahError(this.message);

}
