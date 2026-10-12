import XCTest
import SnapshotTesting
@testable import BeerMais

/// Text snapshots protect the exact presentation contract without device, font,
/// locale, ads, or network dependencies. They do not replace visual layout tests.
@MainActor
final class BeerPresentationSnapshotTests: XCTestCase {
    func testVolumeLabels() {
        let volumes: [Int16] = [269, 350, 473, 600, 999, 1000, 1001, 1010, 1100, 1500, 2000, 32767]
        let output = volumes.map { "\($0) ml -> \(BeerDisplay.amount($0))" }.joined(separator: "\n")
        assertSnapshot(of: output, as: .lines, named: "volumes", record: false, testName: "display")
    }

    func testCurrencyAndCentsInput() {
        let prices: [Float] = [0, 0.01, 1.25, 6.5, 1234.5]
        let currency = prices.map { BeerDisplay.perLiter($0) }.joined(separator: "\n")
        let inputs = ["", "1", "12", "125", "000125", "1,25", "123450", "abc", "١٢"]
        let cents = inputs.map { "[\($0)] -> \(BeerDisplay.centsInput($0) ?? "rejected")" }.joined(separator: "\n")
        assertSnapshot(of: currency + "\n\nCents input\n" + cents, as: .lines, named: "currency", record: false, testName: "display")
    }

    func testEditorStatesAndPresets() {
        let worker = BeerWorkerSpy()
        let editor = BeerDetailView.ViewModel(selectedBeer: nil, worker: worker)
        var states = [editorState(editor, name: "New drink")]
        for preset in Segment.allCases {
            editor.sizeSelection = preset
            states.append(editorState(editor, name: "Preset \(preset.name)"))
        }
        editor.brand = "Custom lager"
        editor.price = "6,50"
        editor.size = "1500"
        states.append(editorState(editor, name: "Custom volume"))
        assertSnapshot(of: states.joined(separator: "\n\n"), as: .lines, named: "states", record: false, testName: "editor")
    }

    func testRankedCardUpdatesAfterBeerChanges() {
        let worker = BeerWorker(repository: BeerRepositorySpy())
        let beer = Beer.mock()
        beer.brand = "Lager"
        beer.amount = 1000
        beer.value = 6.5
        let card = BeerView.ViewModel(beer: beer, index: 1, worker: worker)
        let original = cardState(card, name: "Ranked card")
        beer.brand = "Custom lager"
        beer.amount = 1500
        card.beer = beer
        assertSnapshot(of: original + "\n\n" + cardState(card, name: "Updated card"), as: .lines, named: "ranked", record: false, testName: "card")
    }

    func testHighlightedCardShowsSavingsWithoutRank() {
        let worker = BeerWorker(repository: BeerRepositorySpy())
        let beer = Beer.mock()
        beer.brand = "Economy lager"
        beer.amount = 350
        beer.value = 1.75
        let card = BeerView.ViewModel(beer: beer, isHighlighted: true, worker: worker)
        card.economy = 1.75
        assertSnapshot(of: cardState(card, name: "Highlighted card"), as: .lines, named: "highlighted", record: false, testName: "card")
    }

    private func editorState(_ editor: BeerDetailView.ViewModel, name: String) -> String {
        [name, "brand: [\(editor.brand)]", "price: \(editor.priceInput)", "volume: \(editor.size) \(editor.sizeType)",
         "preset: \(editor.sizeSelection?.name ?? "custom")",
         "price per liter: \(editor.pricePerLiter.map { BeerDisplay.perLiter($0) } ?? "unavailable")"].joined(separator: "\n")
    }

    private func cardState(_ card: BeerView.ViewModel, name: String) -> String {
        [name, "brand: \(card.brand)", "volume: \(card.amount)", "price: \(card.beerValue)",
         "rate: \(card.beerEconomyValue)", "rank: \(card.itemNumber.map(String.init) ?? "none")",
         "highlighted: \(card.isHighlighted)"].joined(separator: "\n")
    }
}
