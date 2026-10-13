import XCTest
import SwiftUI
import SnapshotTesting
@testable import BeerMais

@MainActor
final class BeerVisualSnapshotTests: XCTestCase {
    func testRankedCard() throws {
        try requireReferenceRuntime()
        let (worker, beer) = try fixture(brand: "Cerveja artesanal de nome longo", amount: 1500, value: 12.5)
        let model = BeerView.ViewModel(beer: beer, index: 1, worker: worker)
        captureCard(model, name: "ranked")
    }

    func testHighlightedCard() throws {
        try requireReferenceRuntime()
        let (worker, beer) = try fixture(brand: "Melhor compra", amount: 350, value: 2.59)
        let model = BeerView.ViewModel(beer: beer, isHighlighted: true, worker: worker)
        model.economy = 3.75
        captureCard(model, name: "highlighted")
    }

    private func fixture(brand: String, amount: Int16, value: Float) throws -> (BeerWorker, Beer) {
        let controller = PersistenceController(inMemory: true)
        let repository = CoreDataBeerRepository(persistenceController: controller)
        let beer = try XCTUnwrap(repository.create(data: BeerData(brand: brand, value: value, amount: amount)))
        return (BeerWorker(repository: repository, widgetDefaults: nil, reloadWidget: {}), beer)
    }

    private func requireReferenceRuntime() throws {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        try XCTSkipIf(version.majorVersion != 26 || version.minorVersion != 2,
                      "PNG references require iOS 26.2. CI runs this pinned runtime.")
        XCTAssertTrue(AppDelegate.isRunningTests)
        XCTAssertNotNil(UIApplication.shared.delegate as? AppDelegate)
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
                                                  precision: 1, perceptualPrecision: 0.98,
                                                  size: CGSize(width: 402, height: 680), traits: traits)),
                    named: "\(name).\(dark ? "dark" : "light").\(accessible ? "accessibility" : "standard")",
                    record: recording ? .all : .never,
                    testName: "card"
                )
            }
        }
    }
}
