//
//  Untitled.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import Foundation

class HeadlineService {
    func headlineStream() -> AsyncStream<(NewsCategory, [Headline])> {
        AsyncStream { continuation in
            Task {
                do {
                    for category in NewsCategory.allCases {
                        let headlines = try await fetchHeadlinesByCategory(category)
                        print("Yielding \(headlines.count) headlines for \(category)")
                        continuation.yield((category, headlines))
                    }
                    continuation.finish()
                } catch {
                    print("Error in headline stream: \(error)")
                    continuation.finish()
                }
            }
        }
    }
    
    private func interweaveHeadlines(_ arrays: [[Headline]]) -> [Headline] {
        var result: [Headline] = []
        var indices = Array(repeating: 0, count: arrays.count)
        
        while true {
            var addedAny = false
            
            for i in 0..<arrays.count {
                if indices[i] < arrays[i].count {
                    result.append(arrays[i][indices[i]])
                    indices[i] += 1
                    addedAny = true
                }
            }
            
            if !addedAny {
                break
            }
        }
        
        return result
    }
    
    func fetchHeadlinesByCategory(_ category: NewsCategory) async throws -> [Headline] {
        switch category {
        case .elections:
            async let foxNews = fetchHeadlines(from: URLs.foxNews, source: .foxNews)
            async let cnn = fetchHeadlines(from: URLs.cnn, source: .cnn)
            async let onion = fetchHeadlines(from: URLs.onion, source: .theOnion)
            
            let (foxResults, cnnResults, onionResults) = try await (foxNews, cnn, onion)
            return interweaveHeadlines([foxResults, cnnResults, onionResults])
            
        case .sports:
            async let footballItalia = fetchHeadlines(from: URLs.footballItalia, source: .footballItalia)
            async let milan = fetchHeadlines(from: URLs.milan, source: .milan)
            let (footballItaliaResults, milanResults) = try await (footballItalia, milan)
            return interweaveHeadlines([footballItaliaResults, milanResults])
            
        case .technology:
            async let hackerNews = fetchHeadlines(from: URLs.hackerNews, source: .hackerNews)
            async let techCrunch = fetchHeadlines(from: URLs.techCrunch, source: .techCrunch)
            let (hackerNewsResults, techCrunchResults) = try await (hackerNews, techCrunch)
            return interweaveHeadlines([hackerNewsResults, techCrunchResults])
            
        case .business:
            async let ventureBeat = fetchHeadlines(from: URLs.ventureBeat, source: .ventureBeat)
            async let crunchBase = fetchHeadlines(from: URLs.crunchBase, source: .crunchBase)
            async let yahooFinance = fetchHeadlines(from: URLs.yahooFinance, source: .yahooFinance)
            let (ventureBeatResults, crunchBaseResults, yahooFinanceResults) = try await (ventureBeat, crunchBase, yahooFinance)
            return interweaveHeadlines([ventureBeatResults, crunchBaseResults, yahooFinanceResults])
        }
    }
    
    private func fetchHeadlines(from urlString: String, source: NewsSource) async throws -> [Headline] {
        print("Fetching headlines from: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Received data of size: \(data.count) bytes")
            
            // Print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data:")
                print(jsonString)
            }
            
            let response = try JSONDecoder().decode(HeadlineResponse.self, from: data)
            print("Decoded Response:")
            print("Query:", response.query)
            print("Results count:", response.results.count)
            print("First few results:")
            response.results.prefix(3).forEach { item in
                print("- Headline:", item.headline)
                print("  Link:", item.link ?? "No link")
            }
            
            let headlines = response.results.map { headlineItem in
                let headline = Headline(from: headlineItem, source: source)
                print("Mapped headline:")
                print("- Original text:", headline.originalText)
                print("- Source:", headline.source.rawValue)
                print("- ID:", headline.id)
                return headline
            }
            
            print("\nFinal headlines array count:", headlines.count)
            print("First few converted headlines:")
            headlines.prefix(3).forEach { headline in
                print("- Text:", headline.originalText)
                print("  Source:", headline.source.rawValue)
                print("  ID:", headline.id)
            }
            
            return headlines
        } catch {
            print("Error fetching headlines for \(source.rawValue):")
            print("Error details:", error)
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Missing key:", key)
                    print("Context:", context)
                case .typeMismatch(let type, let context):
                    print("Type mismatch. Expected:", type)
                    print("Context:", context)
                default:
                    print("Other decoding error:", decodingError)
                }
            }
            // Instead of throwing, return empty array to keep the stream going
            return []
        }
    }
}
