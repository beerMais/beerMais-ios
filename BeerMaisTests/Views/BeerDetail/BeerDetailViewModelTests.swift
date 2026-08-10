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
        XCTAssertEqual(sut.size, "")
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
    
    func testInit_WhenSelectedBeerIs1L_SetsSizeTypeToL() {
        let beer = Beer.mock()
        beer.amount = 1000
        
        let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
        
        XCTAssertEqual(sut.sizeType, "L")
        XCTAssertEqual(sut.sizeSelection, .fourth)
    }
    
    func testSizeSelectionChange_UpdatesSizeAndSizeType() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        
        sut.sizeSelection = .fourth
        XCTAssertEqual(sut.size, "1L")
        XCTAssertEqual(sut.sizeType, "L")
        
        sut.sizeSelection = .second
        XCTAssertEqual(sut.size, "350ml")
        XCTAssertEqual(sut.sizeType, "ml")
    }
    
    func testSizeTextChange_UpdatesSizeSelection() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        
        sut.size = "473ml"
        XCTAssertEqual(sut.sizeSelection, .third)
    }
    
    func testCreateOrSave_WhenCreatingNewBeer_CallsWorkerCreateBeerAndInvokesOnFinish() {
        let sut = BeerDetailView.ViewModel(selectedBeer: nil, worker: workerSpy)
        sut.brand = "Corona"
        sut.price = "6.50"
        sut.sizeSelection = .second
        
        var finishCalled = false
        sut.onFinish = {
            finishCalled = true
        }
        
        sut.createOrSave()
        
        XCTAssertEqual(workerSpy.createBeerCalls.count, 1)
        XCTAssertTrue(finishCalled)
    }
    
    func testCreateOrSave_WhenEditingExistingBeer_CallsWorkerEditAndInvokesOnFinish() {
        let beer = Beer.mock()
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
        let sut = BeerDetailView.ViewModel(selectedBeer: beer, worker: workerSpy)
        sut.brand = "Corona"
        sut.price = "0.00"

        var finishCalled = false
        sut.onFinish = { finishCalled = true }

        sut.createOrSave()

        XCTAssertTrue(workerSpy.editCalls.isEmpty)
        XCTAssertFalse(finishCalled)
    }
    
    func testDelete_WhenBeerSelected_CallsWorkerDeleteAndInvokesOnFinish() {
        let beer = Beer.mock()
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
}
