//
//  BeerDetailView.swift
//  BeerMais
//
//  Created by José Neves on 12/07/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI

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
    private enum Field: Hashable { case brand, price, size }
    @FocusState private var focusedField: Field?
    @State private var confirmsDeletion = false
    @ScaledMetric(relativeTo: .largeTitle) private var priceFontSize = 52
    @ScaledMetric(relativeTo: .subheadline) private var presetMinimumWidth = 76
    
    private let selectedBeer: Beer?

    init(selectedBeer: Beer? = nil, worker: BeerWorkerProtocol) {
        self.selectedBeer = selectedBeer
        self._viewModel = StateObject(
            wrappedValue: ViewModel(
                selectedBeer: selectedBeer,
                worker: worker
            )
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 6) {
                        Text("priceQuestion")
                            .foregroundStyle(.secondary)
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text("R$")
                                .font(.title.bold())
                                .foregroundStyle(Color("primary"))
                            // SwiftUI owns the text baseline and width; UIKit handles editing only.
                            Text(viewModel.price.isEmpty ? "0,00" : viewModel.price)
                                .font(.system(size: priceFontSize, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                                .padding(.trailing, 6)
                                .hidden()
                                .accessibilityHidden(true)
                                .overlay {
                                    CentsPriceField(
                                        text: $viewModel.price,
                                        isFocused: Binding(
                                            get: { focusedField == .price },
                                            set: { if $0 { focusedField = .price } else if focusedField == .price { focusedField = nil } }
                                        ),
                                        fontSize: priceFontSize
                                    )
                                }
                                .layoutPriority(1)
                        }
                        if let rate = viewModel.pricePerLiter {
                            Text(BeerDisplay.perLiter(rate))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("pricePreviewHint")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("chooseSize")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: presetMinimumWidth), spacing: 8)], spacing: 8) {
                            ForEach(Segment.allCases) { option in
                                let button = Button {
                                    viewModel.sizeSelection = option
                                    focusedField = nil
                                } label: {
                                    Text(option.name)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.9)
                                        .frame(maxWidth: .infinity, minHeight: 28)
                                }
                                .controlSize(.regular)
                                .buttonBorderShape(.capsule)
                                .tint(Color("primary"))
                                .accessibilityAddTraits(viewModel.sizeSelection == option ? .isSelected : [])

                                if #available(iOS 26.0, *) {
                                    if viewModel.sizeSelection == option {
                                        button.buttonStyle(.glassProminent)
                                    } else {
                                        button.buttonStyle(.glass)
                                    }
                                } else {
                                    if viewModel.sizeSelection == option {
                                        button.buttonStyle(.borderedProminent)
                                    } else {
                                        button.buttonStyle(.bordered)
                                    }
                                }
                            }
                        }
                        VStack(spacing: 0) {
                            HStack(spacing: 12) {
                                Text("size")
                                TextField("size", text: $viewModel.size)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                    .focused($focusedField, equals: .size)
                                Text(viewModel.sizeType).foregroundStyle(.secondary)
                            }
                            .padding(16)
                            Divider().padding(.horizontal, 16)
                            HStack(spacing: 12) {
                                Text("brand")
                                TextField("brand", text: $viewModel.brand)
                                    .multilineTextAlignment(.trailing)
                                    .focused($focusedField, equals: .brand)
                                    .submitLabel(.done)
                                    .onSubmit { focusedField = nil }
                            }
                            .padding(16)
                        }
                        .background(.quaternary, in: .rect(cornerRadius: 18))
                    }

                    AdaptiveBannerView()
                    .padding(12)
                    .background(.quaternary, in: .rect(cornerRadius: 16))


                }
                .frame(maxWidth: 560)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle(selectedBeer == nil ? "newDrink" : "editDrink")
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                if selectedBeer != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("delete", systemImage: "trash", role: .destructive) {
                            focusedField = nil
                            confirmsDeletion = true
                        }
                        .labelStyle(.iconOnly)
                        .confirmationDialog("deleteTitle", isPresented: $confirmsDeletion, titleVisibility: .visible) {
                            Button("delete", role: .destructive, action: viewModel.delete)
                            Button("cancel", role: .cancel) {}
                        } message: {
                            Text("deleteSingleBeerAlert")
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(selectedBeer == nil ? "add" : "save") {
                        focusedField = nil
                        viewModel.createOrSave()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("OK") { focusedField = nil }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") { dismiss() }
                }
            }
            .alert("beerOperationFailed", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }

        }
        .presentationDetents([.fraction(0.75), .large])
        .presentationBackground(.regularMaterial)
        .onAppear {
            viewModel.onFinish = {
                dismiss()
            }
        }
    }
}
