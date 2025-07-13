import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/home/ui/view/azkar/data/repo/azkar_random_repo.dart';
import 'package:islami_app/feature/home/ui/view/azkar/view_model/azkar_random_cubit/azkar_random_cubit.dart';

class AzkarRandomScreen extends StatelessWidget {
  const AzkarRandomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarRandomCubit(AzkarRandomRepo())..loadAdhkar(),
      child: BlocBuilder<AzkarRandomCubit, AzkarRandomState>(
        builder: (context, state) {
          if (state is DikrLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AzkarRandomLoaded) {
            final dikr = state.dikr;

            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
                maxHeight: 150,
                minHeight: 150,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              dikr.dikr,
                              key: ValueKey(dikr.dikr),
                              textAlign: TextAlign.center,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(height: 1.8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              context.read<AzkarRandomCubit>().previousDikr();
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              context.read<AzkarRandomCubit>().nextDikr();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AzkarRandomError) {
            return Center(child: Text('حدث خطأ: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
