//
//  NewsContentView.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import SwiftUI

extension NewsCategory {
    var tabIcon: String {
        switch self {
        case .elections: return "seal.fill"
        case .technology: return "laptopcomputer"
        case .business: return "chart.line.uptrend.xyaxis"
        case .sports: return "sportscourt.fill"
        }
    }
}

struct NewsContentView: View {
    let category: NewsCategory
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Sticky Header
                VStack(spacing: 16) {
                    Text(category.rawValue)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    SourceFilterView(category: category, viewModel: viewModel)
                }
                .padding(.vertical)
                .background(
                    Color(UIColor.systemBackground)
                        .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
                )
                
                // Scrollable Content
                ZStack {
                    ScrollView {
                        if viewModel.isLoading {
                            LoadingHeadlinesList()
                        } else {
                            HeadlinesList(headlines: viewModel.headlinesForCategory(category))
                        }
                    }
                    
                    if viewModel.isLoading && viewModel.headlinesForCategory(category).isEmpty {
                        LoadingView()
                    }
                }
                .padding(.top)
            }
            .navigationBarHidden(true)
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
