package com.islamic.wartaqi.app.widget

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.SystemClock
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * BroadcastReceiver يستقبل alarm كل دقيقة لتحديث الـ widget countdown.
 *
 * لماذا AlarmManager وليس WorkManager؟
 *   - WorkManager له حد أدنى 15 دقيقة كـ interval.
 *   - AlarmManager.setWindow يتيح لنا تحديث كل دقيقة بكفاءة.
 *   - الـ Widget بيحتاج countdown دقيق (ثانية بثانية مش مهم، لكن دقيقة بدقيقة مهم).
 *
 * دورة الحياة:
 *   - PrayerGlanceReceiver.onUpdate  ← يُشغّل scheduleMinuteUpdates
 *   - PrayerGlanceReceiver.onDisabled ← يلغي الـ alarm
 *   - BOOT_COMPLETED ← يعيد جدولة الـ alarm
 */
class PrayerWidgetUpdateReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ACTION_UPDATE_WIDGET,
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED -> {
                Log.d(TAG, "onReceive: ${intent.action} → updating widget")
                // شغّل coroutine لتحديث الـ widget
                val pendingResult = goAsync()
                CoroutineScope(Dispatchers.Main).launch {
                    try {
                        PrayerWidget.updateAll(context)
                    } catch (e: Exception) {
                        Log.e(TAG, "Failed to update widget", e)
                    } finally {
                        pendingResult.finish()
                    }
                }
                // أعد جدولة الـ alarm للدقيقة القادمة
                scheduleMinuteUpdates(context)
            }
        }
    }

    companion object {
        private const val TAG = "PrayerWidgetUpdate"
        const val ACTION_UPDATE_WIDGET = "com.islamic.wartaqi.app.WIDGET_MINUTE_UPDATE"
        private const val REQUEST_CODE = 9001

        /**
         * يُجدوِل alarm كل ~60 ثانية لتحديث الـ widget.
         * يُستدعى من:
         *   1. PrayerGlanceReceiver.onUpdate (أول مرة)
         *   2. PrayerWidgetUpdateReceiver.onReceive (تكرار ذاتي)
         *   3. بعد BOOT_COMPLETED
         */
        fun scheduleMinuteUpdates(context: Context) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val pendingIntent = getUpdatePendingIntent(context)

            // نحسب بداية الدقيقة القادمة (مزامنة مع الساعة)
            val now = System.currentTimeMillis()
            val nextMinute = now + (60_000L - (now % 60_000L))

            try {
                // setWindow: inexact لكن كفاءة أعلى للبطارية
                // التحديث سيحدث في نافذة مدتها 10 ثواني حول الدقيقة القادمة
                alarmManager.setWindow(
                    AlarmManager.RTC,
                    nextMinute,
                    10_000L, // نافذة 10 ثواني
                    pendingIntent
                )
                Log.d(TAG, "Alarm scheduled for next minute: $nextMinute")
            } catch (e: SecurityException) {
                Log.e(TAG, "Failed to schedule alarm (SecurityException)", e)
                // Fallback: set inexact alarm
                alarmManager.set(AlarmManager.RTC, nextMinute, pendingIntent)
            }
        }

        /**
         * يلغي الـ alarm عند إزالة كل الـ widgets من الشاشة.
         */
        fun cancelMinuteUpdates(context: Context) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val pendingIntent = getUpdatePendingIntent(context)
            alarmManager.cancel(pendingIntent)
            Log.d(TAG, "Alarm cancelled")
        }

        private fun getUpdatePendingIntent(context: Context): PendingIntent {
            val intent = Intent(context, PrayerWidgetUpdateReceiver::class.java).apply {
                action = ACTION_UPDATE_WIDGET
            }
            return PendingIntent.getBroadcast(
                context,
                REQUEST_CODE,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        }
    }
}