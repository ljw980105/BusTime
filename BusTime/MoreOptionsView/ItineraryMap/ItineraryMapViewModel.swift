//
//  ItineraryMapViewModel.swift
//  BusTime
//
//  Created by Anderson Li on 8/27/24.
//

import Foundation
import Shared

enum ItineraryKey: String {
    /// Aug-Sep 2024
    case londonTrip = "London_trip"
    /// Dec 2024
    case philadelphiaTrip = "Philadelphia_trip"
    /// Aug 2025
    case edinburghTrip = "Edinburgh_trip"
}

class ItineraryMapViewModel: ObservableObject {
    let itineraries: [Itinerary]
    @Published var activeItinerary: Itinerary
    let itineraryKey: ItineraryKey
    
    var userDefaults: UserDefaults {
        .standard
    }
    
    init(itineraries: [Itinerary], key: ItineraryKey) {
        self.itineraries = itineraries
        self.itineraryKey = key
        activeItinerary = itineraries.first ?? .stub
    }
    
    func saveItinerary() {
        userDefaults.set(activeItinerary.description, forKey: itineraryKey.rawValue)
    }
    
    func loadItinerary() {
        guard let itineraryId = userDefaults.string(forKey: itineraryKey.rawValue) else {
            return
        }
        if let itinerary = itineraries.first(where: { $0.id == itineraryId }) {
            activeItinerary = itinerary
        }
    }
    
}
