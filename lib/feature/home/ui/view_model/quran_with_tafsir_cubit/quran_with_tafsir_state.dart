part of 'quran_with_tafsir_cubit.dart';

@immutable
sealed class QuranWithTafsirState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class QuranWithTafsirInitial extends QuranWithTafsirState {}

// 🔄 حالة التحميل
class QuranWithTafsirLoading extends QuranWithTafsirState {}

// ✅ حالة نجاح - جلب قائمة التفسيرات
class TafsirEditionsLoaded extends QuranWithTafsirState {
  final TafsirModel tafsirModel;
  TafsirEditionsLoaded(this.tafsirModel);
  @override
  List<Object?> get props => [tafsirModel];
}

// ✅ حالة نجاح - القرآن كاملًا مع تفسير معين
class QuranWithTafsirLoaded extends QuranWithTafsirState {
  final TafsirQuran tafsirQuran;
  QuranWithTafsirLoaded(this.tafsirQuran);
  @override
  List<Object?> get props => [tafsirQuran];
}

// ❌ حالة الفشل
class QuranWithTafsirError extends QuranWithTafsirState {
  final String message;
  QuranWithTafsirError(this.message);
  @override
  List<Object?> get props => [message];
}
