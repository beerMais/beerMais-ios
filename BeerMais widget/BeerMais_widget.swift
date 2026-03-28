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


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> BeerMaisEntry {
        buildBeerMaisEntry()
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (BeerMaisEntry) -> ()
    ) {
        completion(buildBeerMaisEntry())
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> ()
    ) {
        guard
            !context.isPreview,
            context.family == .systemSmall
        else {
            completion(Timeline(
                entries: [
                    buildBeerMaisEntry()
                ],
                policy: .never
            ))
            return
        }
        
        let defaults = UserDefaults(suiteName: "group.beerMais")
        completion(Timeline(
            entries: [
                BeerMaisEntry(
                    date: Date(),
                    brand: defaults?.string(forKey: "BRAND"),
                    amount: defaults?.string(forKey: "AMOUNT"),
                    value: defaults?.string(forKey: "VALUE"),
                    type: defaults?.string(forKey: "TYPE"),
                    economy: defaults?.string(forKey: "ECONOMY"),
                    count: defaults?.integer(forKey: "BEERS_COUNT") ?? 0
                )
            ],
            policy: .never
        ))
    }
    
    private func buildBeerMaisEntry(
        brand: String? = nil,
        amount: String? = nil,
        value: String? = nil,
        type: String? = nil,
        economy: String? = nil,
        count: Int = 0
    ) -> BeerMaisEntry {
        BeerMaisEntry(
            date: Date(),
            brand: brand,
            amount: amount,
            value: value,
            type: type,
            economy: economy,
            count: count
        )
    }
}

struct BeerMaisEntry: TimelineEntry {
    let date: Date
    let brand: String?
    let amount: String?
    let value: String?
    let type: String?
    let economy: String?
    let count: Int
}

struct BeerMais_widgetEntryView : View {
    var entry: Provider.Entry
    
    var backgroundColor: some View {
        var uiColor = UIColor.tertiarySystemBackground
        if entry.count >= 2  {
            uiColor = UIColor(named: "economyBackground")!
        }
        return Color(uiColor).edgesIgnoringSafeArea(.all)
    }

    var body: some View {
        ZStack {
            VStack {
                Text(entry.brand ?? "Marca")
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .foregroundColor(Color(UIColor.label))
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: 20,
                        alignment: .center
                    )
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
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            if entry.count >= 2  {
                Color("economyBackground")
            } else {
                Color(UIColor.tertiarySystemBackground)
            }
        }
        .clipShape(ContainerRelativeShape())
        .overlay {
            if entry.count >= 2 {
                ContainerRelativeShape()
                        .strokeBorder(Color("economyBorder"), lineWidth: 3)
            }
        }
    }
}

@main
struct BeerMais_widget: Widget {
    let kind: String = "BeerMais_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            BeerMais_widgetEntryView(entry: entry)
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Beer Mais")
        .description("Deixe em destaque o melhor custo-beneficio")
    }
}

//struct BeerMais_widget_Previews: PreviewProvider {
//    static var previews: some View {
//        BeerMais_widgetEntryView(entry: BeerMaisEntry(
//            date: Date(),
//            brand: nil,
//            amount: nil,
//            value: nil,
//            type: nil,
//            economy: nil,
//            count: 0
//        ))
//        .previewContext(WidgetPreviewContext(family: .systemSmall))
//        BeerMais_widgetEntryView(entry: BeerMaisEntry(
//            date: Date(),
//            brand: "brand",
//            amount: "1 L",
//            value: "RS 1,00",
//            type: "2",
//            economy: "RS 2,00/L",
//            count: 3
//        ))
//        .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}

extension View {
    func widgetBackground(backgroundView: some View) -> some View {
        containerBackground(for: .widget) {
            backgroundView
        }
        .padding(.all, -15)
    }
}
