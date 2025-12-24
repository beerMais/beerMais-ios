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
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image("icon_rounded")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("appName".localized)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "primary")!))
            }
            
            //MARK: - Description
            
            Text("""
A ideia desse app nasceu quando 3 amigos estavam fazendo as contas para decidir qual cerveja compensaria comprar para um churrasco.

Não tendo um foco apenas em cerveja, o Beer Mais pode ser usado para calcular o melhor custo-beneficio entre quaisquer bebidas.

A área em verde destaca a bebida de maior custo-beneficio e ordena a lista utilizando do mesmo critério.

Ícones:
https://icons8.com
https://www.flaticon.com
"""
            )
                .font(.system(size: 16))
                .tint(Color(UIColor(named: "primary")!))
            
            //MARK: - Donate
            
            DonateView()
            
            //MARK: - Spacer
            Spacer()
            
            //MARK: - Version
            
            HStack(spacing: 8) {
                Text("appVersion".localized)
                Text(VersionP.getAppVersion())
            }
            .padding(.bottom, 8)
        }
            .padding([.top, .horizontal], 16)
    }
}

//#Preview {
//    AboutView()
//}
