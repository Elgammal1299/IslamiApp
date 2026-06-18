import WidgetKit
import SwiftUI

struct PrayerEntry: TimelineEntry {
    let date: Date
    let fajr: String
    let dhuhr: String
    let asr: String
    let maghrib: String
    let isha: String
    let sunrise: String
    let nextPrayerName: String
    let countdown: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PrayerEntry {
        PrayerEntry(date: Date(), fajr: "--:--", dhuhr: "--:--", asr: "--:--", maghrib: "--:--", isha: "--:--", sunrise: "--:--", nextPrayerName: "--", countdown: "00:00:00")
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerEntry) -> ()) {
        completion(getEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PrayerEntry>) -> ()) {
        let entry = getEntry()
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func getEntry() -> PrayerEntry {
        let userDefaults = UserDefaults(suiteName: "group.com.islamic.wartaqi.app")
        return PrayerEntry(
            date: Date(),
            fajr: userDefaults?.string(forKey: "fajr") ?? "--:--",
            dhuhr: userDefaults?.string(forKey: "dhuhr") ?? "--:--",
            asr: userDefaults?.string(forKey: "asr") ?? "--:--",
            maghrib: userDefaults?.string(forKey: "maghrib") ?? "--:--",
            isha: userDefaults?.string(forKey: "isha") ?? "--:--",
            sunrise: userDefaults?.string(forKey: "sunrise") ?? "--:--",
            nextPrayerName: userDefaults?.string(forKey: "next_prayer_name") ?? "--",
            countdown: userDefaults?.string(forKey: "countdown") ?? "00:00:00"
        )
    }
}

struct PrayerWidgetEntryView : View {
    var entry: PrayerEntry

    var body: some View {
        VStack(spacing: 6) {
            VStack(spacing: 2) {
                Text(entry.nextPrayerName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.yellow)
                Text(entry.countdown)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
            }
            
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(height: 1)
                .padding(.vertical, 4)
            
            VStack(spacing: 8) {
                HStack {
                    PrayerItem(name: "الفجر", time: entry.fajr)
                    Spacer()
                    PrayerItem(name: "الظهر", time: entry.dhuhr)
                    Spacer()
                    PrayerItem(name: "العصر", time: entry.asr)
                }
                HStack {
                    PrayerItem(name: "المغرب", time: entry.maghrib)
                    Spacer()
                    PrayerItem(name: "العشاء", time: entry.isha)
                    Spacer()
                    PrayerItem(name: "الشروق", time: entry.sunrise)
                }
            }
        }
        .padding(12)
        .containerBackground(for: .widget) {
            LinearGradient(colors: [Color(hex: "23176D"), Color(hex: "0C222B")], startPoint: .top, endPoint: .bottom)
        }
    }
}

struct PrayerItem: View {
    let name: String
    let time: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(name)
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.7))
            Text(time)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(minWidth: 40)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

@main
struct PrayerWidget: Widget {
    let kind: String = "PrayerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PrayerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("مواقيت الصلاة")
        .description("خلفية مواقيت الصلاة من تطبيق وَارْتَــقِ.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
