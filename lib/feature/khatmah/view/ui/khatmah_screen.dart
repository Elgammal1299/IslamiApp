import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami_app/core/constant/app_color.dart';
import 'package:islami_app/core/extension/theme_text.dart';
import 'package:islami_app/feature/khatmah/utils/khatmah_constants.dart';
import 'package:intl/intl.dart';
import 'package:islami_app/feature/khatmah/view_model/khatmah_cubit.dart';

class CreateKhatmahScreen extends StatefulWidget {
  const CreateKhatmahScreen({super.key});

  @override
  State<CreateKhatmahScreen> createState() => _CreateKhatmahScreenState();
}

class _CreateKhatmahScreenState extends State<CreateKhatmahScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  int _selectedDuration = 30; // القيمة الافتراضية
  bool _isCustomDuration = false;
  DateTime _selectedStartDate = DateTime.now();
  TimeOfDay? _notificationTime = const TimeOfDay(hour: 16, minute: 0);
  bool _isNotificationEnabled = true;

  final _customDaysController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _customDaysController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  Widget _buildDurationItem({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? Colors.white : Colors.grey,
              size: 18.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              title,
              style: context.textTheme.bodyLarge!.copyWith(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectNotificationTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime ?? const TimeOfDay(hour: 20, minute: 0),
    );

    if (picked != null) {
      setState(() {
        _notificationTime = picked;
      });
    }
  }

  void _createKhatmah() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();

      final int totalDays =
          _isCustomDuration
              ? (int.tryParse(_customDaysController.text) ?? 30)
              : _selectedDuration;

      context.read<KhatmahCubit>().createKhatmah(
        name: name,
        totalDays: totalDays,
        startDate: _selectedStartDate,

        notificationTime:
            _notificationTime != null
                ? DateTime(
                  0,
                  0,
                  0,
                  _notificationTime!.hour,
                  _notificationTime!.minute,
                )
                : null,
        isNotificationEnabled: _isNotificationEnabled,
      );

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إنشاء الختمة بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd', 'ar');

    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء ختمة جديدة'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // اسم الختمة
              Text('اسم الختمة', style: context.textTheme.titleMedium),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'مثال: ختمة رمضان',
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'من فضلك أدخل اسم الختمة';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10.h),

              // المدة
              Text(
                'مدة الختمة',
                style: context.textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              ...KhatmahConstants.defaultDurations.map(
                (duration) => RadioListTile<int>(
                  value: duration,
                  groupValue: _selectedDuration,
                  onChanged: (value) {
                    setState(() {
                      _selectedDuration = value!;
                    });
                  },
                  title: Text(
                    KhatmahConstants.durationNames[duration]!,
                    style: context.textTheme.bodyLarge,
                  ),
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
              ),

              SizedBox(height: 24.h),

              // تاريخ البداية
              Text(
                'تاريخ البداية',
                style: context.textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () => _selectStartDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            dateFormat.format(_selectedStartDate),
                            style: context.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // معلومات إضافية
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'ملخص الختمة',
                          style: context.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _buildInfoRow(
                      'المدة:',
                      '$_selectedDuration يوم',
                    ),
                    _buildInfoRow(
                      'تاريخ البداية:',
                      dateFormat.format(_selectedStartDate),
                    ),
                    _buildInfoRow(
                      'تاريخ الانتهاء المتوقع:',
                      dateFormat.format(
                        _selectedStartDate.add(
                          Duration(
                            days:
                                (_isCustomDuration
                                    ? (int.tryParse(
                                          _customDaysController.text,
                                        ) ??
                                        1)
                                    : _selectedDuration) -
                                1,
                          ),
                        ),
                      ),
                    ),
                    _buildInfoRow(
                      'عدد الأجزاء يومياً:',
                      '${(30 / (_isCustomDuration ? (double.tryParse(_customDaysController.text) ?? 30) : _selectedDuration)).toStringAsFixed(1)} جزء',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
