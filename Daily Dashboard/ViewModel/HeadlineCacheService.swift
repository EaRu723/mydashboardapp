//
//  HeadlineCacheService.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import Foundation

actor HeadlineCacheService {
    // Cache structure to store headlines with timestamps
    private struct CacheEntry: Codable {
        let headlines: [NewsCategory: [Headline]]
        let timestamp: Date
    }
    
    private let cache = NSCache<NSString, NSData>()
    private let cacheFileName = "headline_cache.json"
    private let cacheValidityDuration: TimeInterval = 30 * 60 // 30 minutes
    
    // Get cached headlines if they're still valid
    func getCachedHeadlines() -> [NewsCategory: [Headline]]? {
        if let cachedData = loadFromDisk() {
            let decoder = JSONDecoder()
            if let cacheEntry = try? decoder.decode(CacheEntry.self, from: cachedData),
               Date().timeIntervalSince(cacheEntry.timestamp) < cacheValidityDuration {
                return cacheEntry.headlines
            }
        }
        return nil
    }
    
    // Save headlines to both memory and disk
    func cacheHeadlines(_ headlines: [NewsCategory: [Headline]]) {
        let cacheEntry = CacheEntry(headlines: headlines, timestamp: Date())
        let encoder = JSONEncoder()
        
        if let encodedData = try? encoder.encode(cacheEntry) {
            // Cache in memory
            cache.setObject(encodedData as NSData, forKey: cacheFileName as NSString)
            // Cache to disk
            saveToDisk(encodedData)
        }
    }
    
    // Clear cache (useful for force refresh)
    func clearCache() {
        cache.removeObject(forKey: cacheFileName as NSString)
        try? FileManager.default.removeItem(at: getCacheFileURL())
    }
    
    private func getCacheFileURL() -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent(cacheFileName)
    }
    
    private func saveToDisk(_ data: Data) {
        try? data.write(to: getCacheFileURL())
    }
    
    private func loadFromDisk() -> Data? {
        try? Data(contentsOf: getCacheFileURL())
    }
}
