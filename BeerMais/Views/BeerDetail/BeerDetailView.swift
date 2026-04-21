//
//  BeerDetailView.swift
//  BeerMais
//
//  Created by José Neves on 12/07/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

enum Segment: String, CaseIterable, Identifiable {
    case first, second, third, fourth
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .first:
            "269ml"
        case .second:
            "350ml"
        case .third:
            "473ml"
        case .fourth:
            "1L"
        }
    }
    
    var amount: Int16 {
        switch self {
        case .first:
            269
        case .second:
            350
        case .third:
            473
        case .fourth:
            1000
        }
    }
}

struct BeerDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ViewModel
    
    private let selectedBeer: Beer?

    init(selectedBeer: Beer? = nil) {
        self.selectedBeer = selectedBeer
        self._viewModel = StateObject(
            wrappedValue: ViewModel(
                selectedBeer: selectedBeer
            )
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack {
                        TextField("brand", text: $viewModel.brand)
                            .padding()
                        TextField("price", text: $viewModel.price)
                            .keyboardType(.numberPad)
                            .padding()
                            .onChange(of: viewModel.price) { _, newValue in
                                let digits = newValue.filter(\.isNumber)
                                let doubleValue = (Double(digits) ?? 0) / 100.0
                                let formatted = String(format: "%.2f", doubleValue)
                                if formatted != newValue {
                                    viewModel.price = formatted
                                }
                            }
                    }
                }
                
                Section(content: {
                    VStack {
                        TextField("", text: $viewModel.size)
                            .keyboardType(.numberPad)
                            .padding()
                            .overlay {
                                Text(viewModel.sizeType)
                                    .padding(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        
                        Picker("Segments", selection: $viewModel.sizeSelection) {
                            ForEach(Segment.allCases) { option in
                                Text(option.name).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }, header: {
                    Text("size")
                }, footer: {
                    Text("detailsHelpText")
                })
                
                let adSize = largeAnchoredAdaptiveBanner(width: UIScreen.main.bounds.width - 64)
                BannerViewContainer(adSize)
                    .frame(width: adSize.size.width, height: adSize.size.height)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("backScreen") {
                        dismiss()
                    }
                }
                if selectedBeer != nil {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("delete") {
                            viewModel.delete()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(selectedBeer == nil ? "add" : "save") {
                        viewModel.createOrSave()
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
        .onAppear {
            viewModel.onFinish = {
                dismiss()
            }
        }
    }
}

//#Preview {
//    HomeView()
//    BeerDetailView()
//}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
