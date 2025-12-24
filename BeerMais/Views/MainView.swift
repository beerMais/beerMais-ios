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
    @State private var activeTab = Tabs.home.rawValue
    @State private var isPresented = false
    @State private var deleteIsPresented = false
    
    var body: some View {
        
        if #available(iOS 18.0, *) {
            ZStack(alignment: .bottomTrailing) {
                let tabView = TabView(selection: $activeTab) {
                    Tab("Calculadora", image: "icons8-math-50", value: Tabs.home.rawValue) {
                        HomeView()
                    }
                    Tab("Sobre", image: "icons8-about-50", value: Tabs.about.rawValue) {
                        AboutView()
                    }
                }
                .tint(Color(UIColor(named: "primary")!))
                
                if #available(iOS 26.0, *) {
                    tabView
                        .tabBarMinimizeBehavior(.onScrollDown)
                } else {
                    tabView
                }
            }
        } else {
            TabView(selection: $activeTab) {
                HomeView()
                    .tabItem {
                        Label {
                            Text("Calculadora")
                        } icon: {
                            Image("icons8-math-50").renderingMode(.template)
                        }
                    }
                    .tag(Tabs.home.rawValue)
                AboutView()
                    .tabItem {
                        Label {
                            Text("Sobre")
                        } icon: {
                            Image("icons8-about-50").renderingMode(.template)
                        }
                    }
                    .tag(Tabs.about.rawValue)
            }
            .tint(Color(UIColor(named: "primary")!))
        }
    }
}

//#Preview {
//    MainView()
//}
