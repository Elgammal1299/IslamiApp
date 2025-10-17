import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/ui/view/widget/dhikr_display_widget.dart';
import 'package:islami_app/feature/home/ui/view/widget/dhikr_input_widget.dart';
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
  final TextEditingController _dhikrController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();

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
      if (_showDhikrInput) {
        _dhikrController.text = _dhikrText;
        _targetController.text =
            _targetCount > 0 ? _targetCount.toString() : '';
      }
    });
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
                "انقر على الدائرة للتسبيح",
                style: context.textTheme.titleLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 30),

            // أزرار التحكم
            SebhaControlsWidget(
              onReset: _resetCounter,
              onSettings: _toggleDhikrInput,
              hasCustomDhikr: _dhikrText.isNotEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
// [
//     {
//         "dikr": "سُبْحَانَ اللَّهِ"
//     },
//     {
//         "dikr": "اَلْحَمْدُ لِلّٰه"
//     },
//     {
//         "dikr": "اَللهُ أَكْبَر"
//     },
//     {
//         "dikr": "أَسْتَغْفِرُ الله"
//     },
//     {
//         "dikr": "لَا إِلٰهَ إِلَّا أَنْتَ سُبْحانَکَ، إِنِّيْ کُنْتُ مِنَ الظَّالِمِیْنَ"
//     },
//     {
//         "dikr": "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِالله"
//     },
//     {
//         "dikr": "سُبْحَانَ اللَّهِ"
//     },
//     {
//         "dikr": "لَا إِلٰهَ إِلَّا الله"
//     },
//     {
//         "dikr": "رَبِّ اغْفِرْ لِيْ وَتُبْ عَلَيَّ، إنَّكَ أَنْتَ التَّوَّابُ الرَّحِيْمُ"
//     },
//     {
//         "dikr": "سُبْحَانَ اللهِ وَبِحَمْدِه"
//     },
//     {
//         "dikr": "سُبْحَانَ اللهِ وَبِحَمْدِه"
//     },
//     {
//         "dikr": "سُبْحَانَ اللهِ، وَالْحَمْدُ لِلّٰهِ، وَلَا اِلٰهَ إِلَّا اللهُ، وَاللهُ أَكْبَر"
//     },
//     {
//         "dikr": "سُبْحَانَ اللهِ، وَالْحَمْدُ لِلّٰهِ، وَلَا اِلٰهَ إِلَّا اللهُ، وَاللهُ أَكْبَر"
//     },
//     {
//         "dikr": "اَللّٰهُمَّ اِغْفِرْ لِيْ ، وَارْحَمْنِي، وَاهْدِنِي، وَارْزُقْنِي"
//     },
//     {
//         "dikr":"سُبْحَانَ اللهِ، وَالْحَمْدُ لِلّٰهِ، وَلَا اِلٰهَ إِلَّا اللهُ، وَاللهُ أَكْبَرُ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ"
//     },
//     {
//         "dikr":"لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، لَهُ الْمُلْكُ، وَلَهُ الْحَمْدُ، وَهُوَعَلَىٰ كُلِّ شَىْءٍ قَدِيْرٌ"
//     },
//     {
//         "dikr":"سُبْحَانَ اللهِ وَبِحَمْدِهِ، سُبْحَانَ اللهِ الْعَظِيْم"
//     },
//     {
//         "dikr":"بِسْمِ اللهِ الَّذِيْ لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ، وَهُوَ السَّمِيْعُ الْعَلِيْمُ"
//     },
//     {
//         "dikr":"يَا حَيُّ يَا قَيُّوْمُ بِرَحْمَتِكَ أَسْتَغِيْثُ"
//     },
//     {
//         "dikr":"أَعُـوْذُ بِكَلِمَـاتِ اللهِ التَّـامَّـاتِ مِنْ شَـرِّ ما خَلَـقَ"
//     },
//     {
//         "dikr":"سُوْرَةُ الإِخْلَاصِ، سُوْرَةُ الفَلَقِ، سُوْرَةُ النَّاسِ"
//     },
//     {
//         "dikr":"اَللّٰهُمَّ أَعِنِّيْ عَلَىٰ ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ"
//     }
//     ,
//     {
//         "dikr":"رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ"
//     },
//     {
//         "dikr":"اَللّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ، وَعَلَىٰ آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيْمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيْدٌ مَّجِيْدٌ. اَللّٰهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ، وَعَلَىٰ آلِ مُحَمَّدٍ، كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيْمَ وَعَلَىٰ آلِ إِبْرَاهِيْمَ، إِنَّكَ حَمِيْدٌ مَّجِيْدٌ"
//     }

// ]
