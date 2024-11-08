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
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        Button(action: {
            if let headlineLink = headline.link,
               let url = URL(string: headlineLink) {
                openURL(url)
            }
        }) {
            VStack(alignment: .leading, spacing: 8) {
                if headline.isProcessing {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .frame(height: 80) // Set appropriate height
                } else {
                    HStack {
                        Text(headline.source.rawValue)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(headline.source.color)
                        Spacer()
                    }
                    Text(headline.originalText)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .foregroundStyle(Color.primary)
                    
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

struct HeadlineCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            HeadlineCard(headline: Headline(
                originalText: "Sample headline with a longer text that might wrap to multiple lines to show how it looks",
                source: .cnn,
                isProcessing: false,
                link: "https://example.com"
            ))
            
            HeadlineCard(headline: Headline(
                originalText: "Another headline without a link to show the difference",
                source: .foxNews,
                isProcessing: false
            ))
            
            HeadlineCard(headline: Headline(
                originalText: "Processing headline",
                source: .theOnion,
                isProcessing: true
            ))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
