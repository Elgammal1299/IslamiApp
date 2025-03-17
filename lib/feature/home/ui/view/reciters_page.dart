
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/feature/home/data/model/quran_audio_model.dart';
import 'package:islami_app/feature/home/ui/view_model/reciterCubit/reciter_cubit.dart';

class RecitersScreen extends StatefulWidget {
  const RecitersScreen({super.key});

  @override
  _RecitersScreenState createState() => _RecitersScreenState();
}

class _RecitersScreenState extends State<RecitersScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("قرّاء القرآن"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
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
                  final filteredReciters = state.reciters
                      .where((reciter) => reciter.name?.contains(searchQuery) ?? false)
                      .toList();

                  return ListView.builder(
                    itemCount: filteredReciters.length,
                    itemBuilder: (context, index) {
                      final reciter = filteredReciters[index];
                      return ListTile(
                        title: Text(reciter.name ?? 'Unknown'),
                        subtitle: Text("عدد الروايات: ${reciter.moshaf?.length ?? 0}"),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurahSelectionScreen(reciter),
                            ),
                          );
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

class SurahSelectionScreen extends StatelessWidget {
  final Reciters reciter;
  final AudioPlayer audioPlayer = AudioPlayer();

  SurahSelectionScreen(this.reciter, {super.key});

  Future<void> playSurah(String url) async {
    try {
      await audioPlayer.setSourceUrl(url);
      await audioPlayer.play(UrlSource(url));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(reciter.name ?? "")),
      body: ListView.builder(
        itemCount: reciter.moshaf?.length ?? 0,
        itemBuilder: (context, index) {
          final moshaf = reciter.moshaf![index];
          return ListTile(
            title: Text(moshaf.name ?? "Unknown"),
            trailing: Icon(Icons.play_arrow),
            onTap: () => playSurah(moshaf.server ?? ""),
          );
        },
      ),
    );
  }
}
