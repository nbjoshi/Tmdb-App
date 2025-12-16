//
//  FinalProjectWidget.swift
//  FinalProjectWidget
//
//  Created by Neel Joshi on 4/28/25.
//

import SwiftData
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in _: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date(), emoji: "🙂")

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct FinalProjectWidgetEntryView: View {
    @Query() var items: [WidgetModel]
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            if items.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.yellow)

                    Text("No Trending Data")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                }
                .padding()
                .foregroundStyle(.white)
                .containerBackground(.blue.gradient, for: .widget)
            } else {
                switch family {
                case .systemSmall:
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Trending 🔥")
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.primary)

                        Divider()

                        if let first = items.first {
                            HStack(spacing: 4) {
                                Image(systemName: "play.rectangle.fill")
                                    .resizable()
                                    .frame(width: 12, height: 12)

                                Text(first.displayName ?? "Unknown")
                                    .font(.caption)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                    .foregroundStyle(.primary)
                            }
                            Text("(\(first.mediaType))")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .containerBackground(.blue.gradient, for: .widget)

                case .systemMedium:
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Trending 🔥")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.primary)

                        Divider().background(Color.white.opacity(0.6))

                        ForEach(items.prefix(3)) { item in
                            HStack(spacing: 6) {
                                Image(systemName: "play.rectangle.fill")
                                    .resizable()
                                    .frame(width: 14, height: 14)

                                Text(item.displayName ?? "Unknown")
                                    .font(.callout)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                    .foregroundStyle(.primary)

                                Text("(\(item.mediaType))")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding()
                    .containerBackground(.blue.gradient, for: .widget)

                default:
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Trending 🔥")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.primary)

                        Divider().background(Color.white.opacity(0.6))

                        ForEach(items.prefix(5)) { item in
                            HStack(spacing: 8) {
                                Image(systemName: "play.rectangle.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)

                                Text(item.displayName ?? "Unknown")
                                    .font(.callout)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                    .foregroundStyle(.primary)

                                Text("(\(item.mediaType))")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .containerBackground(.blue.gradient, for: .widget)
                }
            }
        }
    }
}

struct FinalProjectWidget: Widget {
    let kind: String = "FinalProjectWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FinalProjectWidgetEntryView(entry: entry)
                .modelContainer(for: WidgetModel.self)
        }
        .configurationDisplayName("Timestamp Widget")
        .description("View the most recent timestamp in your list.")
    }
}

#Preview(as: .systemSmall) {
    FinalProjectWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
