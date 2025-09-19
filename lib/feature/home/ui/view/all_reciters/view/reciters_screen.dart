import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view/widget/custom_reciters_list_item.dart';
import 'package:islami_app/feature/home/ui/view/all_reciters/view_model/reciterCubit/reciter_cubit.dart';

class RecitersScreen extends StatefulWidget {
  const RecitersScreen({super.key});

  @override
  _RecitersScreenState createState() => _RecitersScreenState();
}

class _RecitersScreenState extends State<RecitersScreen> {
  Map<int, bool> expandedCards = {};
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();

    // Listen to scroll events for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more when user is 200px from the bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<ReciterCubit>();
      final state = cubit.state;

      // Debug scroll trigger
      print(
        '📜 Scroll triggered - Pixels: ${_scrollController.position.pixels}, Max: ${_scrollController.position.maxScrollExtent}',
      );

      if (state is ReciterLoaded && state.hasMoreData) {
        print('🔄 Triggering loadNextPage...');
        cubit.loadNextPage();
      } else if (state is ReciterLoaded && !state.hasMoreData) {
        print('✅ No more data to load');
      } else {
        print('⚠️ State is not ReciterLoaded or no more data');
      }
    }
  }

  void _onSearchChanged(String value) {
    context.read<ReciterCubit>().searchReciters(value);
  }

  Future<void> _onRefresh() async {
    context.read<ReciterCubit>().refresh();
    // Reset expanded cards on refresh
    setState(() {
      expandedCards.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("قرّاء القرآن"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.black, fontSize: 18),
              decoration: InputDecoration(
                labelText: "بحث عن قارئ",
                border: const OutlineInputBorder(),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                        : const Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: BlocBuilder<ReciterCubit, ReciterState>(
        builder: (context, state) {
          if (state is ReciterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReciterLoaded || state is ReciterLoadingMore) {
            final currentReciters =
                state is ReciterLoaded
                    ? state.reciters
                    : (state as ReciterLoadingMore).currentReciters;

            final hasMoreData =
                state is ReciterLoaded
                    ? state.hasMoreData
                    : (state as ReciterLoadingMore).hasMoreData;

            if (currentReciters.isEmpty) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView(
                  children: const [
                    SizedBox(height: 200),
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            "لم يتم العثور على قرّاء",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: currentReciters.length + (hasMoreData ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show loading indicator at the end
                  if (index == currentReciters.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final reciter = currentReciters[index];
                  final isExpanded = expandedCards[reciter.id] ?? false;

                  return CustomRecitersListItem(
                    isExpanded: isExpanded,
                    reciter: reciter,
                    onTap: () {
                      setState(() {
                        // Close all other expanded cards when opening a new one
                        if (!isExpanded) {
                          expandedCards.clear();
                        }
                        expandedCards[reciter.id ?? 0] = !isExpanded;
                      });
                    },
                  );
                },
              ),
            );
          } else if (state is ReciterError) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                children: [
                  const SizedBox(height: 200),
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              () =>
                                  context.read<ReciterCubit>().fetchReciters(),
                          child: const Text("إعادة المحاولة"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView(
              children: const [
                SizedBox(height: 200),
                Center(
                  child: Text(
                    "لا توجد بيانات متاحة",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // Add floating action button for quick stats
      floatingActionButton: BlocBuilder<ReciterCubit, ReciterState>(
        builder: (context, state) {
          if (state is ReciterLoaded && state.reciters.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () {
                final cubit = context.read<ReciterCubit>();
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("إحصائيات"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("إجمالي القرّاء: ${cubit.totalReciters}"),
                            Text("الصفحة الحالية: ${state.currentPage}"),
                            Text("إجمالي الصفحات: ${cubit.totalPages}"),
                            if (cubit.hasSearch)
                              Text("نتائج البحث: ${state.reciters.length}"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("موافق"),
                          ),
                        ],
                      ),
                );
              },
              icon: const Icon(Icons.info_outline),
              label: Text("${state.reciters.length}"),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
