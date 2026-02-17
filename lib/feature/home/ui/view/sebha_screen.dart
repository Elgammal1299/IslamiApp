import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/ui/view/widget/dhikr_display_widget.dart';
import 'package:islami_app/feature/home/ui/view/widget/dhikr_input_widget.dart';
import 'package:islami_app/feature/home/ui/view/widget/dhikr_selection_widget.dart';
import 'package:islami_app/feature/home/ui/view/widget/sebha_counter_widget.dart';
import 'package:islami_app/feature/home/ui/view/widget/sebha_controls_widget.dart';

class SebhaScreen extends StatefulWidget {
  const SebhaScreen({super.key});

  @override
  State<SebhaScreen> createState() => _SebhaScreenState();
}

class _SebhaScreenState extends State<SebhaScreen>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  // Custom dhikr functionality
  String _dhikrText = "";
  int _targetCount = 0;
  bool _showDhikrInput = false;
  bool _showDhikrSelection = false;
  DhikrItem? _selectedDhikr;
  final TextEditingController _dhikrController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

  // Predefined dhikr list
  final List<DhikrItem> _dhikrList = [
    DhikrItem(text: "سُبْحَانَ اللَّهِ", suggestedCount: 33),
    DhikrItem(text: "اَلْحَمْدُ لِلّٰه", suggestedCount: 33),
    DhikrItem(text: "اَللهُ أَكْبَر", suggestedCount: 33),
    DhikrItem(text: "أَسْتَغْفِرُ الله", suggestedCount: 100),
    DhikrItem(
      text:
          "لَا إِلٰهَ إِلَّا أَنْتَ سُبْحانَکَ، إِنِّيْ کُنْتُ مِنَ الظَّالِمِیْنَ",
      suggestedCount: 100,
    ),
    DhikrItem(
      text: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِالله",
      suggestedCount: 100,
    ),
    DhikrItem(text: "لَا إِلٰهَ إِلَّا الله", suggestedCount: 100),
    DhikrItem(
      text:
          "رَبِّ اغْفِرْ لِيْ وَتُبْ عَلَيَّ، إنَّكَ أَنْتَ التَّوَّابُ الرَّحِيْمُ",
      suggestedCount: 100,
    ),
    DhikrItem(text: "سُبْحَانَ اللهِ وَبِحَمْدِه", suggestedCount: 100),
    DhikrItem(
      text:
          "سُبْحَانَ اللهِ، وَالْحَمْدُ لِلّٰهِ، وَلَا اِلٰهَ إِلَّا اللهُ، وَاللهُ أَكْبَر",
      suggestedCount: 100,
    ),
    DhikrItem(
      text:
          "اَللّٰهُمَّ اِغْفِرْ لِيْ ، وَارْحَمْنِي، وَاهْدِنِي، وَارْزُقْنِي",
      suggestedCount: 100,
    ),
    DhikrItem(
      text:
          "سُبْحَانَ اللهِ، وَالْحَمْدُ لِلّٰهِ، وَلَا اِلٰهَ إِلَّا اللهُ، وَاللهُ أَكْبَرُ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ",
      suggestedCount: 100,
    ),
    DhikrItem(
      text:
          "لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَعَلَىٰ كُلِّ شَىْءٍ قَدِيْرٌ",
      suggestedCount: 100,
    ),
    DhikrItem(
      text: "سُبْحَانَ اللهِ وَبِحَمْدِهِ، سُبْحَانَ اللهِ الْعَظِيْم",
      suggestedCount: 100,
    ),
    DhikrItem(
      text:
          "بِسْمِ اللهِ الَّذِيْ لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ، وَهُوَ السَّمِيْعُ الْعَلِيْمُ",
      suggestedCount: 3,
    ),
    DhikrItem(
      text: "يَا حَيُّ يَا قَيُّوْمُ بِرَحْمَتِكَ أَسْتَغِيْثُ",
      suggestedCount: 100,
    ),
    DhikrItem(
      text:
          "أَعُـوْذُ بِكَلِمَـاتِ اللهِ التَّـامَّـاتِ مِنْ شَـرِّ ما خَلَـقَ",
      suggestedCount: 3,
    ),
    DhikrItem(
      text: "سُوْرَةُ الإِخْلَاصِ، سُوْرَةُ الفَلَقِ، سُوْرَةُ النَّاسِ",
      suggestedCount: 3,
    ),
    DhikrItem(
      text:
          "اَللّٰهُمَّ أَعِنِّيْ عَلَىٰ ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ",
      suggestedCount: 100,
    ),
    DhikrItem(
      text:
          "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
      suggestedCount: 100,
    ),
    DhikrItem(
      text:
          "اَللّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ، وَعَلَىٰ آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيْمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيْدٌ مَّجِيْدٌ. اَللّٰهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ، وَعَلَىٰ آلِ مُحَمَّدٍ، كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيْمَ وَعَلَىٰ آلِ إِبْرَاهِيْمَ، إِنَّكَ حَمِيْدٌ مَّجِيْدٌ",
      suggestedCount: 100,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 0.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _controller.forward(from: 0.0);
    });

    // Show completion message if target reached (only if dhikr and target are set)
    if (_dhikrText.isNotEmpty && _targetCount > 0 && _counter == _targetCount) {
      _showCompletionDialog();
    }
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _toggleDhikrInput() {
    setState(() {
      _showDhikrInput = !_showDhikrInput;
      _showDhikrSelection = false;
      if (_showDhikrInput) {
        _dhikrController.text = _dhikrText;
        _targetController.text =
            _targetCount > 0 ? _targetCount.toString() : '';
        _targetController.clear();
        _dhikrController.clear();
      }
    });
  }

  void _toggleDhikrSelection() {
    setState(() {
      _showDhikrSelection = !_showDhikrSelection;
      _showDhikrInput = false;
    });
  }

  void _selectDhikr(DhikrItem dhikr) {
    setState(() {
      _selectedDhikr = dhikr;
      _dhikrText = dhikr.text;
      _targetCount = dhikr.suggestedCount ?? 0;
      _showDhikrSelection = false;
      _counter = 0; // Reset counter when selecting new dhikr
    });
  }

  void _showDhikrOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "اختر نوع الذكر",
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _toggleDhikrSelection();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "أذكار جاهزة",
                          style: context.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _toggleDhikrInput();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "ذكر مخصص",
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void _saveDhikr() {
    if (_dhikrController.text.trim().isNotEmpty) {
      setState(() {
        _dhikrText = _dhikrController.text.trim();
        _targetCount = int.tryParse(_targetController.text) ?? 0;
        _showDhikrInput = false;
        _counter = 0; // Reset counter when setting new dhikr
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "مبروك!",
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.celebration, color: Colors.green, size: 50),
                const SizedBox(height: 10),
                Text(
                  "لقد أكملت $_targetCount من $_dhikrText",
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("حسناً", style: context.textTheme.bodyLarge),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetCounter();
                },
                child: Text("ابدأ من جديد", style: context.textTheme.bodyLarge),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _dhikrController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("السبحة الإلكترونية"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // عرض الذكر الحالي والتقدم
            if (!_showDhikrInput && _dhikrText.isNotEmpty) ...[
              DhikrDisplayWidget(
                dhikrText: _dhikrText,
                currentCount: _counter,
                targetCount: _targetCount,
              ),
              const SizedBox(height: 30),
            ],

            // إدخال الذكر المخصص
            if (_showDhikrInput) ...[
              DhikrInputWidget(
                dhikrController: _dhikrController,
                targetController: _targetController,
                onSave: _saveDhikr,
              ),
              const SizedBox(height: 20),
            ],

            // اختيار الذكر من القائمة الجاهزة
            if (_showDhikrSelection) ...[
              DhikrSelectionWidget(
                dhikrList: _dhikrList,
                selectedDhikr: _selectedDhikr,
                onDhikrSelected: _selectDhikr,
                onCustomDhikr: () {
                  setState(() {
                    _showDhikrSelection = false;
                    _showDhikrInput = true;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],

            // دائرة السبحة الرئيسية
            SebhaCounterWidget(
              counter: _counter,
              animation: _animation,
              onTap: _incrementCounter,
            ),

            const SizedBox(height: 30),

            // نص إرشادي
            if (!_showDhikrInput)
              Text(
                "انقر على السبحة ",
                style: context.textTheme.titleLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).primaryColorDark,
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 30),

            // أزرار التحكم
            SebhaControlsWidget(
              onReset: _resetCounter,
              onSettings: _showDhikrOptions,
              hasCustomDhikr: _dhikrText.isNotEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
