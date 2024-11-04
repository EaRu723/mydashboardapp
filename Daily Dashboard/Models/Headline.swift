//
//  Headline.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import Foundation
import SwiftUI

struct HeadlineResponse: Codable {
    let query: String
    let results: [HeadlineItem]
}

struct HeadlineItem: Codable, Identifiable {
    let headline: String
    var id: String { headline }
}

struct Headline: Identifiable, Codable {
    let id: UUID
    let originalText: String
    let source: NewsSource
    var isProcessing: Bool
    
    init(id: UUID = UUID(), originalText: String, source: NewsSource, isProcessing: Bool = false) {
        self.id = id
        self.originalText = originalText
        self.source = source
        self.isProcessing = isProcessing
    }
    
    init(from headlineItem: HeadlineItem, source: NewsSource) {
        self.id = UUID()
        self.originalText = headlineItem.headline
        self.source = source
        self.isProcessing = false
    }
}

enum NewsSource: String, Codable, CaseIterable {
    case foxNews = "Fox News"
    case cnn = "CNN"
    case theOnion = "The Onion"
    case fotmob = "FotMob"
    case milan = "Milan"
    case hackerNews = "Hacker News"
    case techCrunch = "TechCrunch"
    case ventureBeat = "VentureBeat"
    case techCrunchVC = "TechCrunchVC"
    
    var color: Color {
        switch self {
        case .foxNews: return .red
        case .cnn: return .blue
        case .theOnion: return .green
        case .fotmob: return .purple
        case .milan: return .black
        case .hackerNews: return .orange
        case .techCrunch: return .yellow
        case .ventureBeat: return .pink
        case .techCrunchVC: return .cyan
        }
    }
}
