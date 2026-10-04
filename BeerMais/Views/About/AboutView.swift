//
//  AboutView.swift
//  BeerMais
//
//  Created by José Neves on 19/06/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image("icon_rounded")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("appName".localized)
                        .font(.title2.weight(.medium))
                        .foregroundColor(Color(UIColor(named: "primary")!))
                }
            
                //MARK: - Description
            
                Text("aboutDescription")
                    .font(.body)
                    .tint(Color(UIColor(named: "primary")!))
            
                //MARK: - Donate
            
                DonateView()
            
                //MARK: - Version
            
                HStack(spacing: 8) {
                    Text("appVersion".localized)
                    Text(VersionP.getAppVersion())
                }
                .padding(.bottom, 8)
            }
            .frame(maxWidth: 720)
            .padding(16)
            .frame(maxWidth: .infinity)
        }
    }
}

//#Preview {
//    AboutView()
//}
