//
//  HeadlineCard.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import Foundation
import SwiftUI

struct HeadlineCard: View {
    let headline: Headline
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(headline.originalText)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
            
            HStack {
                Text(headline.source.rawValue)
                    .font(.caption)
                    .foregroundColor(headline.source.color)
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal) // Add horizontal padding
    }
}

struct HeadlineCard_Previews: PreviewProvider {
    static var sampleHeadlines: [Headline] = [
        Headline(
            originalText: "Trump to continue swing state tradition in final campaign push",
            source: .foxNews
        ),
        Headline(
            originalText: "Biden leads in key battleground states, new poll shows",
            source: .cnn
        ),
        Headline(
            originalText: "Edu lined up for move to Premier League rivals after Arsenal exit",
            source: .fotmob
        )
    ]
    
    static var previews: some View {
        Group {
            // Single HeadlineCard
            HeadlineCard(headline: sampleHeadlines[0])
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("Fox News Headline")
            
            HeadlineCard(headline: sampleHeadlines[1])
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("CNN Headline")
            
            HeadlineCard(headline: sampleHeadlines[2])
                .previewLayout(.sizeThatFits)
                .padding()
                .previewDisplayName("FotMob Headline")
            
            // Dark mode preview
            HeadlineCard(headline: sampleHeadlines[0])
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
