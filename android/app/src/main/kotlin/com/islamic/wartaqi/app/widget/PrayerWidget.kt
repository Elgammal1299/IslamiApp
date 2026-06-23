package com.islamic.wartaqi.app.widget

import android.content.Context
import android.os.SystemClock
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.ImageProvider
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextAlign
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.islamic.wartaqi.app.R
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition

class PrayerWidget : GlanceAppWidget() {

    override val stateDefinition: GlanceStateDefinition<*>
        get() = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent { Content() }
    }

    @Composable
    private fun Content() {
        val prefs = currentState<HomeWidgetGlanceState>().preferences

        val nextPrayerName = prefs.getString("next_prayer_name", "--") ?: "--"
        val nextPrayerTime = prefs.getString("next_prayer_time", "--:--") ?: "--:--"

        // ── الحل الجوهري: احسب الـ countdown من الـ timestamp مباشرةً ──
        // Flutter بيبعت next_prayer_timestamp كـ epoch milliseconds
        val nextPrayerTimestamp = prefs.getLong("next_prayer_timestamp", 0L)
        val countdown = computeCountdown(nextPrayerTimestamp)

        val fajr    = prefs.getString("fajr",    "--:--") ?: "--:--"
        val sunrise = prefs.getString("sunrise", "--:--") ?: "--:--"
        val dhuhr   = prefs.getString("dhuhr",   "--:--") ?: "--:--"
        val asr     = prefs.getString("asr",     "--:--") ?: "--:--"
        val maghrib = prefs.getString("maghrib", "--:--") ?: "--:--"
        val isha    = prefs.getString("isha",    "--:--") ?: "--:--"

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(ImageProvider(R.drawable.widget_background))
                .padding(horizontal = 14.dp, vertical = 10.dp),
            contentAlignment = Alignment.Center
        ) {
            Column(
                modifier = GlanceModifier.fillMaxSize(),
                verticalAlignment = Alignment.Vertical.CenterVertically,
                horizontalAlignment = Alignment.Horizontal.CenterHorizontally
            ) {
                // ── Next Prayer Header ─────────────────────────────────────
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.Horizontal.CenterHorizontally,
                    verticalAlignment = Alignment.Vertical.CenterVertically
                ) {
                    Text(
                        text = "الصلاة القادمة: ",
                        style = TextStyle(
                            color = ColorProvider(Color(0xCCFFFFFF)),
                            fontSize = 12.sp,
                            textAlign = TextAlign.Center
                        )
                    )
                    Text(
                        text = "$nextPrayerName ($nextPrayerTime)",
                        style = TextStyle(
                            color = ColorProvider(Color(0xFFFFD700)),
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            textAlign = TextAlign.Center
                        )
                    )
                }

                Spacer(modifier = GlanceModifier.height(4.dp))

                // ── Countdown (محسوب natively من الـ timestamp) ──────────
                Text(
                    text = countdown,
                    style = TextStyle(
                        color = ColorProvider(Color.White),
                        fontSize = 24.sp,
                        fontWeight = FontWeight.Bold,
                        textAlign = TextAlign.Center
                    ),
                    modifier = GlanceModifier.fillMaxWidth()
                )

                Spacer(modifier = GlanceModifier.height(8.dp))

                // ── Divider ───────────────────────────────────────────────
                Box(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .height(1.dp)
                        .background(ColorProvider(Color(0x44FFFFFF)))
                ) {}

                Spacer(modifier = GlanceModifier.height(8.dp))

                // ── Prayer Times Grid ─────────────────────────────────────
                Row(modifier = GlanceModifier.fillMaxWidth()) {
                    PrayerCell(label = "الفجر",   time = fajr,    modifier = GlanceModifier.defaultWeight())
                    PrayerCell(label = "الشروق",  time = sunrise, modifier = GlanceModifier.defaultWeight())
                    PrayerCell(label = "الظهر",   time = dhuhr,   modifier = GlanceModifier.defaultWeight())
                }
                Spacer(modifier = GlanceModifier.height(8.dp))
                Row(modifier = GlanceModifier.fillMaxWidth()) {
                    PrayerCell(label = "العصر",   time = asr,     modifier = GlanceModifier.defaultWeight())
                    PrayerCell(label = "المغرب",  time = maghrib, modifier = GlanceModifier.defaultWeight())
                    PrayerCell(label = "العشاء",  time = isha,    modifier = GlanceModifier.defaultWeight())
                }
            }
        }
    }

    @Composable
    private fun PrayerCell(label: String, time: String, modifier: GlanceModifier) {
        Column(
            modifier = modifier,
            horizontalAlignment = Alignment.Horizontal.CenterHorizontally
        ) {
            Text(
                text = label,
                style = TextStyle(
                    color = ColorProvider(Color(0xAAFFFFFF)),
                    fontSize = 10.sp,
                    textAlign = TextAlign.Center
                )
            )
            Text(
                text = time,
                style = TextStyle(
                    color = ColorProvider(Color.White),
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Bold,
                    textAlign = TextAlign.Center
                )
            )
        }
    }

    companion object {
        /**
         * يحسب الـ countdown من الوقت الحالي حتى [targetEpochMs].
         * لو الوقت فات أو مش موجود، يرجع "--:--:--".
         * الـ Glance framework بيستدعي provideContent كل ما الـ widget يتحدث،
         * ولو الـ updatePeriodMillis = 1800000 (30 دقيقة)، فهيتحدث كل 30 دقيقة تلقائياً.
         *
         * للتحديث كل دقيقة، PrayerWidgetUpdateWorker بيشيدل الـ AlarmManager.
         */
        fun computeCountdown(targetEpochMs: Long): String {
            if (targetEpochMs <= 0L) return "--:--:--"
            val diffMs = targetEpochMs - System.currentTimeMillis()
            if (diffMs <= 0L) return "00:00:00"

            val totalSeconds = diffMs / 1000L
            val hours   = totalSeconds / 3600L
            val minutes = (totalSeconds % 3600L) / 60L
            val seconds = totalSeconds % 60L

            return "%02d:%02d:%02d".format(hours, minutes, seconds)
        }

        /** يُحدِّث كل instances من الـ widget فوراً */
        suspend fun updateAll(context: Context) {
            val manager = GlanceAppWidgetManager(context)
            val ids = manager.getGlanceIds(PrayerWidget::class.java)
            ids.forEach { id ->
                PrayerWidget().update(context, id)
            }
        }
    }
}