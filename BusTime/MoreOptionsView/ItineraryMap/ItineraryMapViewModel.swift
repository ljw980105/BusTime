//
//  ItineraryMapViewModel.swift
//  BusTime
//
//  Created by Anderson Li on 8/27/24.
//

import Foundation
import Shared

enum ItineraryKey: String {
    case londonTrip = "London_trip"
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
        for itinerary in itineraries {
            if itinerary.id == itineraryId {
                activeItinerary = itinerary
                return
            }
        }
    }
    
}
