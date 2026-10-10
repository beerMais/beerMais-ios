//
//  HomeView.swift
//  BeerMais
//
//  Created by José Neves on 09/07/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: ViewModel
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var isHomeVisible = false
    @State private var selectedBeer: Beer?
    @State private var isPresented = false
    @State private var deleteIsPresented = false

    init(worker: BeerWorkerProtocol) {
        _viewModel = StateObject(wrappedValue: ViewModel(worker: worker))
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    let wide = geometry.size.width >= 760 && !dynamicTypeSize.isAccessibilitySize
                    let layout = wide ? AnyLayout(HStackLayout(alignment: .top, spacing: 20))
                                      : AnyLayout(VStackLayout(spacing: 16))
                    layout {
                        BeerView(viewModel: viewModel.highlightedBeerViewModel)
                            .frame(maxWidth: wide ? 300 : .infinity)
                        VStack(spacing: 16) {
                            if viewModel.beers.isEmpty {
                                Text("helpBeerText")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, minHeight: 120)
                            }
                            LazyVGrid(columns: dynamicTypeSize.isAccessibilitySize
                                      ? [GridItem(.flexible(), alignment: .top)]
                                      : [GridItem(.adaptive(minimum: 172), spacing: 12, alignment: .top)], spacing: 12) {
                                ForEach(Array(viewModel.beers.enumerated()), id: \.element) { index, beer in
                                    Button {
                                        selectedBeer = beer
                                    } label: {
                                        BeerView(viewModel: BeerView.ViewModel(beer: beer, index: index, worker: viewModel.worker))
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityHint(Text("editBeerHint"))
                                }
                            }
                            if viewModel.beers.count == 1 {
                                Text("secondDrinkGuidance")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
                .refreshable { viewModel.reload() }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("deleteAll", systemImage: "trash") {
                        deleteIsPresented = true
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image("icon_rounded")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("appName".localized)
                            .font(.headline)
                            .foregroundColor(Color(UIColor(named: "primary")!))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("createNew", systemImage: "plus") {
                        isPresented = true
                    }
                    .tint(Color(UIColor(named: "primary")!))
                }
            }
        }
        .sheet(
            isPresented: $isPresented,
            onDismiss: {
                viewModel.reload()
            },
            content: {
                BeerDetailView(worker: viewModel.worker)
            }
        )
        .sheet(
            isPresented: $deleteIsPresented,
            onDismiss: {
                viewModel.reload()
            },
            content: {
                DeleteAllView(worker: viewModel.worker)
                    .presentationDetents([.medium, .large])
            }
        )
        .sheet(
            isPresented: Binding(
                get: { selectedBeer != nil },
                set: { if !$0 { selectedBeer = nil } }
            ),
            onDismiss: {
                viewModel.reload()
            },
            content: {
                if let beer = selectedBeer {
                    BeerDetailView(selectedBeer: beer, worker: viewModel.worker)
                }
            }
        )
        .onAppear {
            isHomeVisible = true
            viewModel.reload()
            recordComparisonExposure()
        }
        .onDisappear { isHomeVisible = false }
        .onChange(of: viewModel.highlightedBeer) {
            recordComparisonExposure()
        }
        .onChange(of: scenePhase) {
            recordComparisonExposure()
        }
    }

    private func recordComparisonExposure() {
        guard isHomeVisible, scenePhase == .active, viewModel.highlightedBeer != nil else { return }
        AppP.recordFirstComparison()
    }
}

//#Preview {
//    HomeView()
//}
