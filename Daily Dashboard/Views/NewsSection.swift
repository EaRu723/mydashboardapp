//
//  NewsSection.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import Foundation
import SwiftUI

struct NewsSection: View {
    let category: NewsCategory
    let headlines: [Headline]
    let cardWidth: CGFloat
    @ObservedObject var viewModel: NewsViewModel
    
    init(category: NewsCategory,
         headlines: [Headline],
         cardWidth: CGFloat = 300,
         viewModel: NewsViewModel) {
        self.category = category
        self.headlines = headlines
        self.cardWidth = cardWidth
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: category.systemImage)
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(category.rawValue)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal)
            
            // Add the source filter
            SourceFilterView(category: category, viewModel: viewModel)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(headlines) { headline in
                        HeadlineCard(headline: headline)
                            .frame(width: cardWidth)
                    }
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct NewsSection_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = NewsViewModel()
        NewsSection(
            category: .technology,
            headlines: [
                Headline(originalText: "First Headline", source: .techCrunch),
                Headline(originalText: "Second Headline", source: .hackerNews),
                Headline(originalText: "Third Headline", source: .ventureBeat)
            ],
            viewModel: viewModel
        )
        .previewLayout(.sizeThatFits)
    }
}
