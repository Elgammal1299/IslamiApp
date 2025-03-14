import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/tafsir_cubit/tafsir_cubit.dart';

class TafsirDetailsPage extends StatefulWidget {
  final String tafsirIdentifier;
  final int verse;
  final String text;
 
  const TafsirDetailsPage({super.key,   required this.verse, required this.text, required this.tafsirIdentifier,});

  @override
  _TafsirDetailsPageState createState() => _TafsirDetailsPageState();
}

class _TafsirDetailsPageState extends State<TafsirDetailsPage> {

@override
  void initState() {
   
 context.read<TafsirCubit>().fetchAyahTafsir(
          widget.verse.toString(),
          widget.tafsirIdentifier,
        );
    super.initState();
  }
  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: quranPagesColor,

      appBar: AppBar(title: const Text("تفسير الآية")),
      body:Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              
          child: 
              
              // 📖 نص الآية
              Card(
                color: Colors.grey[200],
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                        textDirection: TextDirection.rtl,

                    widget.text,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
        
              // 🔍 عرض التفسير
              ),
          SliverToBoxAdapter(child:SizedBox(height: 16,) ,),
              SliverToBoxAdapter(
                child: BlocBuilder<TafsirCubit, TafsirByAyahState>(
                builder: (context, state) {
                  if (state is TafsirByAyahError) {
                    return Center(child: Text("خطأ: ${state.message}", style: const TextStyle(fontSize: 20,color: Colors.red)));
                  } else if (state is TafsirByAyahLoaded) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textDirection: TextDirection.rtl,
                       textAlign: TextAlign.justify,
                        state.tafsirByAyah.data!.text.toString(),
                        style:  TextStyle(
                          
                          fontSize: 22, fontWeight: FontWeight.w600,color: Colors.grey[600],    fontFamily: "arsura",),
                        // textAlign: TextAlign.justify,
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              )
            ],
        
          ),
      ),
          );
      
      
      
           
   
    
  }
}