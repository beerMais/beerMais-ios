//
//  BeerDetailViewModelTests.swift
//  BeerMaisTests
//
//  Created by José Neves on 09/08/26.
//  Copyright © 2026 joseneves. All rights reserved.
//

import Combine
import XCTest
import SwiftUI
import UIKit
import GoogleMobileAds
@testable import BeerMais

final class BeerDetailViewModelTests: XCTestCase {
    
    private var workerSpy: BeerWorkerSpy!
    
    override func setUp() {
        super.setUp()
        workerSpy = BeerWorkerSpy()
    }
    
    override func tearDown() {
        workerSpy = nil
        super.tearDown()
    }
    
    func testInit_WhenSelectedBeerIsNil_SetsDefaultValues() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        
        XCTAssertEqual(sut.brand, "")
        XCTAssertEqual(sut.price, "0,00")
        XCTAssertEqual(sut.size, "269")
        XCTAssertEqual(sut.sizeType, "ml")
        XCTAssertEqual(sut.sizeSelection, .first)
    }
    
    func testInit_WhenSelectedBeerProvided_PopulatesInitialValues() {
        let beer = Beer.mock()
        beer.brand = "Heineken"
        beer.value = 5.99
        beer.amount = 350
        
        let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
        
        XCTAssertEqual(sut.brand, "Heineken")
        XCTAssertEqual(sut.size, "350")
        XCTAssertEqual(sut.sizeType, "ml")
        XCTAssertEqual(sut.sizeSelection, .second)
    }
    
    func testInit_WhenSelectedBeerIs1L_UsesMilliliters() {
        let beer = Beer.mock()
        beer.amount = 1000
        
        let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
        
        XCTAssertEqual(sut.sizeType, "ml")
        XCTAssertEqual(sut.sizeSelection, .fourth)
    }
    
    func testSizeSelectionChange_UpdatesSizeAndSizeType() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        
        sut.sizeSelection = .fourth
        XCTAssertEqual(sut.size, "1000")
        XCTAssertEqual(sut.sizeType, "ml")
        
        sut.sizeSelection = .second
        XCTAssertEqual(sut.size, "350")
        XCTAssertEqual(sut.sizeType, "ml")
    }
    
    func testSizeTextChange_UpdatesSizeSelection() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        
        sut.size = "473"
        XCTAssertEqual(sut.sizeSelection, .third)
    }
    
    func testCreateOrSave_WhenCreatingNewBeer_CallsWorkerCreateBeerAndInvokesOnFinish() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        workerSpy.createBeerReturn = Beer.mock()
        sut.brand = "Corona"
        sut.price = "6.50"
        sut.sizeSelection = .second
        
        var finishCalled = false
        sut.onFinish = {
            finishCalled = true
        }
        
        sut.createOrSave()
        
        XCTAssertEqual(workerSpy.createBeerCalls.count, 1)
        XCTAssertEqual(workerSpy.createBeerCalls.first?.data.brand, "Corona")
        XCTAssertEqual(workerSpy.createBeerCalls.first?.data.value, 6.5)
        XCTAssertEqual(workerSpy.createBeerCalls.first?.data.amount, 350)
        XCTAssertEqual(workerSpy.createBeerCalls.first?.data.type, 1)
        XCTAssertTrue(finishCalled)
    }
    
    func testCreateOrSave_WhenEditingExistingBeer_CallsWorkerEditAndInvokesOnFinish() {
        let beer = Beer.mock()
        beer.amount = 269
        let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
        sut.brand = "Stella Artois"
        sut.price = "4.99"
        
        var finishCalled = false
        sut.onFinish = {
            finishCalled = true
        }
        
        sut.createOrSave()
        
        XCTAssertEqual(workerSpy.editCalls.count, 1)
        XCTAssertEqual(workerSpy.editCalls.first?.beer, beer)
        XCTAssertEqual(workerSpy.editCalls.first?.data.value, 4.99)
        XCTAssertEqual(workerSpy.editCalls.first?.data.amount, 269)
        XCTAssertTrue(finishCalled)
    }

    func testCreateOrSave_WhenInputIsInvalid_DoesNotPersistOrInvokeOnFinish() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        var finishCalled = false
        sut.onFinish = { finishCalled = true }

        sut.brand = " "
        sut.price = "6.50"
        sut.createOrSave()

        sut.brand = "Corona"
        sut.price = "0.00"
        sut.createOrSave()

        sut.price = "6.50"
        sut.size = "0"
        sut.createOrSave()

        XCTAssertTrue(workerSpy.createBeerCalls.isEmpty)
        XCTAssertFalse(finishCalled)
    }

    func testCreateOrSave_WhenEditingWithInvalidInput_DoesNotPersistOrInvokeOnFinish() {
        let beer = Beer.mock()
        beer.amount = 269
        let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
        sut.brand = "Corona"
        sut.price = "0.00"

        var finishCalled = false
        sut.onFinish = { finishCalled = true }

        sut.createOrSave()

        XCTAssertTrue(workerSpy.editCalls.isEmpty)
        XCTAssertFalse(finishCalled)
    }

    func testCreateOrSave_WhenPersistenceFails_DoesNotInvokeOnFinish() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        sut.brand = "Corona"
        sut.price = "6.50"
        workerSpy.createBeerReturn = nil
        var finishCalled = false
        sut.onFinish = { finishCalled = true }

        sut.createOrSave()

        XCTAssertEqual(workerSpy.createBeerCalls.count, 1)
        XCTAssertFalse(finishCalled)
    }

    func testEdit_WhenPersistenceFails_DoesNotInvokeOnFinish() {
        let beer = Beer.mock()
        beer.amount = 269
        let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
        sut.brand = "Corona"
        sut.price = "6.50"
        workerSpy.editReturn = false
        var finishCalled = false
        sut.onFinish = { finishCalled = true }

        sut.createOrSave()

        XCTAssertEqual(workerSpy.editCalls.count, 1)
        XCTAssertFalse(finishCalled)
    }
    
    func testDelete_WhenBeerSelected_CallsWorkerDeleteAndInvokesOnFinish() {
        let beer = Beer.mock()
        beer.amount = 269
        let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
        
        var finishCalled = false
        sut.onFinish = {
            finishCalled = true
        }
        
        sut.delete()
        
        XCTAssertEqual(workerSpy.deleteCalls.count, 1)
        XCTAssertEqual(workerSpy.deleteCalls.first?.beer, beer)
        XCTAssertTrue(finishCalled)
    }
    
    func testDelete_WhenNoBeerSelected_DoesNotCallWorker() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        
        var finishCalled = false
        sut.onFinish = {
            finishCalled = true
        }
        
        sut.delete()
        
        XCTAssertEqual(workerSpy.deleteCalls.count, 0)
        XCTAssertFalse(finishCalled)
    }

    func testDelete_WhenPersistenceFails_DoesNotInvokeOnFinish() {
        let beer = Beer.mock()
        beer.amount = 269
        let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
        workerSpy.deleteReturn = false
        var finishCalled = false
        sut.onFinish = { finishCalled = true }

        sut.delete()

        XCTAssertEqual(workerSpy.deleteCalls.count, 1)
        XCTAssertFalse(finishCalled)
    }
}

final class HomeViewModelTests: XCTestCase {
    func testReload_UpdatesAndClearsHighlightState() {
        let worker = BeerWorkerSpy()
        let firstBeer = Beer.mock()
        let secondBeer = Beer.mock()
        worker.getBeersReturn = [firstBeer, secondBeer]
        worker.calculateMostValuableBeerReturn = (firstBeer, 1.25)
        let sut = HomeView.ViewModel(worker: worker)

        sut.reload()

        XCTAssertEqual(sut.beers, [firstBeer, secondBeer])
        XCTAssertEqual(sut.highlightedBeer, firstBeer)
        XCTAssertEqual(sut.economy, 1.25)

        worker.getBeersReturn = [firstBeer]
        worker.calculateMostValuableBeerReturn = nil
        sut.reload()

        XCTAssertEqual(sut.beers, [firstBeer])
        XCTAssertNil(sut.highlightedBeer)
        XCTAssertNil(sut.economy)
    }
}

final class BeerViewModelTests: XCTestCase {
    func testNormalBeer_FormatsBeerValuesAndPosition() {
        let worker = BeerWorkerSpy()
        worker.formatBeerValueToShowReturn = "5,00"
        worker.getValuePerMLReturn = 0.005
        let beer = Beer.mock()
        beer.brand = "Lager"
        beer.amount = 1000
        beer.value = 5

        let sut = BeerView.ViewModel(beer: beer, index: 1, worker: worker)

        XCTAssertEqual(sut.brand, "Lager")
        XCTAssertEqual(sut.amount, "1 L")
        XCTAssertEqual(sut.beerValue, "R$ 5,00")
        XCTAssertEqual(sut.beerEconomyValue, "R$ 5,00/L")
        XCTAssertEqual(sut.itemNumber, 2)
    }

    func testHighlightedBeer_UsesEconomyInsteadOfPricePerLiter() {
        let worker = BeerWorkerSpy()
        worker.formatBeerValueToShowReturn = "1,75"
        let beer = Beer.mock()
        let sut = BeerView.ViewModel(beer: beer, isHighlighted: true, worker: worker)

        sut.economy = 1.75

        XCTAssertEqual(sut.beerEconomyValue, "R$ 1,75/L")
    }
}

final class DeleteAllViewModelTests: XCTestCase {
    func testDeleteAllBeers_ForwardsToWorker() {
        let worker = BeerWorkerSpy()
        let sut = DeleteAllView.ViewModel(worker: worker)

        sut.deleteAllBeers()

        XCTAssertEqual(worker.deleteAllCalls.count, 1)
    }

    func testDeleteAllBeers_WhenWorkerFails_ReturnsFalse() {
        let worker = BeerWorkerSpy()
        worker.deleteAllReturn = false
        let sut = DeleteAllView.ViewModel(worker: worker)

        XCTAssertFalse(sut.deleteAllBeers())
    }
}

final class ConfigurationAndDonationTests: XCTestCase {
    func testSettingsP_ReturnsInjectedSettings() {
        let sut = SettingsP(settingsDictionary: [
            "AdMobID": "app-id",
            "AdMobBeerBannerID": "banner-id",
            "AdMobBeerRewardedID": "rewarded-id",
            "AmplitudeKey": "amplitude-key"
        ])

        XCTAssertEqual(sut.getAdMobId(), "app-id")
        XCTAssertEqual(sut.getAdMobBeerBannerID(), "banner-id")
        XCTAssertEqual(sut.getAdMobBeerRewardedID(), "rewarded-id")
        XCTAssertEqual(sut.getAmplitudeKey(), "amplitude-key")
    }

    func testDonateType_ProductIDsRoundTrip() {
        for type in [DonateType.small, .medium, .large] {
            XCTAssertEqual(DonateType.getByProductId(type.productId), type)
        }
        XCTAssertNil(DonateType.getByProductId("unknown"))
    }

    func testAppLaunchState_UsesProvidedDefaults() {
        let suiteName = "AppPTests-\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { UserDefaults().removePersistentDomain(forName: suiteName) }

        XCTAssertFalse(AppP.isFirstLaunch(defaults: defaults))
        AppP.setFirstLaunch(defaults: defaults)
        XCTAssertTrue(AppP.isFirstLaunch(defaults: defaults))

        AppP.incrementAppOpenedCount(defaults: defaults)
        AppP.incrementAppOpenedCount(defaults: defaults)
        XCTAssertEqual(defaults.integer(forKey: "APP_OPEN_COUNT"), 2)
    }
}

extension BeerDetailViewModelTests {
    func testCustomVolumesSurviveOpeningAndSaving() {
        for amount: Int16 in [269, 350, 473, 600, 1000, 1500, 32767] {
            let beer = Beer.mock()
            beer.brand = "Custom"
            beer.value = 6.5
            beer.amount = amount
            let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
            XCTAssertEqual(sut.size, String(amount))
            sut.createOrSave()
            XCTAssertEqual(workerSpy.editCalls.last?.data.amount, amount)
            XCTAssertEqual(workerSpy.editCalls.last?.data.value, 6.5)
        }
    }

    func testCustomVolumeOverridesOneLiterPreset() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        sut.brand = "Custom"
        sut.price = "6.50"
        sut.sizeSelection = .fourth
        sut.size = "600"
        XCTAssertNil(sut.sizeSelection)
        sut.createOrSave()
        XCTAssertEqual(workerSpy.createBeerCalls.last?.data.amount, 600)
    }

    func testInvalidPricesShowErrorWithoutPersisting() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        sut.brand = "Custom"
        for price in ["", "0.00", "-5.00", "NaN", "abc5", String(repeating: "9", count: 100)] {
            sut.price = price
            sut.createOrSave()
            XCTAssertNotNil(sut.errorMessage, price)
        }
        XCTAssertTrue(workerSpy.createBeerCalls.isEmpty)
    }

    func testInvalidVolumesShowErrorWithoutPersisting() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        sut.brand = "Custom"
        sut.price = "6.50"
        for size in ["", "0", "-1", "32768", "1.5", "600ml"] {
            sut.size = size
            sut.createOrSave()
            XCTAssertNotNil(sut.errorMessage, size)
        }
        XCTAssertTrue(workerSpy.createBeerCalls.isEmpty)
    }

    func testSaveAndDeleteFailuresShowError() {
        let beer = Beer.mock()
        beer.brand = "Custom"
        beer.value = 5
        beer.amount = 600
        workerSpy.editReturn = false
        workerSpy.deleteReturn = false
        let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
        sut.createOrSave()
        XCTAssertNotNil(sut.errorMessage)
        sut.errorMessage = nil
        sut.delete()
        XCTAssertNotNil(sut.errorMessage)
    }
}

extension HomeViewModelTests {
    func testReloadRefreshesSameWinnerAndEqualSavings() {
        let repository = BeerRepositorySpy()
        let first = Beer.mock()
        first.brand = "First"; first.amount = 1000; first.value = 5
        let second = Beer.mock()
        second.brand = "Second"; second.amount = 1000; second.value = 7
        repository.beers = [second, first]
        let sut = HomeView.ViewModel(worker: BeerWorker(repository: repository))
        sut.reload()
        XCTAssertEqual(sut.highlightedBeerViewModel.brand, "First")
        XCTAssertEqual(sut.highlightedBeerViewModel.beerEconomyValue, "R$ 2,00/L")

        first.brand = "Renamed"
        first.value = 10; first.amount = 2000
        sut.reload()
        XCTAssertEqual(sut.highlightedBeerViewModel.brand, "Renamed")
        XCTAssertEqual(sut.highlightedBeerViewModel.beerValue, "R$ 10,00")
        XCTAssertEqual(sut.highlightedBeerViewModel.amount, "2 L")
        XCTAssertEqual(sut.highlightedBeerViewModel.beerEconomyValue, "R$ 2,00/L")

        first.value = 18 // Second now wins, still saving R$ 2/L.
        sut.reload()
        XCTAssertEqual(sut.highlightedBeerViewModel.brand, "Second")
        XCTAssertEqual(sut.highlightedBeerViewModel.beerEconomyValue, "R$ 2,00/L")

        repository.beers = [second]
        sut.reload()
        XCTAssertNil(sut.highlightedBeerViewModel.beer)
        XCTAssertEqual(sut.highlightedBeerViewModel.beerEconomyValue, "R$ 0,00/L")
    }
}

// Hosting-level regression exercises SwiftUI sizing at accessibility text sizes.
@MainActor
final class AdaptiveBeerLayoutTests: XCTestCase {
    func testPricesKeepConsistentCardHeightAtCompactAndWideWidths() throws {
        for width in [172.0, 200.0, 300.0] {
            var heights: [CGFloat] = []
            for price in ["2,59", "10,99", "545,48"] {
                let worker = BeerWorkerSpy()
                worker.formatBeerValueToShowReturn = price
                let beer = Beer.mock()
                beer.brand = "Original"
                beer.amount = 1000
                let model = BeerView.ViewModel(beer: beer, index: 0, worker: worker)
                let view = BeerView(viewModel: model)
                    .environment(\.dynamicTypeSize, .large)
                    .environment(\.colorScheme, .dark)
                let host = UIHostingController(rootView: view)
                let size = host.sizeThatFits(in: CGSize(width: width, height: 10_000))
                XCTAssertLessThanOrEqual(size.width, width + 1)
                heights.append(size.height)
                let renderer = ImageRenderer(content: view.frame(width: width).padding(8).background(.black))
                renderer.scale = 2
                let data = try XCTUnwrap(renderer.uiImage?.pngData())
                try data.write(to: URL(fileURLWithPath: "/tmp/beermais-card-\(Int(width))-\(price).png"))
            }
            XCTAssertEqual(try XCTUnwrap(heights.min()), try XCTUnwrap(heights.max()), accuracy: 1)
        }
    }

    func testCardExpandsForAccessibilityTextInsteadOfClippingToFixedHeight() {
        let worker = BeerWorkerSpy()
        worker.formatBeerValueToShowReturn = "123,45"
        let beer = Beer.mock()
        beer.brand = "A long beverage brand that needs multiple lines"
        beer.amount = 1000
        let model = BeerView.ViewModel(beer: beer, index: 0, worker: worker)
        let standard = UIHostingController(rootView: BeerView(viewModel: model).environment(\.dynamicTypeSize, .large))
        let accessible = UIHostingController(rootView: BeerView(viewModel: model).environment(\.dynamicTypeSize, .accessibility3))
        let proposal = CGSize(width: 180, height: 10_000)
        let normalSize = standard.sizeThatFits(in: proposal)
        let accessibleSize = accessible.sizeThatFits(in: proposal)
        XCTAssertLessThanOrEqual(normalSize.width, proposal.width + 1)
        XCTAssertLessThanOrEqual(accessibleSize.width, proposal.width + 1)
        XCTAssertGreaterThan(accessibleSize.height, normalSize.height)
        XCTAssertGreaterThan(accessibleSize.height, 120)
    }

}


extension BeerDetailViewModelTests {
    func testDecimalPriceInputPreservesValueWhenSaving() {
        for input in ["12.5", "12,5", "12.50", "12,50", "12"] {
            let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
            sut.brand = "Lager"
            sut.price = input
            sut.createOrSave()
            XCTAssertEqual(workerSpy.createBeerCalls.last?.data.value, input == "12" ? 12 : 12.5)
        }
    }

    func testInvalidPriceAfterValidPriceDoesNotSavePreviousValue() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        sut.brand = "Lager"
        sut.price = "12.50"
        sut.price = "invalid"
        sut.createOrSave()
        XCTAssertTrue(workerSpy.createBeerCalls.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
    }
}


extension BeerDetailViewModelTests {
    func testPricePreviewTracksCustomVolumeAndRejectsInvalidInput() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        sut.price = "2,59"
        sut.size = "350"
        XCTAssertEqual(sut.pricePerLiter ?? 0, 7.4, accuracy: 0.001)
        sut.size = "600"
        XCTAssertEqual(sut.pricePerLiter ?? 0, 4.316667, accuracy: 0.001)
        sut.size = "0"
        XCTAssertNil(sut.pricePerLiter)
        sut.size = "350"
        sut.price = "2.599"
        XCTAssertNil(sut.pricePerLiter)
        sut.price = "invalid"
        XCTAssertNil(sut.pricePerLiter)
    }
}


extension BeerDetailViewModelTests {
    func testPriceInputShiftsDigitsIntoCentsAndSavesDisplayedAmount() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        XCTAssertEqual(sut.priceInput, "0,00")
        for (digit, expected) in [("1", "0,01"), ("2", "0,12"), ("5", "1,25"), ("0", "12,50")] {
            sut.priceInput += digit
            XCTAssertEqual(sut.priceInput, expected)
        }
        sut.brand = "Lager"
        sut.createOrSave()
        XCTAssertEqual(workerSpy.createBeerCalls.last?.data.value, 12.5)
        for expected in ["1,25", "0,12", "0,01", "0,00"] {
            sut.priceInput = String(sut.priceInput.dropLast())
            XCTAssertEqual(sut.priceInput, expected)
        }
        sut.priceInput = ""
        XCTAssertEqual(sut.priceInput, "0,00")
    }

    func testExistingPriceUsesSameCommaFormatAndSupportsAppendingDigits() {
        let beer = Beer.mock()
        beer.value = 2.59
        let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
        XCTAssertEqual(sut.priceInput, "2,59")
        sut.priceInput += "0"
        XCTAssertEqual(sut.priceInput, "25,90")
        sut.priceInput = "-5"
        XCTAssertEqual(sut.priceInput, "25,90")
    }
}


extension AdaptiveBeerLayoutTests {
    func testAdaptiveBannerMatchesPaddedWidthAfterResize() async throws {
        func content(width: CGFloat) -> some View {
            AdaptiveBannerView()
                .padding(12)
                .frame(maxWidth: 560)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .frame(width: width)
        }
        let host = UIHostingController(rootView: content(width: 393))
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 393, height: 852))
        window.rootViewController = host
        window.makeKeyAndVisible()
        defer { window.isHidden = true }
        func findBanner(in view: UIView) -> BannerView? {
            if let banner = view as? BannerView { return banner }
            return view.subviews.lazy.compactMap { findBanner(in: $0) }.first
        }
        var previousBanner: BannerView?
        for (width, loadedHeight) in [(393.0, 50.0), (768.0, 90.0), (320.0, 70.0)] {
            host.rootView = content(width: width)
            host.view.setNeedsLayout()
            host.view.layoutIfNeeded()
            try await Task.sleep(for: .milliseconds(600))
            host.view.layoutIfNeeded()
            let banner = try XCTUnwrap(findBanner(in: host.view))
            let expectedWidth = min(width - 32, 560) - 24
            XCTAssertEqual(cgSize(for: banner.adSize).width, expectedWidth, accuracy: 1)
            XCTAssertEqual(banner.bounds.width, expectedWidth, accuracy: 1)
            XCTAssertFalse(banner === previousBanner, "A width change must replace the pending creative request")
            if let previousBanner { XCTAssertNil(previousBanner.adSizeDelegate) }
            let delegate = try XCTUnwrap(banner.adSizeDelegate)
            // Exercise the SDK size callback without depending on a live ad response.
            delegate.adView(banner, willChangeAdSizeTo: adSizeFor(cgSize: CGSize(width: expectedWidth, height: loadedHeight)))
            try await Task.sleep(for: .milliseconds(100))
            host.view.layoutIfNeeded()
            XCTAssertEqual(banner.bounds.width, expectedWidth, accuracy: 1)
            XCTAssertEqual(banner.bounds.height, loadedHeight, accuracy: 1)
            previousBanner = banner
        }
    }

    func testVisiblePriceFieldFormatsEachKeystroke() async throws {
        let host = UIHostingController(rootView: BeerDetailView(worker: BeerWorkerSpy()))
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 393, height: 852))
        window.rootViewController = host
        window.makeKeyAndVisible()
        defer { window.isHidden = true }
        host.view.layoutIfNeeded()
        try await Task.sleep(for: .milliseconds(300))
        func findPriceField(in view: UIView) -> UITextField? {
            if let field = view as? UITextField, field.placeholder == "0,00" { return field }
            for child in view.subviews {
                if let field = findPriceField(in: child) { return field }
            }
            return nil
        }
        let field = try XCTUnwrap(findPriceField(in: host.view))
        XCTAssertTrue(field.becomeFirstResponder())
        try await Task.sleep(for: .milliseconds(100))
        XCTAssertTrue(field.isFirstResponder)
        // This target runs without an app host. Dispatch registered control actions
        // directly because UIApplication does not route UIControl events here.
        func deliverEditingChange() throws {
            var dispatched = false
            for target in field.allTargets {
                guard let receiver = target as? NSObject else { continue }
                for action in field.actions(forTarget: receiver, forControlEvent: .editingChanged) ?? [] {
                    receiver.perform(NSSelectorFromString(action), with: field)
                    dispatched = true
                }
            }
            XCTAssertTrue(dispatched)
        }
        for (digit, expected) in [("1", "0,01"), ("2", "0,12"), ("5", "1,25"), ("0", "12,50")] {
            field.insertText(digit)
            try deliverEditingChange()
            try await Task.sleep(for: .milliseconds(100))
            XCTAssertEqual(field.text, expected)
            XCTAssertTrue(field.isFirstResponder, "Typing \(digit) must keep the price keyboard open")
        }
        for expected in ["1,25", "0,12", "0,01", "0,00"] {
            field.deleteBackward()
            try deliverEditingChange()
            try await Task.sleep(for: .milliseconds(100))
            XCTAssertEqual(field.text, expected)
            XCTAssertTrue(field.isFirstResponder, "Backspace must keep the price keyboard open")
        }
        XCTAssertTrue(field.resignFirstResponder())
        try await Task.sleep(for: .milliseconds(100))
        XCTAssertFalse(field.isFirstResponder, "Dismissing the keyboard must survive a SwiftUI update")
        XCTAssertTrue(field.becomeFirstResponder())
        try await Task.sleep(for: .milliseconds(100))
        XCTAssertTrue(field.isFirstResponder, "The price field must be focusable again after dismissal")
    }
}
