//
//  Headline.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import Foundation
import SwiftUI

struct HeadlineResponse: Codable {
    let query: [[String]]
    let results: [HeadlineItem]
}

struct HeadlineItem: Codable, Identifiable {
    let headline: String
    let link: String?
    
    var id: String { headline }
    
    // Move CodingKeys inside HeadlineItem
    private enum CodingKeys: String, CodingKey {
        case headline = "Headline"
        case link = "Link"
    }
    
    // Add decoder init for HeadlineItem
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        headline = try container.decode(String.self, forKey: .headline)
        link = try container.decodeIfPresent(String.self, forKey: .link)
    }
}

struct Headline: Identifiable, Codable {
    let id: UUID
    let originalText: String
    let source: NewsSource
    var isProcessing: Bool
    let link: String?
    
    init(id: UUID = UUID(), originalText: String, source: NewsSource, isProcessing: Bool = false, link: String? = nil) {
        self.id = id
        self.originalText = originalText
        self.source = source
        self.isProcessing = isProcessing
        self.link = link
    }
    
    init(from headlineItem: HeadlineItem, source: NewsSource) {
        self.id = UUID()
        self.originalText = headlineItem.headline
        self.source = source
        self.isProcessing = false
        self.link = headlineItem.link
    }
}

enum NewsSource: String, Codable, CaseIterable {
    case foxNews = "Fox News"
    case cnn = "CNN"
    case theOnion = "The Onion"
    case footballItalia = "Football Italia"
    case milan = "Sempre Milan"
    case hackerNews = "Hacker News"
    case techCrunch = "Tech Crunch"
    case ventureBeat = "Venture Beat"
    case crunchBase = "Crunch Base"
    case yahooFinance = "Yahoo Finance"
    
    var color: Color {
        switch self {
        case .foxNews: return .red
        case .cnn: return .blue
        case .theOnion: return .green
        case .footballItalia: return .green
        case .milan: return .red
        case .hackerNews: return .orange
        case .techCrunch: return .green
        case .ventureBeat: return .pink
        case .crunchBase: return .green
        case .yahooFinance: return .purple
        }
    }
}
