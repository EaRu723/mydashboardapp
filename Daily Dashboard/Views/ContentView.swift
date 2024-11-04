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
            ElectionsView(viewModel: viewModel)
                .tabItem {
                    Label("Elections", systemImage: "seal.fill")
                }
                .tag(0)
            
            TechnologyView(viewModel: viewModel)
                .tabItem {
                    Label("Technology", systemImage: "laptopcomputer")
                }
                .tag(1)
            
            BusinessView(viewModel: viewModel)
                .tabItem {
                    Label("Business", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)
            
            SportsView(viewModel: viewModel)
                .tabItem {
                    Label("Sports", systemImage: "sportscourt.fill")
                }
                .tag(3)
        }
        // Load all headlines when the app first launches
        .task {
            await viewModel.loadHeadlines()
        }
    }
}
