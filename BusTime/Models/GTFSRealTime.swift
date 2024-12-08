//
//  GTFSRealTime.swift
//  BusTime
//
//  Created by Anderson Li on 12/1/24.
//
import Foundation

struct GTFSRealTime: Codable {
    let header: Header
    let entity: [Entity]
}

extension GTFSRealTime {
    struct Header: Codable {
        let gtfsRealtimeVersion: String
        let incrementality: String
        let timestamp: Int
        
        enum CodingKeys: String, CodingKey {
            case gtfsRealtimeVersion = "gtfs_realtime_version"
            case incrementality = "incrementality"
            case timestamp = "timestamp"
        }
    }
    
    struct Entity: Codable {
        let id: String
        let alert: EntityAlert
    }
    
    struct EntityAlert: Codable {
        let activePeriod: [ActivePeriod]
        let informedEntity: [InformedEntity]
        let headerText: HeaderText
        let descriptionText: DescriptionText?
        let realtimeMercuryAlert: RealtimeMercuryAlert
        
        enum CodingKeys: String, CodingKey {
            case activePeriod = "active_period"
            case informedEntity = "informed_entity"
            case headerText = "header_text"
            case descriptionText = "description_text"
            case realtimeMercuryAlert = "transit_realtime.mercury_alert"
        }
    }
    
    struct ActivePeriod: Codable {
        let start: Int
        let end: Int?
    }
    
    struct InformedEntity: Codable {
        let agencyId: String
        let routeId: String?
        let sortOrder: SortOrder?
        
        enum CodingKeys: String, CodingKey {
            case agencyId = "agency_id"
            case routeId = "route_id"
            case sortOrder = "transit_realtime.mercury_entity_selector"
        }
    }
    
    struct SortOrder: Codable {
        let sortOrder: String
        
        enum CodingKeys: String, CodingKey {
            case sortOrder = "sort_order"
        }
    }
    
    struct HeaderText: Codable {
        let translation: [Translation]
    }
    
    struct Translation: Codable {
        let text: String
        let language: TranslationLanguage
    }
    
    enum TranslationLanguage: String, Codable {
        case en = "en"
        case html = "en-html"
    }
    
    struct DescriptionText: Codable {
        let translation: [Translation]
    }
    
    struct RealtimeMercuryAlert: Codable {
        enum CodingKeys: String, CodingKey {
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case alertType = "alert_type"
            case displayBeforeActive = "display_before_active"
        }
        
        let createdAt: Int
        let updatedAt: Int
        let alertType: String
        let displayBeforeActive: Int?
    }
}

extension GTFSRealTime.ActivePeriod {
    var startDate: Date {
        Date(timeIntervalSince1970: TimeInterval(start))
    }
    
    var endDate: Date? {
        guard let end else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(end))
    }
}


extension GTFSRealTime.HeaderText {
    var firstEnTranslation: String? {
        translation.first(where: { $0.language == .en })?.text
    }
}

extension GTFSRealTime.DescriptionText {
    var firstEnTranslation: String? {
        translation.first(where: { $0.language == .en })?.text
    }
}


