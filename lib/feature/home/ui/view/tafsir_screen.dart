import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/router/app_routes.dart';
import 'package:islami_app/feature/home/data/model/tafsir_model.dart';
import 'package:islami_app/feature/home/ui/view_model/quran_with_tafsir_cubit/quran_with_tafsir_cubit.dart';

class TafsirScreen extends StatefulWidget {
  const TafsirScreen({super.key});

  @override
  State<TafsirScreen> createState() => _TafsirScreenState();
}

class _TafsirScreenState extends State<TafsirScreen> {
  @override
  void initState() {
    context.read<QuranWithTafsirCubit>().fetchTafsirEditions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "التفسير",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return BlocBuilder<QuranWithTafsirCubit, QuranWithTafsirState>(
      buildWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildStateWidget(state),
        );
      },
    );
  }

  Widget _buildStateWidget(QuranWithTafsirState state) {
    if (state is QuranWithTafsirLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TafsirEditionsLoaded) {
      return TafsirEditionsList(editions: state.tafsirModel);
    } else if (state is QuranWithTafsirError) {
      return _buildErrorWidget(state.message);
    }
    return const SizedBox();
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<QuranWithTafsirCubit>().fetchTafsirEditions();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

class TafsirEditionsList extends StatelessWidget {
  final TafsirModel editions;

  const TafsirEditionsList({super.key, required this.editions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal.shade50, Colors.white],
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: editions.data!.length,
        itemBuilder: (context, index) {
          return _buildEditionCard(context, editions.data![index]);
        },
      ),
    );
  }

  Widget _buildEditionCard(BuildContext context, dynamic edition) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _navigateToTafsirContent(context, edition),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              edition.name ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              edition.englishName ?? '',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.teal.shade300,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToTafsirContent(BuildContext context, dynamic edition) {
    Navigator.pushNamed(
      context,
      AppRoutes.tafsirByQuranContentRouter,
      arguments: {"identifier": edition.identifier ?? "ar.muyassar"},
    );
  }
}

class TafsirContentView extends StatefulWidget {
  final String identifier;

  const TafsirContentView({super.key, required this.identifier});

  @override
  State<TafsirContentView> createState() => _TafsirContentViewState();
}

class _TafsirContentViewState extends State<TafsirContentView> {
  @override
  void initState() {
    super.initState();
    _loadTafsir();
  }

  void _loadTafsir() {
    context.read<QuranWithTafsirCubit>().fetchQuranWithTafsir(
      widget.identifier,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "التفسير",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return BlocBuilder<QuranWithTafsirCubit, QuranWithTafsirState>(
      buildWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildStateWidget(state),
        );
      },
    );
  }

  Widget _buildStateWidget(QuranWithTafsirState state) {
    if (state is QuranWithTafsirLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is QuranWithTafsirError) {
      return _buildErrorWidget(state.message);
    }

    if (state is QuranWithTafsirLoaded) {
      return _buildTafsirContent(state);
    }

    return const SizedBox();
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadTafsir,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildTafsirContent(QuranWithTafsirLoaded state) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal.shade50, Colors.white],
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 1,
        itemBuilder: (context, index) {
          final surah = state.tafsirQuran.data;
          return _buildSurahCard(surah!);
        },
      ),
    );
  }

  Widget _buildSurahCard(dynamic surah) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            "سورة ${surah.surah ?? ''}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: [_buildAyahContent(surah)],
        ),
      ),
    );
  }

  Widget _buildAyahContent(dynamic surah) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAyahNumber(surah),
          const SizedBox(height: 12),
          _buildTafsirText(surah),
        ],
      ),
    );
  }

  Widget _buildAyahNumber(dynamic surah) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "آية ${surah.number ?? ''}",
        style: TextStyle(
          color: Colors.teal.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTafsirText(dynamic surah) {
    return Text(
      surah.edition!.name ?? '',
      style: const TextStyle(fontSize: 16, height: 1.8),
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
    );
  }
}
