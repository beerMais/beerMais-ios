//
//  BeerWorker.swift
//  BeerMais
//
//  Created by José Neves on 19/11/23.
//  Copyright © 2023 joseneves. All rights reserved.
//

import Foundation
import WidgetKit

import AmplitudeSwift

protocol BeerWorkerProtocol {
    @discardableResult func createBeer(data: BeerData) -> Beer?
    func getBeers() -> [Beer]
    func refreshWidgetData()
    @discardableResult func edit(beer: Beer, data: BeerData) -> Bool
    @discardableResult func deleteAllBeers() -> Bool
    @discardableResult func delete(beer: Beer) -> Bool
    
    func orderBeers(_ beers: [Beer]) -> [Beer]
    func getValuePerML(beer: Beer) -> Float
    func calcEconomyBetweenBeers(beer1: Beer, beer2: Beer) -> Float
    func formatBeerValueToShow(value: Float) -> String
    func calculateMostValuableBeer(beers: [Beer]) -> (Beer, Float?)?
}

final class BeerWorker: BeerWorkerProtocol {
    
    // MARK: - Private properties
    
    private let repository: BeerRepository
    private let widgetDefaults: UserDefaults?
    private let reloadWidget: () -> Void
    
    // MARK: - Initialization
    
    init(
        repository: BeerRepository,
        widgetDefaults: UserDefaults? = nil,
        reloadWidget: @escaping () -> Void = { WidgetCenter.shared.reloadAllTimelines() }
    ) {
        self.repository = repository
        self.widgetDefaults = widgetDefaults
        self.reloadWidget = reloadWidget
    }
    
    // MARK: - BeerWorkerProtocol
    
    @discardableResult func createBeer(data: BeerData) -> Beer? {
        guard let beer = repository.create(data: data) else { return nil }
        refreshWidgetData()
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "beer_created",
            eventProperties: beerToAnalyticsParameters(beer)
        ))
        
        return beer
    }
    
    func getBeers() -> [Beer] {
        return orderBeers(repository.fetchBeers())
    }
    
    @discardableResult func edit(beer: Beer, data: BeerData) -> Bool {
        guard repository.update(beer: beer, data: data) else { return false }
        refreshWidgetData()
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "beer_updated",
            eventProperties: beerToAnalyticsParameters(beer)
        ))
        return true
    }
    
    @discardableResult func deleteAllBeers() -> Bool {
        guard repository.deleteAll() else { return false }
        
        clearWidgetData()
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "all_beers_deleted",
            eventProperties: nil
        ))
        return true
    }
    
    @discardableResult func delete(beer: Beer) -> Bool {
        let parameters = beerToAnalyticsParameters(beer)
        guard repository.delete(beer: beer) else { return false }
        refreshWidgetData()
        
        AppP.amplitude.track(event: BaseEvent(
            eventType: "beer_deleted",
            eventProperties: parameters
        ))
        return true
    }
    
    func orderBeers(_ beers: [Beer]) -> [Beer] {
        beers
            .map { beer in
                (beer: beer, valuePerML: getValuePerML(beer: beer))
            }
            .sorted {
                if $0.valuePerML != $1.valuePerML { return $0.valuePerML < $1.valuePerML }
                // Permanent IDs keep equal-price rankings stable across fetches and relaunches.
                return $0.beer.objectID.uriRepresentation().absoluteString < $1.beer.objectID.uriRepresentation().absoluteString
            }
            .map(\.beer)
    }
    
    func getValuePerML(beer: Beer) -> Float {
        guard beer.amount > 0 else { return .infinity }
        return beer.value / Float(beer.amount)
    }
    
    func calcEconomyBetweenBeers(beer1: Beer, beer2: Beer) -> Float {
        (getValuePerML(beer: beer2) - getValuePerML(beer: beer1)) * 1000
    }
    
    func formatBeerValueToShow(value: Float) -> String {
        BeerDisplay.decimal(value)
    }
    
    func calculateMostValuableBeer(beers: [Beer]) -> (Beer, Float?)? {
        let ranked = orderBeers(beers)
        guard ranked.count >= 2, let mostValuableBeer = ranked.first else {
            return nil
        }
        
        let economy = calcEconomyBetweenBeers(beer1: mostValuableBeer, beer2: ranked[1])
        return (mostValuableBeer, economy)
    }
    
    // MARK: - Private methods
    
    private func beerToAnalyticsParameters(_ beer: Beer) -> [String: NSObject] {
        var parameters = [String: NSObject]()
        parameters["brand"] = beer.brand as NSObject?
        parameters["amount"] = beer.amount as NSObject?
        parameters["value"] = beer.value as NSObject?
        
        return parameters
    }
    
    func refreshWidgetData() {
        guard let defaults = widgetDefaults else { return }
        let beers = getBeers()
        guard let (mostValuableBeer, economy) = calculateMostValuableBeer(beers: beers) else {
            clearWidgetData()
            return
        }

        var hasChanges = false
        hasChanges = setWidgetValue(mostValuableBeer.brand, forKey: "BRAND", in: defaults) || hasChanges
        hasChanges = setWidgetValue(BeerDisplay.amount(mostValuableBeer.amount), forKey: "AMOUNT", in: defaults) || hasChanges
        hasChanges = setWidgetValue("R$ \(formatBeerValueToShow(value: mostValuableBeer.value))", forKey: "VALUE", in: defaults) || hasChanges
        hasChanges = setWidgetValue(String(mostValuableBeer.type), forKey: "TYPE", in: defaults) || hasChanges
        hasChanges = setWidgetValue(String(beers.count), forKey: "BEERS_COUNT", in: defaults) || hasChanges
        let economyText = economy.map { BeerDisplay.perLiter($0) }
        hasChanges = setWidgetValue(economyText, forKey: "ECONOMY", in: defaults) || hasChanges

        if hasChanges {
            reloadWidget()
        }
    }

    private func setWidgetValue(_ value: String?, forKey key: String, in defaults: UserDefaults) -> Bool {
        guard let value else {
            guard defaults.object(forKey: key) != nil else { return false }
            defaults.removeObject(forKey: key)
            return true
        }

        guard defaults.string(forKey: key) != value else { return false }
        defaults.set(value, forKey: key)
        return true
    }
    
    private func clearWidgetData() {
        guard let defaults = widgetDefaults else { return }

        let keys = ["BRAND", "AMOUNT", "VALUE", "TYPE", "BEERS_COUNT", "ECONOMY"]
        let hasChanges = keys.contains { defaults.object(forKey: $0) != nil }
        keys.forEach { defaults.removeObject(forKey: $0) }
        
        if hasChanges {
            reloadWidget()
        }
    }
}

// Strings used by cards and by the snapshot read by the widget.
enum BeerDisplay {
    static func decimal(_ value: Float) -> String {
        String(format: "%.2f", locale: Locale(identifier: "en_US_POSIX"), value)
            .replacingOccurrences(of: ".", with: ",")
    }

    static func perLiter(_ value: Float) -> String { "R$ \(decimal(value))/L" }

    static func amount(_ milliliters: Int16) -> String {
        guard milliliters >= 1000 else { return "\(milliliters)ml" }
        // Preserve custom volumes exactly, including 1001 ml.
        let liters = Int(milliliters) / 1000
        let remainder = Int(milliliters) % 1000
        guard remainder != 0 else { return "\(liters) L" }
        let fraction = String(format: "%03d", remainder).replacingOccurrences(of: "0+$", with: "", options: .regularExpression)
        return "\(liters),\(fraction) L"
    }
}
