//
//  ContentView.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var showAllCategories = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Category selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            Button(action: {
                                showAllCategories = true
                            }) {
                                HStack {
                                    Image(systemName: "square.grid.2x2")
                                    Text("All")
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(showAllCategories ? Color.accentColor : Color(.systemGray6))
                                .foregroundColor(showAllCategories ? .white : .primary)
                                .cornerRadius(20)
                            }
                            
                            ForEach(NewsCategory.allCases, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: !showAllCategories && viewModel.selectedCategory == category,
                                    action: {
                                        viewModel.selectedCategory = category
                                        showAllCategories = false
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    } else {
                        if showAllCategories {
                            // Show all categories
                            ForEach(NewsCategory.allCases, id: \.self) { category in
                                NewsSection(
                                    category: category,
                                    headlines: viewModel.headlinesForCategory(category),
                                    viewModel: viewModel
                                )
                                
                                if category != NewsCategory.allCases.last {
                                    Divider()
                                        .padding(.horizontal)
                                }
                            }
                        } else {
                            // Show selected category only
                            VStack(spacing: 12) {
                                SourceFilterView(category: viewModel.selectedCategory, viewModel: viewModel)
                                
                                LazyVStack(spacing: 12) {
                                    ForEach(viewModel.headlinesForCategory(viewModel.selectedCategory)) { headline in
                                        HeadlineCard(headline: headline)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }                    }
                }
            }
            .navigationTitle("News Dashboard")
            .task {
                await viewModel.loadHeadlines()
            }
            .refreshable {
                await viewModel.loadHeadlines()
            }
        }
    }
}
