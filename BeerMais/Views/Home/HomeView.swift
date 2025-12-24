//
//  HomeView.swift
//  BeerMais
//
//  Created by José Neves on 09/07/25.
//  Copyright © 2025 joseneves. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ViewModel()
    @StateObject private var highlightedBeerViewModel = BeerView.ViewModel(isHighlighted: true)
    
    @State private var selectedBeer: Beer?
    @State private var isPresented = false
    @State private var deleteIsPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                BeerView(viewModel: highlightedBeerViewModel)
                    .frame(height: 120)
                    .padding(.horizontal)
                
                if viewModel.beers.count == 0 {
                    VStack {
                        Text("helpBeerText").font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]) {
                        ForEach(Array(viewModel.beers.enumerated()), id: \.element) { index, beer in
                            BeerView(viewModel: BeerView.ViewModel(beer: beer, index: index))
                                .frame(height: 120)
                                .onTapGesture { selectedBeer = beer }
                        }
                    }
                    .padding()
                }
                .refreshable {
                    viewModel.reload()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Delete all", systemImage: "trash") {
                        deleteIsPresented = true
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image("icon_rounded")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("appName".localized)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(UIColor(named: "primary")!))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create new", systemImage: "plus") {
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
                BeerDetailView()
                    .presentationDetents([.fraction(0.79)])
            }
        )
        .sheet(
            isPresented: $deleteIsPresented,
            onDismiss: {
                viewModel.reload()
            },
            content: {
                DeleteAllView()
                    .presentationDetents([.medium])
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
                    BeerDetailView(selectedBeer: beer)
                        .presentationDetents([.fraction(0.79)])
                }
            }
        )
        .onChange(of: viewModel.highlightedBeer) { _, newValue in
            highlightedBeerViewModel.beer = newValue
        }
        .onAppear {
            viewModel.reload()
        }
    }
}

//#Preview {
//    HomeView()
//}
