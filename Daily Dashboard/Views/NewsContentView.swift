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
            ZStack {
                ScrollView {
                    VStack(spacing: 12) {
                        SourceFilterView(category: category, viewModel: viewModel)
                        
                        if viewModel.isLoading {
                            LoadingHeadlinesList()
                        } else {
                            HeadlinesList(headlines: viewModel.headlinesForCategory(category))
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
