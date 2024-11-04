//
//  Untitled.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import Foundation

class HeadlineService {
    
    func fetchHeadlinesByCategory(_ category: NewsCategory) async throws -> [Headline] {
        switch category {
        case .elections:
            async let foxNews = fetchHeadlines(from: URLs.foxNews, source: .foxNews)
            async let cnn = fetchHeadlines(from: URLs.cnn, source: .cnn)
            async let onion = fetchHeadlines(from: URLs.onion, source: .theOnion)
            
            let (foxResults, cnnResults, onionResults) = try await (foxNews, cnn, onion)
            return foxResults + cnnResults + onionResults
            
        case .sports:
            async let fotmob = fetchHeadlines(from: URLs.fotmob, source: .fotmob)
            async let milan = fetchHeadlines(from: URLs.milan, source: .milan)
            let (fotmobResults, milanResults) = try await (fotmob, milan)
            return fotmobResults + milanResults
            
        case .technology:
            async let hackerNews = fetchHeadlines(from: URLs.hackerNews, source: .hackerNews)
            async let techCrunch = fetchHeadlines(from: URLs.techCrunch, source: .techCrunch)
            let (hackerNewsResults, techCrunchResults) = try await (hackerNews, techCrunch)
            return hackerNewsResults + techCrunchResults
            
        case .business:
            async let ventureBeat = fetchHeadlines(from: URLs.ventureBeat, source: .ventureBeat)
            async let techCrunchVC = fetchHeadlines(from: URLs.techCrunchVC, source: .techCrunchVC)
            let (ventureBeatResults, techCrunchVCResults) = try await (ventureBeat, techCrunchVC)
            return ventureBeatResults + techCrunchVCResults
        }
    }
    
    func fetchAllHeadlines() async throws -> [Headline] {
        async let elections = fetchHeadlinesByCategory(.elections)
        async let sports = fetchHeadlinesByCategory(.sports)
        async let technology = fetchHeadlinesByCategory(.technology)
        async let business = fetchHeadlinesByCategory(.business)
        
        let (electionNews, sportsNews, techNews, businessNews) = try await (
            elections, sports, technology, business
        )
        
        return electionNews + sportsNews + techNews + businessNews
    }
    
    
    private func fetchHeadlines(from urlString: String, source: NewsSource) async throws -> [Headline] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(HeadlineResponse.self, from: data)
        
        return response.results.map { Headline(from: $0, source: source) }
    }
}
