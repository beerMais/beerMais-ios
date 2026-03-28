//
//  BeerView.swift
//  BeerMais
//
//  Created by José Neves on 06/07/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI
import BasicsKit

struct BeerView: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 22)
            .stroke(
                Color(UIColor(named: "economyBorder")!),
                lineWidth: 1
            )
    }
    
    var backgroundColor: Color? {
        if viewModel.isHighlighted && viewModel.beer != nil,
           let uiColor = UIColor(named: "economyBackground") {
            Color(uiColor)
        } else {
            Color(UIColor.tertiarySystemBackground)
        }
    }
    
    private var container: some View {
        ZStack {
            VStack {
                Text(viewModel.brand)
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
                        viewModel.image
                            .renderingMode(.template)
                            .resizable()
                            .padding(.bottom, -8)
                            .scaledToFit()
                            .frame(width: 50.0, height: 50.0)
                            .foregroundColor(Color(
                                UIColor(named: "black-white")!
                            ))
                        Text(viewModel.amount)
                            .font(.system(size: 16))
                            .foregroundColor(Color(UIColor.label))
                    }
                    Spacer()
                    VStack {
                        Text(viewModel.beerValue)
                            .font(.system(size: 20))
                            .fontWeight(.regular)
                            .frame(maxWidth: .infinity,
                                   maxHeight: 20,
                                   alignment: .center)
                            .foregroundColor(Color(UIColor.label))
                        if !viewModel.isHighlighted {
                            Text(viewModel.beerEconomyValue)
                                .font(.system(size: 13))
                                .fontWeight(.regular)
                                .frame(maxWidth: .infinity,
                                       maxHeight: 20,
                                       alignment: .center)
                                .foregroundColor(Color.gray)
                        }
                    }
                    Spacer()
                    if viewModel.isHighlighted {
                        VStack {
                            Text("saving")
                                .font(.system(size: 20))
                                .fontWeight(.regular)
                                .frame(maxWidth: .infinity,
                                       maxHeight: 20,
                                       alignment: .center)
                                .foregroundColor(Color(UIColor.label))
                            Text(viewModel.beerEconomyValue)
                                .font(.system(size: 20))
                                .fontWeight(.regular)
                                .frame(maxWidth: .infinity,
                                       maxHeight: 20,
                                       alignment: .center)
                                .foregroundColor(Color(
                                    UIColor(named: "economyBorder")!
                                ))
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(backgroundColor)
            
            Text(viewModel.isHighlighted ? "disclaimer".localized : viewModel.itemNumber?.asString ?? "")
                .font(.system(size: 10))
                .fontWeight(.light)
                .padding(.trailing, 6)
                .padding(.bottom, 6)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .foregroundColor(Color.gray)
        }
    }
    
    var body: some View {
        if #available(iOS 26.0, *) {
            container
                .glassEffect(.regular, in: .rect(cornerRadius: 16))
        } else {
            container
                .overlay(border)
        }
    }
}

//#Preview(traits: .fixedLayout(width: 450, height: 160)) {
//    BeerView(
//        viewModel: BeerView.ViewModel(
//            beer: BeerWorker().createBeer(data: [
//                "amount": Int16(350),
//                "brand": "Budweiser",
//                "value": 2.59,
//                "type": Int16(1)
//            ])!,
//            index: 1
//        )
//    )
//    .padding(20)
//    BeerView(
//        viewModel: BeerView.ViewModel(
//            isHighlighted: true
//        )
//    )
//    .padding(20)
//}
