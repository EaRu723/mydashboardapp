//
//  NewsContentView.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import SwiftUI

struct ElectionsView: View {
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        NewsContentView(category: .elections, viewModel: viewModel)
    }
}

struct TechnologyView: View {
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        NewsContentView(category: .technology, viewModel: viewModel)
    }
}

struct BusinessView: View {
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        NewsContentView(category: .business, viewModel: viewModel)
    }
}

struct SportsView: View {
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        NewsContentView(category: .sports, viewModel: viewModel)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading headlines...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NewsContentView: View {
    let category: NewsCategory
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 12) {
                        SourceFilterView(category: category, viewModel: viewModel)
                        
                        if viewModel.isLoading {
                            ForEach(0..<5) { _ in
                                LoadingHeadlineCard()
                                    .padding(.horizontal)
                            }
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.headlinesForCategory(category)) { headline in
                                    HeadlineCard(headline: headline)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                
                if viewModel.isLoading && viewModel.headlinesForCategory(category).isEmpty {
                    LoadingView()
                }
            }
            .navigationTitle(category.rawValue)
            .task {
                if viewModel.headlinesForCategory(category).isEmpty {
                    await viewModel.loadHeadlines()
                }
            }
            .refreshable {
                await viewModel.loadHeadlines()
            }
        }
    }
}

struct LoadingHeadlineCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Headline placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 16)
                .cornerRadius(4)
            
            // Second line placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: UIScreen.main.bounds.width * 0.6, height: 16)
                .cornerRadius(4)
            
            // Source placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 100, height: 12)
                .cornerRadius(4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .opacity(isAnimating ? 0.6 : 1.0)
        .animation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}
