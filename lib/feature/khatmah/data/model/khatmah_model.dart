import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'khatmah_model.g.dart';

/// نموذج تقدم الجزء
@HiveType(typeId: 2)
class JuzProgress extends Equatable {
  @HiveField(0)
  final int juzNumber;

  @HiveField(1)
  final int startPage;

  @HiveField(2)
  final int endPage;

  @HiveField(3)
  final int currentPage;

  @HiveField(4)
  final bool isCompleted;

  const JuzProgress({
    required this.juzNumber,
    required this.startPage,
    required this.endPage,
    required this.currentPage,
    required this.isCompleted,
  });

  JuzProgress copyWith({
    int? juzNumber,
    int? startPage,
    int? endPage,
    int? currentPage,
    bool? isCompleted,
  }) {
    return JuzProgress(
      juzNumber: juzNumber ?? this.juzNumber,
      startPage: startPage ?? this.startPage,
      endPage: endPage ?? this.endPage,
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
    juzNumber,
    startPage,
    endPage,
    currentPage,
    isCompleted,
  ];
}

/// نموذج التقدم اليومي
@HiveType(typeId: 1)
class DailyProgress extends Equatable {
  @HiveField(0)
  final int dayNumber;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final List<JuzProgress> juzList;

  @HiveField(3)
  final bool isCompleted;

  const DailyProgress({
    required this.dayNumber,
    required this.date,
    required this.juzList,
    required this.isCompleted,
  });

  DailyProgress copyWith({
    int? dayNumber,
    DateTime? date,
    List<JuzProgress>? juzList,
    bool? isCompleted,
  }) {
    return DailyProgress(
      dayNumber: dayNumber ?? this.dayNumber,
      date: date ?? this.date,
      juzList: juzList ?? this.juzList,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [dayNumber, date, juzList, isCompleted];
}

/// نموذج بيانات الختمة
@HiveType(typeId: 0)
class KhatmahModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int totalDays;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime endDate;

  @HiveField(5)
  final List<DailyProgress> dailyProgress;

  @HiveField(6)
  final bool isCompleted;

  @HiveField(7)
  final DateTime createdAt;

  const KhatmahModel({
    required this.id,
    required this.name,
    required this.totalDays,
    required this.startDate,
    required this.endDate,
    required this.dailyProgress,
    required this.isCompleted,
    required this.createdAt,
  });

  KhatmahModel copyWith({
    String? id,
    String? name,
    int? totalDays,
    DateTime? startDate,
    DateTime? endDate,
    List<DailyProgress>? dailyProgress,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return KhatmahModel(
      id: id ?? this.id,
      name: name ?? this.name,
      totalDays: totalDays ?? this.totalDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dailyProgress: dailyProgress ?? this.dailyProgress,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    totalDays,
    startDate,
    endDate,
    dailyProgress,
    isCompleted,
    createdAt,
  ];
}
