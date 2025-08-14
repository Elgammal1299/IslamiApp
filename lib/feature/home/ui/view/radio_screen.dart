import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/home/ui/view_model/radio_cubit/radio_cubit.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RadioCubit>().loadRadioStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إذاعة القرآن'), centerTitle: true),
      body: BlocBuilder<RadioCubit, RadioState>(
        //  buildWhen: (previous, current) {
        //       // إعادة البناء فقط عند تغيير حالة التشغيل
        //       return current is RadioPlaying ||
        //           (previous is RadioPlaying && current is! RadioPlaying);
        //     },
        builder: (context, state) {
          if (state is RadioLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RadioError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RadioCubit>().loadRadioStations();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is RadioLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.stations.length,
              itemBuilder: (context, index) {
                final station = state.stations[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.radioPlayerRouter,
                        arguments: {
                          "station": station,
                          'radioCubit': context.read<RadioCubit>(),
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).secondaryHeaderColor,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        title: Text(
                          station.name,
                          style: context.textTheme.titleLarge,
                        ),
                        trailing: Icon(
                          Icons.play_circle_filled,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
