import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/ui/view/widget/dhikr_display_widget.dart';
import 'package:islami_app/feature/home/ui/view/widget/dhikr_input_widget.dart';
import 'package:islami_app/feature/home/ui/view/widget/sebha_counter_widget.dart';
import 'package:islami_app/feature/home/ui/view/widget/sebha_controls_widget.dart';

class SebhaPage extends StatefulWidget {
  const SebhaPage({super.key});

  @override
  State<SebhaPage> createState() => _SebhaPageState();
}

class _SebhaPageState extends State<SebhaPage>
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
