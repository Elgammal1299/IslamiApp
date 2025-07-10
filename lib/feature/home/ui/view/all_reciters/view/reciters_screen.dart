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
  String searchQuery = "";
  Map<int, bool> expandedCards = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("قرّاء القرآن")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              style: TextStyle(color: AppColors.black, fontSize: 18),
              decoration: InputDecoration(
                labelText: "بحث عن قارئ",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ReciterCubit, ReciterState>(
              builder: (context, state) {
                if (state is ReciterLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ReciterLoaded) {
                  final filteredReciters =
                      state.reciters
                          .where(
                            (reciter) =>
                                reciter.name?.contains(searchQuery) ?? false,
                          )
                          .toList();

                  return ListView.builder(
                    itemCount: filteredReciters.length,
                    itemBuilder: (context, index) {
                      final reciter = filteredReciters[index];
                      final isExpanded = expandedCards[reciter.id] ?? false;

                      return CustomRecitersListItem(
                        isExpanded: isExpanded,
                        reciter: reciter,
                        onTap: () {
                          setState(() {
                            expandedCards[reciter.id ?? 0] = !isExpanded;
                          });
                        },
                      );
                    },
                  );
                } else if (state is ReciterError) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text("No data available"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
