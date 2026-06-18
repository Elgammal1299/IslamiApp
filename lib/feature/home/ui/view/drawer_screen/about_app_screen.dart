import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/home/ui/view/drawer_screen/widget/custom_feature_item.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('عن التطبيق'),centerTitle: true,
      foregroundColor: Theme.of(context).primaryColorDark,
      backgroundColor: Theme.of(context).cardColor,),
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
                    child: Image.asset(AppImage.splashImageDark,),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'وَارْتَـــقِ',
                        style: context.textTheme.titleLarge!.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Amiri',
                        ),
                      ),
                      Text(
                        'منصة إسلامية للقراءة، الاستماع، الذِّكر والتدبر',
                        style: textTheme.bodyMedium!.copyWith(
                          fontSize: 18,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Divider(color: Theme.of(context).colorScheme.outlineVariant),
              const SizedBox(height: 8),
              Text('المزايا الرئيسية', style: textTheme.titleLarge!.copyWith(fontFamily: 'Amiri', fontSize: 22.sp)),
              const SizedBox(height: 12),
              const CustomFeatureItem(
                title: 'القرآن الكريم',
                subtitle: 'تصفح السور، البحث، الحفظ والمتابعة، وعرض التفسير.',
              ),
              const CustomFeatureItem(
                title: 'التلاوات الصوتية',
                subtitle:
                    'استماع للتلاوات، شاشة “الآن يُشغّل”، وتنزيل المقاطع للاستخدام دون اتصال.',
              ),
              const CustomFeatureItem(
                title: 'الأذكار والدعاء',
                subtitle: 'أذكار اليوم والليلة وعرض منسق.',
              ),
              const CustomFeatureItem(
                title: 'الحديث الشريف',
                subtitle: 'عرض الأحاديث وتفاصيلها بسهولة.',
              ),
              const CustomFeatureItem(
                title: 'أوقات الصلاة والقبلة',
                subtitle: 'عرض مواقيت الصلاة واتجاه القبلة باستخدام الموقع.',
              ),
              const CustomFeatureItem(
                title: 'الراديو الإسلامي',
                subtitle: 'استمع إلى قنوات الراديو الإسلامية مباشرة.',
              ),
              const CustomFeatureItem(
                title: 'السبحة',
                subtitle: 'عداد أذكار بسيط مع تحكم سريع.',
              ),
              const CustomFeatureItem(
                title: 'الإشعارات',
                subtitle: 'استقبال تنبيهات مخصّصة عبر خدمة الرسائل السحابية.',
              ),
              const CustomFeatureItem(
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
