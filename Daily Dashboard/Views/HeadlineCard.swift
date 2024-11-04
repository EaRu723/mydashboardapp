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
            if headline.isProcessing {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 80) // Set appropriate height
            } else {
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
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}