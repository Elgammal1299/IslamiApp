import 'package:flutter/material.dart';
import 'package:islami_app/core/extension/theme_text.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('عن التطبيق')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.mosque,
                      color: theme.colorScheme.secondary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'وَارْتَـــقِ',
                        style: context.textTheme.titleLarge!.copyWith(
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        'منصة إسلامية للقراءة، الاستماع، الذِّكر والتدبر',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Divider(color: Theme.of(context).colorScheme.outlineVariant),
              const SizedBox(height: 8),
              Text('المزايا الرئيسية', style: textTheme.titleLarge),
              const SizedBox(height: 12),
              const _FeatureItem(
                title: 'القرآن الكريم',
                subtitle: 'تصفح السور، البحث، الحفظ والمتابعة، وعرض التفسير.',
              ),
              const _FeatureItem(
                title: 'التلاوات الصوتية',
                subtitle:
                    'استماع للتلاوات، شاشة “الآن يُشغّل”، وتنزيل المقاطع للاستخدام دون اتصال.',
              ),
              const _FeatureItem(
                title: 'الأذكار والدعاء',
                subtitle: 'أذكار اليوم والليلة وعرض منسق.',
              ),
              const _FeatureItem(
                title: 'الحديث الشريف',
                subtitle: 'عرض الأحاديث وتفاصيلها بسهولة.',
              ),
              const _FeatureItem(
                title: 'أوقات الصلاة والقبلة',
                subtitle: 'عرض مواقيت الصلاة واتجاه القبلة باستخدام الموقع.',
              ),
              const _FeatureItem(
                title: 'الراديو الإسلامي',
                subtitle: 'استمع إلى قنوات الراديو الإسلامية مباشرة.',
              ),
              const _FeatureItem(
                title: 'السبحة',
                subtitle: 'عداد أذكار بسيط مع تحكم سريع.',
              ),
              const _FeatureItem(
                title: 'الإشعارات',
                subtitle: 'استقبال تنبيهات مخصّصة عبر خدمة الرسائل السحابية.',
              ),
              const _FeatureItem(
                title: 'الوضع الليلي',
                subtitle: 'تبديل سريع بين الوضع الفاتح والداكن.',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FeatureItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
