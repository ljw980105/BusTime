//
//  GTFSRealTime.swift
//  BusTime
//
//  Created by Anderson Li on 12/1/24.
//
import Foundation

public struct GTFSRealTime: Codable {
    public let header: Header
    public let entity: [Entity]
}

public extension GTFSRealTime {
    struct Header: Codable {
        public let gtfsRealtimeVersion: String
        public let incrementality: String
        public let timestamp: Int
        
        public enum CodingKeys: String, CodingKey {
            case gtfsRealtimeVersion = "gtfs_realtime_version"
            case incrementality = "incrementality"
            case timestamp = "timestamp"
        }
    }
    
    struct Entity: Codable {
        public let id: String
        public let alert: EntityAlert
    }
    
    struct EntityAlert: Codable {
        public let activePeriod: [ActivePeriod]
        public let informedEntity: [InformedEntity]
        public let headerText: HeaderText
        public let descriptionText: DescriptionText?
        public let realtimeMercuryAlert: RealtimeMercuryAlert
        
        public enum CodingKeys: String, CodingKey {
            case activePeriod = "active_period"
            case informedEntity = "informed_entity"
            case headerText = "header_text"
            case descriptionText = "description_text"
            case realtimeMercuryAlert = "transit_realtime.mercury_alert"
        }
    }
    
    struct ActivePeriod: Codable {
        public let start: Int
        public let end: Int?
    }
    
    struct InformedEntity: Codable {
        public let agencyId: String
        public let routeId: String?
        public let sortOrder: SortOrder?
        
        public enum CodingKeys: String, CodingKey {
            case agencyId = "agency_id"
            case routeId = "route_id"
            case sortOrder = "transit_realtime.mercury_entity_selector"
        }
    }
    
    struct SortOrder: Codable {
        public let sortOrder: String
        
        public enum CodingKeys: String, CodingKey {
            case sortOrder = "sort_order"
        }
    }
    
    struct HeaderText: Codable {
        public let translation: [Translation]
    }
    
    struct Translation: Codable {
        public let text: String
        public let language: TranslationLanguage
    }
    
    enum TranslationLanguage: String, Codable {
        case en = "en"
        case html = "en-html"
    }
    
    struct DescriptionText: Codable {
        public let translation: [Translation]
    }
    
    struct RealtimeMercuryAlert: Codable {
        public enum CodingKeys: String, CodingKey {
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case alertType = "alert_type"
            case displayBeforeActive = "display_before_active"
        }
        
        public let createdAt: Int
        public let updatedAt: Int
        public let alertType: String
        public let displayBeforeActive: Int?
    }
}

public extension GTFSRealTime.ActivePeriod {
    var startDate: Date {
        Date(timeIntervalSince1970: TimeInterval(start))
    }
    
    var endDate: Date? {
        guard let end else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(end))
    }
}


public extension GTFSRealTime.HeaderText {
    var firstEnTranslation: String? {
        translation.first(where: { $0.language == .en })?.text
    }
}

public extension GTFSRealTime.DescriptionText {
    var firstEnTranslation: String? {
        translation.first(where: { $0.language == .en })?.text
    }
}


