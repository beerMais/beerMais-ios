//
//  BeerDetailViewModelTests.swift
//  BeerMaisTests
//
//  Created by José Neves on 09/08/26.
//  Copyright © 2026 joseneves. All rights reserved.
//

import Combine
import XCTest
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
        XCTAssertEqual(sut.price, "")
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
