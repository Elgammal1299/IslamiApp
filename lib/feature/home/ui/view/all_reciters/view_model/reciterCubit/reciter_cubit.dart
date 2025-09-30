import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/model/reciters_model.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/data/repo/reciters_repo.dart';

part 'reciter_state.dart';

class ReciterCubit extends Cubit<ReciterState> {
  final ReciterRepo repository;
  static const int pageSize = 20; // Number of items per page

  List<Reciters> _allReciters = [];
  List<Reciters> _filteredReciters = [];
  String _currentSearchQuery = '';
  bool _isLoadingMore = false; // Prevent multiple simultaneous load requests

  ReciterCubit(this.repository) : super(ReciterInitial());

  void fetchReciters({bool refresh = false}) async {
    if (refresh) {
      _allReciters.clear();
      _filteredReciters.clear();
      _currentSearchQuery = '';
      if (!isClosed) emit(ReciterLoading());
    } else if (_allReciters.isEmpty) {
      if (!isClosed) emit(ReciterLoading());
    }

    final result = await repository.getReciters();
    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) emit(ReciterError(error));
      },
      (data) {
        if (isClosed) return;

        _allReciters = data;
        _filteredReciters = data;

        // Load first page
        final firstPageReciters = _getPageData(1);
        final hasMoreData = firstPageReciters.length < _filteredReciters.length;

        // Debug information
        print(
          '🚀 Initial load: ${firstPageReciters.length} items, Total: ${_filteredReciters.length}, HasMore: $hasMoreData',
        );

        if (!isClosed) {
          emit(
            ReciterLoaded(
              reciters: firstPageReciters,
              allReciters: _allReciters,
              currentPage: 1,
              hasMoreData: hasMoreData,
              isRefreshing: refresh,
            ),
          );
        }
      },
    );
  }

  void loadNextPage() async {
    final currentState = state;

    // Prevent multiple simultaneous load requests
    if (_isLoadingMore ||
        currentState is! ReciterLoaded ||
        !currentState.hasMoreData ||
        isClosed) {
      return;
    }

    _isLoadingMore = true;

    try {
      emit(
        ReciterLoadingMore(
          currentReciters: currentState.reciters,
          currentPage: currentState.currentPage,
          hasMoreData: currentState.hasMoreData,
        ),
      );

      // Simulate network delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      if (isClosed) return;

      final nextPage = currentState.currentPage + 1;
      final nextPageReciters = _getPageData(nextPage);

      // Debug information
      print('📄 Loading page $nextPage: ${nextPageReciters.length} items');
      print(
        '📊 Current loaded: ${currentState.reciters.length}, Total available: ${_filteredReciters.length}',
      );

      // Check if there are actually more items to load
      final hasMoreItems =
          (currentState.reciters.length + nextPageReciters.length) <
          _filteredReciters.length;

      final updatedReciters = [...currentState.reciters, ...nextPageReciters];

      if (!isClosed) {
        emit(
          ReciterLoaded(
            reciters: updatedReciters,
            allReciters: currentState.allReciters,
            currentPage: nextPage,
            hasMoreData: hasMoreItems,
          ),
        );
      }
    } finally {
      _isLoadingMore = false;
    }
  }

  void searchReciters(String query) {
    if (isClosed) return;

    _currentSearchQuery = query;

    if (query.isEmpty) {
      _filteredReciters = _allReciters;
    } else {
      _filteredReciters =
          _allReciters
              .where(
                (reciter) =>
                    (reciter.name?.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ??
                        false),
              )
              .toList();
    }

    // Reset to first page with filtered results
    final firstPageReciters = _getPageData(1);
    final hasMoreData = firstPageReciters.length < _filteredReciters.length;

    if (!isClosed) {
      emit(
        ReciterLoaded(
          reciters: firstPageReciters,
          allReciters: _allReciters,
          currentPage: 1,
          hasMoreData: hasMoreData,
        ),
      );
    }
  }

  void refresh() {
    fetchReciters(refresh: true);
  }

  List<Reciters> _getPageData(int page) {
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= _filteredReciters.length) {
      return [];
    }

    return _filteredReciters.sublist(
      startIndex,
      endIndex > _filteredReciters.length ? _filteredReciters.length : endIndex,
    );
  }

  int get totalPages => (_filteredReciters.length / pageSize).ceil();
  int get totalReciters => _filteredReciters.length;
  bool get hasSearch => _currentSearchQuery.isNotEmpty;
}
