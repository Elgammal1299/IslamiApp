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
  DateTime _selectedStartDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
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
            colorScheme: ColorScheme.light(
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

  void _createKhatmah() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();

      context.read<KhatmahCubit>().createKhatmah(
        name: name,
        totalDays: _selectedDuration,
        startDate: _selectedStartDate,
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
      appBar: AppBar(
        title: const Text('إنشاء ختمة جديدة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // أيقونة القرآن
              Center(
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.book,
                    size: 64.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // اسم الختمة
              Text(
                'اسم الختمة',
                style: context.textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'مثال: ختمة رمضان 2024',
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'من فضلك أدخل اسم الختمة';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24.h),

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
                      Icon(
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
                  color: AppColors.secondary.withOpacity(0.3),
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
                          Duration(days: _selectedDuration - 1),
                        ),
                      ),
                    ),
                    _buildInfoRow(
                      'عدد الأجزاء يومياً:',
                      '${(30 / _selectedDuration).toStringAsFixed(1)} جزء',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // زر الإنشاء
              ElevatedButton(
                onPressed: _createKhatmah,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'إنشاء الختمة',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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