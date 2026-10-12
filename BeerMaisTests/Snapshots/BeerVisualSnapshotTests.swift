import XCTest
import SwiftUI
import SnapshotTesting
@testable import BeerMais

@MainActor
final class BeerVisualSnapshotTests: XCTestCase {
    func testRankedCard() throws {
        try requireReferenceRuntime()
        let beer = Beer.mock()
        beer.brand = "Cerveja artesanal de nome longo"
        beer.amount = 1500
        beer.type = 2
        beer.value = 12.5
        let model = BeerView.ViewModel(beer: beer, index: 1, worker: BeerWorker(repository: BeerRepositorySpy()))
        captureCard(model, name: "ranked")
    }

    func testHighlightedCard() throws {
        try requireReferenceRuntime()
        let beer = Beer.mock()
        beer.brand = "Melhor compra"
        beer.amount = 350
        beer.type = 1
        beer.value = 2.59
        let model = BeerView.ViewModel(beer: beer, isHighlighted: true, worker: BeerWorker(repository: BeerRepositorySpy()))
        model.economy = 3.75
        captureCard(model, name: "highlighted")
    }

    private func requireReferenceRuntime() throws {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        try XCTSkipIf(version.majorVersion != 26 || version.minorVersion != 2,
                      "PNG references require iOS 26.2. CI runs this pinned runtime.")
        XCTAssertNotNil(UIImage(named: "icons8-beer-can-100", in: .beerMais, compatibleWith: nil))
        XCTAssertNotNil(UIColor(named: "economyBackground", in: .beerMais, compatibleWith: nil))
    }

    private func captureCard(_ model: BeerView.ViewModel, name: String) {
        for dark in [false, true] {
            for accessible in [false, true] {
                let scheme: ColorScheme = dark ? .dark : .light
                let root = BeerView(viewModel: model)
                    .environment(\.locale, Locale(identifier: "pt_BR"))
                    .environment(\.colorScheme, scheme)
                    .environment(\.dynamicTypeSize, accessible ? .accessibility3 : .large)
                    .padding(16)
                    .frame(width: 402, height: 680)
                    .background(Color(uiColor: dark ? .black : .white))
                    .transaction { $0.animation = nil }
                let host = UIHostingController(rootView: root)
                let traits = UITraitCollection(traitsFrom: [
                    UITraitCollection(displayScale: 2),
                    UITraitCollection(userInterfaceStyle: dark ? .dark : .light),
                    UITraitCollection(preferredContentSizeCategory: accessible ? .accessibilityExtraExtraExtraLarge : .large)
                ])
                let recording = ProcessInfo.processInfo.environment["BEERMAIS_RECORD_SNAPSHOTS"] == "1"
                assertSnapshot(
                    of: host,
                    as: .wait(for: 0.3, on: .image(drawHierarchyInKeyWindow: true,
                                                  precision: 0.995, perceptualPrecision: 0.98,
                                                  size: CGSize(width: 402, height: 680), traits: traits)),
                    named: "\(name).\(dark ? "dark" : "light").\(accessible ? "accessibility" : "standard")",
                    record: recording ? .all : .never,
                    testName: "card"
                )
            }
        }
    }
}
