//
//  BeerMais_widget.swift
//  BeerMais widget
//
//  Created by José Neves on 01/11/20.
//  Copyright © 2020 joseneves. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    brand: nil,
                    amount: nil,
                    value: nil,
                    type: nil,
                    economy: nil,
                    count: 0,
                    configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent,
                     in context: Context,
                     completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                brand: nil,
                                amount: nil,
                                value: nil,
                                type: nil,
                                economy: nil,
                                count: 0,
                                configuration: ConfigurationIntent())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent,
                     in context: Context,
                     completion: @escaping (Timeline<Entry>) -> ()) {
        let defaults = UserDefaults(suiteName: "group.beerMais")
        let brand = defaults?.string(forKey: "BRAND")
        let amount = defaults?.string(forKey: "AMOUNT")
        let value = defaults?.string(forKey: "VALUE")
        let type = defaults?.string(forKey: "TYPE")
        let economy = defaults?.string(forKey: "ECONOMY")
        let count = defaults?.integer(forKey: "BEERS_COUNT") ?? 0
        
        let timeline = Timeline(entries: [
                                    SimpleEntry(date: Date(),
                                                brand: brand,
                                                amount: amount,
                                                value: value,
                                                type: type,
                                                economy: economy,
                                                count: count,
                                                configuration: configuration)
        ], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let brand: String?
    let amount: String?
    let value: String?
    let type: String?
    let economy: String?
    let count: Int
    let configuration: ConfigurationIntent
}

struct BeerMais_widgetEntryView : View {
    var entry: Provider.Entry
    
    var border: some View {
        RoundedRectangle(cornerRadius: 22)
            .stroke(Color(
                UIColor(named: "economyBorder")!
            ), lineWidth: entry.count < 2 ? 0 : 4)
    }
    
    var backgroundColor: some View {
        var uiColor = UIColor.tertiarySystemBackground
        if entry.count >= 2  {
            uiColor = UIColor(named: "economyBackground")!
        }
        return Color(uiColor).edgesIgnoringSafeArea(.all)
    }

    var body: some View {
        ZStack {
            backgroundColor
            VStack(spacing: 0) {
                Spacer()
                Text(entry.brand ?? "Marca")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .foregroundColor(Color(UIColor.label))
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
                    .frame(maxWidth: .infinity,
                           maxHeight: 20,
                           alignment: .center)
                HStack {
                    Spacer()
                    VStack {
                        Image(Int(entry.type ?? "1") == 1 ? "icons8-beer-can-100" : "icons8-beer-bottle-100")
                            .renderingMode(.template)
                            .resizable()
                            .padding(.bottom, -8)
                            .scaledToFit()
                            .frame(width: 50.0, height: 50.0)
                            .foregroundColor(Color(
                                UIColor(named: "black-white")!
                            ))
                        Text(entry.amount ?? "350ml")
                            .font(.system(size: 16))
                            .foregroundColor(Color(UIColor.label))
                    }
                    Spacer()
                    VStack {
                        Text(entry.value ?? "RS 0,00")
                            .font(.system(size: 20))
                            .fontWeight(.regular)
                            .frame(maxWidth: .infinity,
                                   maxHeight: 20,
                                   alignment: .center)
                            .foregroundColor(Color(UIColor.label))
                        Text(entry.economy ?? "R$ 0,00/L")
                            .font(.system(size: 13))
                            .fontWeight(.regular)
                            .frame(maxWidth: .infinity,
                                   maxHeight: 20,
                                   alignment: .center)
                            .foregroundColor(Color(
                                UIColor(named: "economyBorder")!
                            ))
                    }
                    Spacer()
                }.frame(maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .leading)
            }.overlay(border)
        }
    }
}

@main
struct BeerMais_widget: Widget {
    let kind: String = "BeerMais_widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: ConfigurationIntent.self,
                            provider: Provider()) { entry in
            BeerMais_widgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Beer Mais Widget")
        .description("Widget de destaque a bebida mais barata.")
    }
}

struct BeerMais_widget_Previews: PreviewProvider {
    static var previews: some View {
        BeerMais_widgetEntryView(entry: SimpleEntry(date: Date(),
                                                    brand: nil,
                                                    amount: nil,
                                                    value: nil,
                                                    type: nil,
                                                    economy: nil,
                                                    count: 0,
                                                    configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
