//
//  HeadlinesLIst.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/8/24.
//

import SwiftUI

struct HeadlinesList: View {
    let headlines: [Headline]
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(headlines) { headline in
                HeadlineCard(headline: headline)
                    .padding(.horizontal)
                Divider()
            }
        }
    }
}
