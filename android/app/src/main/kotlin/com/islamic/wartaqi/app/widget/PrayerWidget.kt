package com.islamic.wartaqi.app.widget

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.ImageProvider
import androidx.glance.appwidget.GlanceAppWidget
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

        val nextPrayerName     = prefs.getString("next_prayer_name", "--") ?: "--"
        val nextPrayerTime     = prefs.getString("next_prayer_time", "--:--") ?: "--:--"
        val countdown          = prefs.getString("countdown", "--:--:--") ?: "--:--:--"

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

                // ── Countdown ─────────────────────────────────────────────
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
                    PrayerCell(label = "الفجر", time = fajr, modifier = GlanceModifier.defaultWeight())
                    PrayerCell(label = "الشروق", time = sunrise, modifier = GlanceModifier.defaultWeight())
                    PrayerCell(label = "الظهر", time = dhuhr, modifier = GlanceModifier.defaultWeight())
                }
                Spacer(modifier = GlanceModifier.height(8.dp))
                Row(modifier = GlanceModifier.fillMaxWidth()) {
                    PrayerCell(label = "العصر", time = asr, modifier = GlanceModifier.defaultWeight())
                    PrayerCell(label = "المغرب", time = maghrib, modifier = GlanceModifier.defaultWeight())
                    PrayerCell(label = "العشاء", time = isha, modifier = GlanceModifier.defaultWeight())
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
}
