//
//  NewsCategory.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import Foundation

enum NewsCategory: String, Codable, CaseIterable {
    case elections = "Elections"
    case technology = "Technology"
    case business = "Business"
    case sports = "Sports"
    
    var systemImage: String {
        switch self {
        case .elections: return "checkmark.circle"
        case .technology: return "laptopcomputer"
        case .business: return "chart.line.uptrend.xyaxis"
        case .sports: return "sportscourt"
        }
    }
}
