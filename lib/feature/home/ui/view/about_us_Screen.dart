import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:islami_app/core/constant/app_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('عن المطور')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     const CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage(AppImage.ahmedImage),
                      
                    ),
                      SizedBox(height: 12.h),
                    Text(
                      'أحمد محمد الجمال',
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize: 24.sp,
                        fontFamily: 'Amiri',
                      ),
                    ),
                      SizedBox(height: 4.h),
                    Text(
                      'مطور تطبيقات الموبيل',
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     CircleAvatar(
              //       radius: 28,
              //       backgroundColor: theme.colorScheme.primary,
              //       child: Icon(
              //         Icons.mosque,
              //         color: theme.colorScheme.secondary,
              //         size: 28,
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text('وَارْتَـــقِ', style: textTheme.titleLarge),
              //         Text(
              //           'منصة إسلامية للقراءة، الاستماع، الذِّكر والتدبر',
              //           style: textTheme.bodyMedium,
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 16),
              // Divider(color: theme.colorScheme.outlineVariant),
              const SizedBox(height: 8),
              Text('رسالتنا', style: textTheme.titleLarge!.copyWith(fontFamily: 'Amiri', fontSize: 22.sp)),
              const SizedBox(height: 6),
              Text(
                'نسعى لتقديم تجربة رقمية موثوقة وسهلة تُعين المسلم على تلاوة القرآن، سماع التلاوات، التذكير بالأذكار، والتعرّف على السنّة في واجهة عربية أنيقة.',
                style: textTheme.bodyMedium!.copyWith(fontFamily: 'Amiri', fontSize: 18.sp),
              ),
              const SizedBox(height: 8),
              Text('رؤيتنا', style: textTheme.titleLarge!.copyWith(fontFamily: 'Amiri', fontSize: 22.sp)),
              const SizedBox(height: 8),
              Text(
                'أن تكون “وَارْتَـــقِ” رفيقك اليومي في الطاعة، مع محتوى موثّق وأداء سريع ودعم دون اتصال.',
                style: textTheme.bodyMedium!.copyWith(fontFamily: 'Amiri', fontSize: 18.sp),
              ),
              // const SizedBox(height: 16),

              // Divider(color: theme.colorScheme.outlineVariant),
              const SizedBox(height: 8),
              Text('تواصل معنا', style: textTheme.titleLarge!.copyWith(fontFamily: 'Amiri', fontSize: 22.sp)),
              const SizedBox(height: 8),
              Text(
                'لأي استفسارات أو اقتراحات او مشاكل، لا تتردد في التواصل معنا عبر واتس أب أو تليجرام.',
                style: textTheme.bodyMedium!.copyWith(fontFamily: 'Amiri', fontSize: 18.sp),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  await launchUrlString(
                    'https://wa.me/+201270549994?text=السلام عليكم\nانا قادم من تطبيق وارتقي',
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Container(
                  width: 200.w,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 16.w,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'تواصل واتس أب',
                        style: textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),

                      SvgPicture.asset(AppImage.whatsIcon),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () async {
                  await launchUrlString(
                    'https://t.me/GAMY2003?text=السلام عليكم\nانا قادم من تطبيق وارتقي',
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Container(
                  width: 200.w,

                  decoration: BoxDecoration(
                    color: Colors.blue, // لون تليجرام
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 16.w,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'تواصل عبر تليجرام',
                        style: textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                                            const Spacer(),


                      SvgPicture.asset(AppImage.telegramIcon),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () async {
                  await launchUrlString(
                    'https://www.facebook.com/share/1AwZPvGyyy/',
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Container(
                  width: 200.w,

                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 3, 134, 242), // لون تليجرام
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 16.w,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'الفيس بوك',
                        style: textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.facebook,
                        color: Colors.white,
                        size: 24,
                      ),
                      // SvgPicture.asset(AppImage.telegramIcon),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
