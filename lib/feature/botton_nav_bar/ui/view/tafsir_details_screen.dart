import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/core/widget/error_widget.dart';
import 'package:islami_app/feature/botton_nav_bar/data/model/tafsir_page_model.dart';
import 'package:islami_app/feature/botton_nav_bar/ui/view_model/tafsir_cubit/tafsir_cubit.dart';

class TafsirDetailsScreen extends StatefulWidget {
  /// رقم الصفحة في المصحف (1-604)
  final int pageNumber;

  /// الرقم التراكمي للآية المختارة (1-6236)
  final int targetVerse;

  /// نص الآية المختارة
  final String text;

  const TafsirDetailsScreen({
    super.key,
    required this.pageNumber,
    required this.targetVerse,
    required this.text,
  });

  @override
  State<TafsirDetailsScreen> createState() => _TafsirDetailsScreenState();
}

class _TafsirDetailsScreenState extends State<TafsirDetailsScreen> {
  // ─── قائمة التفاسير المتاحة ───
  List<TafsirEditionData> _editions = [];
  TafsirEditionData? _selectedEdition;

  // ─── قائمة آيات الصفحة ───
  List<TafsirAyahItem> _ayahs = [];

  // ─── Scroll ───
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _ayahKeys = {};

  @override
  void initState() {
    super.initState();
    // نجيب قائمة التفاسير أولاً
    context.read<TafsirCubit>().fetchTafsirEditions();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ─── لما يختار المستخدم تفسيراً من الـ Dropdown ───
  void _onEditionSelected(TafsirEditionData edition) {
    setState(() {
      _selectedEdition = edition;
      _ayahs = [];
      _ayahKeys.clear();
    });
    context.read<TafsirCubit>().fetchPageTafsir(
      widget.pageNumber.toString(),
      edition.identifier,
    );
  }

  // ─── auto-scroll للآية المختارة ───
  void _scrollToTargetVerse() {
    if (!mounted) return;
    final key = _ayahKeys[widget.targetVerse];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    // نستدعي ensureVisible مباشرة بدون addPostFrameCallback إضافي
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تفسير الآية"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: _buildDropdownArea(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocConsumer<TafsirCubit, TafsirByAyahState>(
            listener: (context, state) {
              // ─── استقبال قائمة التفاسير ───
              if (state is TafsirEditionsLoaded && state.editions.isNotEmpty) {
                _editions = state.editions;
                final defaultEdition = state.editions.firstWhere(
                  (e) =>
                      e.identifier == 'ar.muyassar' ||
                      e.identifier.startsWith('ar.'),
                  orElse: () => state.editions.first,
                );
                _onEditionSelected(defaultEdition);
              }

              // ─── استقبال آيات الصفحة ───
              if (state is TafsirPageLoaded) {
                // نبني الـ keys أولاً قبل setState عشان تكون جاهزة
                final newKeys = <int, GlobalKey>{};
                for (final ayah in state.ayahs) {
                  if (ayah.number != null) {
                    newKeys[ayah.number!] = GlobalKey();
                  }
                }
                setState(() {
                  _ayahs = state.ayahs;
                  _ayahKeys
                    ..clear()
                    ..addAll(newKeys);
                });
                // نستنى frame + frame تانية عشان الـ ListView يبني كل الـ items
                Future.delayed(
                  const Duration(milliseconds: 300),
                  _scrollToTargetVerse,
                );
              }
            },
            builder: (context, state) {
              // ─── تحميل قائمة التفاسير ───
              if (state is TafsirEditionsLoading ||
                  (state is TafsirInitial && _editions.isEmpty)) {
                return const Center(child: CircularProgressIndicator());
              }

              // ─── خطأ في قائمة التفاسير ───
              if (state is TafsirEditionsError) {
                return customErrorWidget(
                  onPressed:
                      () => context.read<TafsirCubit>().fetchTafsirEditions(),
                );
              }

              // ─── تحميل آيات الصفحة ───
              if (state is TafsirPageLoading && _ayahs.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // ─── خطأ في تحميل الصفحة ───
              if (state is TafsirPageError && _ayahs.isEmpty) {
                return customErrorWidget(
                  onPressed: () {
                    if (_selectedEdition != null) {
                      context.read<TafsirCubit>().fetchPageTafsir(
                        widget.pageNumber.toString(),
                        _selectedEdition!.identifier,
                      );
                    }
                  },
                );
              }

              // ─── عرض آيات الصفحة (كلها مرة واحدة عشان الـ GlobalKeys تشتغل) ───
              if (_ayahs.isNotEmpty) {
                return ListView(
                  controller: _scrollController,
                  children:
                      _ayahs.map((ayah) {
                        final isTarget = ayah.number == widget.targetVerse;
                        return _buildAyahCard(ayah, isTarget);
                      }).toList(),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  // ─── منطقة الـ Dropdown في الـ AppBar ───
  Widget _buildDropdownArea() {
    if (_editions.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: _buildDropdown(),
    );
  }

  // ─── Dropdown اختيار التفسير ───
  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TafsirEditionData>(
          isExpanded: true,
          value: _selectedEdition,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).primaryColor,
          ),
          hint: const Text('اختر التفسير', textDirection: TextDirection.rtl),
          items:
              _editions.map((edition) {
                return DropdownMenuItem<TafsirEditionData>(
                  value: edition,
                  child: Text(
                    edition.name,
                    textDirection: TextDirection.rtl,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
          onChanged: (edition) {
            if (edition != null) _onEditionSelected(edition);
          },
        ),
      ),
    );
  }

  // ─── Card لكل آية ───
  Widget _buildAyahCard(TafsirAyahItem ayah, bool isTarget) {
    final key = _ayahKeys[ayah.number];

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border:
            isTarget
                ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                : null,
        boxShadow:
            isTarget
                ? [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
                : null,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color:
            isTarget
                ? Theme.of(context).primaryColor.withValues(alpha: 0.07)
                : Theme.of(context).cardColor,
        elevation: isTarget ? 0 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── رأس الكارد: اسم السورة + رقم الآية ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // رقم الآية في دائرة
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isTarget
                              ? Theme.of(context).primaryColor
                              : Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.15),
                    ),
                    child: Center(
                      child: Text(
                        '${ayah.numberInSurah}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              isTarget
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  // اسم السورة
                  Text(
                    ayah.surahName ?? '',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),

              // ─── نص الآية المختارة (فقط للآية المستهدفة) ───
              if (isTarget) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.text,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium?.copyWith(height: 1.8),
                  ),
                ),
              ],

              const Divider(height: 18),

              // ─── نص التفسير ───
              Text(
                ayah.text ?? '',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.justify,
                style: context.textTheme.bodyMedium?.copyWith(height: 1.9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
