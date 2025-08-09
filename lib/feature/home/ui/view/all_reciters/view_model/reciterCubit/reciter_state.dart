part of 'reciter_cubit.dart';

sealed class ReciterState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ReciterInitial extends ReciterState {}

class ReciterLoading extends ReciterState {}

class ReciterLoadingMore extends ReciterState {
  final List<Reciters> currentReciters;
  final int currentPage;
  final bool hasMoreData;

  ReciterLoadingMore({
    required this.currentReciters,
    required this.currentPage,
    required this.hasMoreData,
  });

  @override
  List<Object?> get props => [currentReciters, currentPage, hasMoreData];
}

class ReciterLoaded extends ReciterState {
  final List<Reciters> reciters;
  final List<Reciters> allReciters; // Store all reciters for filtering
  final int currentPage;
  final bool hasMoreData;
  final bool isRefreshing;

  ReciterLoaded({
    required this.reciters,
    required this.allReciters,
    required this.currentPage,
    required this.hasMoreData,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [
    reciters,
    allReciters,
    currentPage,
    hasMoreData,
    isRefreshing,
  ];

  ReciterLoaded copyWith({
    List<Reciters>? reciters,
    List<Reciters>? allReciters,
    int? currentPage,
    bool? hasMoreData,
    bool? isRefreshing,
  }) {
    return ReciterLoaded(
      reciters: reciters ?? this.reciters,
      allReciters: allReciters ?? this.allReciters,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class ReciterError extends ReciterState {
  final String message;
  ReciterError(this.message);
  @override
  List<Object?> get props => [message];
}
