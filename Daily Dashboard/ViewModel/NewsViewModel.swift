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
    private let cacheService: HeadlineCacheService
    
    
    init(headlineService: HeadlineService = HeadlineService(), cacheService: HeadlineCacheService = HeadlineCacheService()) {
        self.headlineService = headlineService
        self.cacheService = cacheService
        
        // Initialize empty arrays for each category
        for category in NewsCategory.allCases {
            headlinesByCategory[category] = []
        }
    }
    
    func sourcesForCategory(_ category: NewsCategory) -> [NewsSource] {
        switch category {
        case .elections:
            return [.foxNews, .cnn, .theOnion]
        case .sports:
            return [.fotmob, .milan]
        case .technology:
            return [.hackerNews, .techCrunch]
        case .business:
            return [.ventureBeat, .techCrunchVC]
        }
    }
    
    func headlinesForCategory(_ category: NewsCategory) -> [Headline] {
        let headlines = headlinesByCategory[category] ?? []
        return headlines.filter { selectedSources.contains($0.source) }
    }
    
    func loadHeadlines() async {
        isLoading = true
        
        // Try to load from cache first
        if let cachedHeadlines = await cacheService.getCachedHeadlines() {
            headlinesByCategory = cachedHeadlines
            isLoading = false
            return
        }
        
        // If no cache or expired, load fresh data
        for category in NewsCategory.allCases {
            headlinesByCategory[category] = []
        }
        
        do {
            for try await (category, headlines) in headlineService.headlineStream() {
                headlinesByCategory[category] = headlines
                
                let categorySources = Set(sourcesForCategory(category))
                if selectedSources.intersection(categorySources).isEmpty {
                    selectedSources.formUnion(categorySources)
                }
            }
            // Cache the fresh headlines
            await cacheService.cacheHeadlines(headlinesByCategory)
        } catch {
            print("Error loading headlines: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}
