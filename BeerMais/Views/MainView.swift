//
//  MainView.swift
//  BeerMais
//
//  Created by José Neves on 19/06/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI

enum Tabs: Int {
    case home
    case about
    case new
}

struct MainView: View {
    @Environment(\.appDependencies) private var dependencies
    @State private var activeTab = Tabs.home
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            let tabView = TabView(selection: $activeTab) {
                Tab("calculatorTab", image: "icons8-math-50", value: Tabs.home) {
                    HomeView(worker: dependencies.beerWorker)
                }
                Tab("aboutTab", image: "icons8-about-50", value: Tabs.about) {
                    AboutView()
                }
            }
            .tint(Color("primary"))

            if #available(iOS 26.0, *) {
                tabView
                    .tabBarMinimizeBehavior(.onScrollDown)
            } else {
                tabView
            }
        }
    }
}

//#Preview {
//    MainView()
//}
