//
//  NewsViewModel.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import Foundation

@MainActor
class NewsViewModel: ObservableObject {
    @Published var headlines: [Headline] = []
    @Published var isLoading = false
    @Published var selectedCategory: NewsCategory = .elections
    @Published var selectedSources: Set<NewsSource> = []
    
    private let headlineService: HeadlineService
    
    init(headlineService: HeadlineService = HeadlineService()) {
        self.headlineService = headlineService
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
        return headlines.filter { headline in
            switch category {
            case .elections:
                return [.foxNews, .cnn, .theOnion].contains(headline.source) && selectedSources.contains(headline.source)
            case .sports:
                return [.fotmob, .milan].contains(headline.source) && selectedSources.contains(headline.source)
            case .technology:
                return [.hackerNews, .techCrunch].contains(headline.source) && selectedSources.contains(headline.source)
            case .business:
                return [.ventureBeat, .techCrunchVC].contains(headline.source) && selectedSources.contains(headline.source)
            }
        }
    }

    
    func loadHeadlines() async {
        isLoading = true
        do {
            headlines = try await headlineService.fetchAllHeadlines()
        } catch {
            print("Error loading headlines: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
}
