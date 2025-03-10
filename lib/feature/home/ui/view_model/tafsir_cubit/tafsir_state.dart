part of 'tafsir_cubit.dart';

@immutable
sealed class TafsirState {}

final class TafsirInitial extends TafsirState {}



// 🔄 حالة التحميل
class TafsirLoading extends TafsirState {}

// ✅ حالة نجاح - جلب قائمة التفسيرات
class TafsirEditionsLoaded extends TafsirState {
  final TafsirModel tafsirModel;
   TafsirEditionsLoaded(this.tafsirModel);

}

// ✅ حالة نجاح - تفسير آية معينة
class AyahTafsirLoaded extends TafsirState {
  final TafsirByAyah tafsirByAyah;
   AyahTafsirLoaded(this.tafsirByAyah);

}

// ✅ حالة نجاح - القرآن كاملًا مع تفسير معين
class QuranWithTafsirLoaded extends TafsirState {
  final TafsirQuran tafsirQuran;
   QuranWithTafsirLoaded(this.tafsirQuran);

}

// ❌ حالة الفشل
class TafsirError extends TafsirState {
  final String message;
   TafsirError(this.message);

}
