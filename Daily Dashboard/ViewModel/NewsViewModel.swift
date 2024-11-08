//
//  NewsViewModel.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import Foundation

@MainActor
class NewsViewModel: ObservableObject {
    @Published private(set) var headlinesByCategory: [NewsCategory: [Headline]] = [:]
    @Published var isLoading = false
    @Published var selectedCategory: NewsCategory = .elections
    @Published var selectedSources: Set<NewsSource> = []
    
    private let headlineService: HeadlineService
    
    
    init(headlineService: HeadlineService = HeadlineService()) {
        self.headlineService = headlineService
        
        // Initialize empty arrays for each category
        for category in NewsCategory.allCases {
            headlinesByCategory[category] = []
            selectedSources.formUnion(sourcesForCategory(category))
        }
    }
    
    func sourcesForCategory(_ category: NewsCategory) -> [NewsSource] {
        switch category {
        case .elections:
            return [.foxNews, .cnn, .theOnion]
        case .sports:
            return [.footballItalia, .milan]
        case .technology:
            return [.hackerNews, .techCrunch]
        case .business:
            return [.ventureBeat, .crunchBase, .yahooFinance]
        }
    }
    
    func loadHeadlines() async {
        isLoading = true
        print("Starting to load headlines")
        
        // Clear existing headlines
        for category in NewsCategory.allCases {
            headlinesByCategory[category] = []
        }
        
        do {
            // Process the stream of headlines
            for try await (category, headlines) in headlineService.headlineStream() {
                print("Received \(headlines.count) headlines for \(category)")
                await MainActor.run {
                    self.headlinesByCategory[category] = headlines
                    print("Stored \(headlines.count) headlines in \(category) category")
                }
            }
        } catch {
            print("Error loading headlines: \(error)")
        }
        
        isLoading = false
    }
    
    func headlinesForCategory(_ category: NewsCategory) -> [Headline] {
        let headlines = headlinesByCategory[category] ?? []
        let filtered = headlines.filter { selectedSources.contains($0.source) }
        print("""
            Category: \(category)
            Available headlines: \(headlines.count)
            Selected sources: \(selectedSources)
            Filtered headlines: \(filtered.count)
            First headline (if any): \(filtered.first?.originalText ?? "none")
            """)
        return filtered
    }
}
