package com.islamic.wartaqi.app.widget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.util.Log
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver

/**
 * الـ Receiver الرئيسي للـ widget.
 * - onUpdate: يُطلق تحديث فوري ويُجدول alarm للتحديث كل دقيقة
 * - onDisabled: يلغي الـ alarm لما يُزال آخر widget من الشاشة
 */
class PrayerGlanceReceiver : HomeWidgetGlanceWidgetReceiver<PrayerWidget>() {

    override val glanceAppWidget = PrayerWidget()

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        Log.d(TAG, "onUpdate: scheduling minute alarms")
        // جدوِل الـ alarm الدقيقي لتحديث الـ countdown
        PrayerWidgetUpdateReceiver.scheduleMinuteUpdates(context)
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        Log.d(TAG, "onDisabled: cancelling minute alarms")
        // لما يُزال كل الـ widgets، ألغِ الـ alarm توفيراً للبطارية
        PrayerWidgetUpdateReceiver.cancelMinuteUpdates(context)
    }

    companion object {
        private const val TAG = "PrayerGlanceReceiver"
    }
}