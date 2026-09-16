//
//  BeerWorkerTests.swift
//  BeerMaisTests
//
//  Created by José Neves on 19/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import CoreData
import Foundation
import XCTest

final class BeerWorkerTests: XCTestCase {
    
    var sut: BeerWorker!
    
    override func setUp() {
        sut = BeerWorker(repository: BeerRepositorySpy())
    }
    
    override func tearDown() {
        sut =  nil
    }
    
    func testOrderBeersWithEmptyList() {
        XCTAssertEqual(sut.orderBeers([]), [])
    }
    
    func testOrderBeersWithOneBeer() {
        let beer = Beer.mock()
        
        XCTAssertEqual(sut.orderBeers([beer]), [beer])
    }
    
    func testOrderBeersWithBeerList() {

        let beer = Beer.mock()
        beer.value = 10
        beer.amount = 1000

        let beer2 = Beer.mock()
        beer2.value = 11.0
        beer2.amount = 1000

        XCTAssertEqual(sut.orderBeers([beer, beer2]), [beer, beer2])
        XCTAssertEqual(sut.orderBeers([beer2, beer]), [beer, beer2])
    }
    
    func testGetValuePerML() {

        let beer = Beer.mock()
        beer.value = 10
        beer.amount = 1000

        let beer2 = Beer.mock()
        beer2.value = 11.0
        beer2.amount = 1000

        XCTAssertEqual(sut.getValuePerML(beer: beer), 0.01)
        XCTAssertEqual(sut.getValuePerML(beer: beer2), 0.011)
    }

    func testGetValuePerML_WithZeroAmount_ReturnsInfinity() {
        let beer = Beer.mock()
        beer.value = 10
        beer.amount = 0

        XCTAssertEqual(sut.getValuePerML(beer: beer), .infinity)
        XCTAssertEqual(sut.orderBeers([beer]).first, beer)
    }
    
    func testCalcEconomyBetweenBeers() {

        let beer = Beer.mock()
        beer.value = 10
        beer.amount = 1000

        let beer2 = Beer.mock()
        beer2.value = 15.0
        beer2.amount = 1000

        XCTAssertEqual(sut.calcEconomyBetweenBeers(beer1: beer, beer2: beer2), 5)
        
        let beer3 = Beer.mock()
        beer3.value = 2.19
        beer3.amount = 350
        
        XCTAssertEqual(sut.calcEconomyBetweenBeers(beer1: beer3, beer2: beer), 3.742857)
        XCTAssertEqual(sut.calcEconomyBetweenBeers(beer1: beer, beer2: beer3), -3.742857)
        
        XCTAssertEqual(sut.calcEconomyBetweenBeers(beer1: beer3, beer2: beer2), 8.742857)
        XCTAssertEqual(sut.calcEconomyBetweenBeers(beer1: beer2, beer2: beer3), -8.742857)
    }
    
    func testFormatBeerValueToShow() {
        
        let beer = Beer.mock()
        beer.value = 10
        beer.amount = 1000

        XCTAssertEqual(sut.formatBeerValueToShow(value: beer.value), "10,00")
        
        let beer2 = Beer.mock()
        beer2.value = 2.19
        beer2.amount = 350

        XCTAssertEqual(sut.formatBeerValueToShow(value: beer2.value), "2,19")
    }
    
    func testCalculateMostValuableBeer() {
        
        let beer = Beer.mock()
        beer.value = 10
        beer.amount = 1000

        let beer2 = Beer.mock()
        beer2.value = 11.0
        beer2.amount = 1000

        XCTAssertEqual(sut.calculateMostValuableBeer(beers: [beer, beer2])?.0, beer)
        XCTAssertEqual(sut.calculateMostValuableBeer(beers: [beer2, beer])?.0, beer)
        XCTAssertEqual(sut.calculateMostValuableBeer(beers: [beer, beer2])?.1 ?? -1, 1, accuracy: 0.00001)
    }

    func testCalculateMostValuableBeer_WithFewerThanTwoBeers_ReturnsNil() {
        XCTAssertNil(sut.calculateMostValuableBeer(beers: []))
        XCTAssertNil(sut.calculateMostValuableBeer(beers: [Beer.mock()]))
    }
}

final class CoreDataBeerRepositoryTests: XCTestCase {
    private var directory: URL!
    private var controller: PersistenceController!
    private var repository: CoreDataBeerRepository!

    override func setUpWithError() throws {
        directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        controller = makeController()
        repository = CoreDataBeerRepository(persistenceController: controller)
    }

    override func tearDownWithError() throws {
        repository = nil
        if let controller {
            controller.viewContext.reset()
            for store in controller.container.persistentStoreCoordinator.persistentStores {
                try controller.container.persistentStoreCoordinator.remove(store)
            }
        }
        controller = nil
        try FileManager.default.removeItem(at: directory)
    }

    private func makeController() -> PersistenceController {
        PersistenceController(
            managedObjectModel: Beer.managedObjectModel,
            storeURL: directory.appendingPathComponent("BeerMais.sqlite")
        )
    }

    func testCRUDAndReopeningPreserveCustomVolumes() throws {
        let volumes: [Int16] = [269, 350, 473, 600, 1000, 1500]
        for volume in volumes {
            XCTAssertNotNil(repository.create(data: BeerData(brand: "Lager", value: 5, amount: volume)))
        }
        XCTAssertEqual(repository.fetchBeers().map(\.amount).sorted(), volumes)
        let edited = try XCTUnwrap(repository.fetchBeers().first { $0.amount == 600 })
        XCTAssertTrue(repository.update(beer: edited, data: BeerData(brand: "Edited", value: 6, amount: 600)))
        let deleted = try XCTUnwrap(repository.fetchBeers().first { $0.amount == 269 })
        XCTAssertTrue(repository.delete(beer: deleted))

        controller.viewContext.reset()
        for store in controller.container.persistentStoreCoordinator.persistentStores {
            try controller.container.persistentStoreCoordinator.remove(store)
        }
        controller = makeController()
        repository = CoreDataBeerRepository(persistenceController: controller)
        XCTAssertEqual(repository.fetchBeers().map(\.amount).sorted(), [350, 473, 600, 1000, 1500])
        XCTAssertEqual(repository.fetchBeers().first { $0.amount == 600 }?.brand, "Edited")
        let registered = repository.fetchBeers()
        XCTAssertTrue(repository.deleteAll())
        XCTAssertTrue(repository.fetchBeers().isEmpty)
        XCTAssertTrue(registered.allSatisfy { $0.isDeleted || $0.managedObjectContext == nil })
        XCTAssertTrue(repository.deleteAll())
    }

    func testInMemoryPreviewCanDeleteAll() {
        let memory = PersistenceController(inMemory: true, managedObjectModel: Beer.managedObjectModel)
        let repository = CoreDataBeerRepository(persistenceController: memory)
        XCTAssertNotNil(repository.create(data: BeerData(brand: "Preview", value: 5, amount: 600)))
        XCTAssertTrue(repository.deleteAll())
        XCTAssertTrue(repository.fetchBeers().isEmpty)
    }

    func testFailedSaveRollsBackChanges() throws {
        let model = try XCTUnwrap(Beer.managedObjectModel.copy() as? NSManagedObjectModel)
        model.entitiesByName["Beer"]?.attributesByName["brand"]?.isOptional = false
        let memory = PersistenceController(inMemory: true, managedObjectModel: model)
        let repository = CoreDataBeerRepository(persistenceController: memory)
        let beer = try XCTUnwrap(repository.create(data: BeerData(brand: "Original", value: 5, amount: 600)))
        XCTAssertFalse(repository.update(beer: beer, data: BeerData(brand: nil, value: 7, amount: 1000)))
        XCTAssertEqual(beer.brand, "Original")
        XCTAssertEqual(beer.amount, 600)
        XCTAssertNil(repository.create(data: BeerData(brand: nil, value: 4, amount: 350)))
        XCTAssertEqual(repository.fetchBeers().count, 1)
    }

    func testWidgetFollowsSuccessfulCRUDAndRefreshesOnReopen() throws {
        let suite = "BeerWidgetTests-\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        var reloads = 0
        let worker = BeerWorker(repository: repository, widgetDefaults: defaults, reloadWidget: { reloads += 1 })
        let first = try XCTUnwrap(worker.createBeer(data: BeerData(brand: "First", value: 5, amount: 1000)))
        XCTAssertNil(defaults.string(forKey: "BRAND"))
        let second = try XCTUnwrap(worker.createBeer(data: BeerData(brand: "Second", value: 7, amount: 1000)))
        XCTAssertEqual(defaults.string(forKey: "BRAND"), "First")
        XCTAssertEqual(defaults.string(forKey: "ECONOMY"), "R$ 2,00/L")
        XCTAssertEqual(reloads, 1)
        worker.refreshWidgetData()
        XCTAssertEqual(reloads, 1)

        XCTAssertTrue(worker.edit(beer: first, data: BeerData(brand: "Edited", value: 10, amount: 1000)))
        XCTAssertEqual(worker.getBeers().first, second)
        XCTAssertEqual(defaults.string(forKey: "BRAND"), "Second")
        XCTAssertEqual(defaults.string(forKey: "ECONOMY"), "R$ 3,00/L")
        let third = try XCTUnwrap(worker.createBeer(data: BeerData(brand: "Third", value: 8, amount: 1000)))
        XCTAssertTrue(worker.delete(beer: second))
        XCTAssertEqual(defaults.string(forKey: "BRAND"), "Third")
        XCTAssertEqual(defaults.integer(forKey: "BEERS_COUNT"), 2)

        defaults.removePersistentDomain(forName: suite)
        worker.refreshWidgetData()
        XCTAssertEqual(defaults.string(forKey: "BRAND"), "Third")
        XCTAssertTrue(worker.delete(beer: third))
        XCTAssertNil(defaults.string(forKey: "BRAND"))
        XCTAssertNil(defaults.string(forKey: "ECONOMY"))
        XCTAssertEqual(defaults.integer(forKey: "BEERS_COUNT"), 0)
        _ = worker.createBeer(data: BeerData(brand: "Last", value: 3, amount: 600))
        XCTAssertNotNil(defaults.string(forKey: "BRAND"))
        XCTAssertTrue(worker.deleteAllBeers())
        XCTAssertTrue(repository.fetchBeers().isEmpty)
        for key in ["BRAND", "AMOUNT", "VALUE", "TYPE", "BEERS_COUNT", "ECONOMY"] {
            XCTAssertNil(defaults.object(forKey: key))
        }
    }

    func testEqualPriceRankingIsStableAcrossFetchOrderAndReopen() throws {
        let first = try XCTUnwrap(repository.create(data: BeerData(brand: "A", value: 5, amount: 1000)))
        let second = try XCTUnwrap(repository.create(data: BeerData(brand: "B", value: 5, amount: 1000)))
        let worker = BeerWorker(repository: repository)
        let ids = worker.orderBeers([first, second]).map { $0.objectID.uriRepresentation() }
        XCTAssertEqual(worker.orderBeers([second, first]).map { $0.objectID.uriRepresentation() }, ids)
        controller.viewContext.reset()
        let reopened = makeController()
        let otherWorker = BeerWorker(repository: CoreDataBeerRepository(persistenceController: reopened))
        XCTAssertEqual(otherWorker.getBeers().map { $0.objectID.uriRepresentation() }, ids)
        for store in reopened.container.persistentStoreCoordinator.persistentStores {
            try reopened.container.persistentStoreCoordinator.remove(store)
        }
    }
}

extension BeerWorkerTests {
    func testFailedMutationsDoNotPublishWidgetChanges() throws {
        let suite = "BeerWidgetFailureTests-\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set("Keep", forKey: "BRAND")
        let repository = BeerRepositorySpy()
        repository.updateReturn = false
        repository.deleteReturn = false
        repository.deleteAllReturn = false
        var reloads = 0
        let worker = BeerWorker(repository: repository, widgetDefaults: defaults, reloadWidget: { reloads += 1 })
        let beer = Beer.mock()
        let data = BeerData(brand: "New", value: 5, amount: 600)
        XCTAssertNil(worker.createBeer(data: data))
        XCTAssertFalse(worker.edit(beer: beer, data: data))
        XCTAssertFalse(worker.delete(beer: beer))
        XCTAssertFalse(worker.deleteAllBeers())
        XCTAssertEqual(defaults.string(forKey: "BRAND"), "Keep")
        XCTAssertEqual(reloads, 0)
    }

    func testWidgetDisabledForClipDoesNotRequestRefresh() {
        var reloads = 0
        let worker = BeerWorker(repository: BeerRepositorySpy(), widgetDefaults: nil, reloadWidget: { reloads += 1 })
        worker.refreshWidgetData()
        XCTAssertEqual(reloads, 0)
    }

    func testSharedVolumeAndSavingsFormatting() {
        XCTAssertEqual(BeerDisplay.amount(600), "600ml")
        XCTAssertEqual(BeerDisplay.amount(1000), "1 L")
        XCTAssertEqual(BeerDisplay.amount(1001), "1,001 L")
        XCTAssertEqual(BeerDisplay.amount(1500), "1,5 L")
        XCTAssertEqual(BeerDisplay.perLiter(2), "R$ 2,00/L")
    }
}
