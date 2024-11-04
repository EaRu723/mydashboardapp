//
//  ContentView.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Array(NewsCategory.allCases.enumerated()), id: \.element) { index, category in
                NewsContentView(category: category, viewModel: viewModel)
                    .tabItem {
                        Label(category.rawValue, systemImage: category.tabIcon)
                    }
                    .tag(index)
            }
        }
        .task {
            await viewModel.loadHeadlines()
        }
    }
}
