//
//  SourceFilterView.swift
//  Daily Dashboard
//
//  Created by Andrea Russo on 11/4/24.
//

import SwiftUI

struct SourceFilterView: View {
    let category: NewsCategory
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.sourcesForCategory(category), id: \.self) { source in
                    Toggle(isOn: Binding(
                        get: { viewModel.selectedSources.contains(source) },
                        set: { isSelected in
                            if isSelected {
                                viewModel.selectedSources.insert(source)
                            } else {
                                viewModel.selectedSources.remove(source)
                            }
                        }
                    )) {
                        Text(source.rawValue)
                            .font(.caption)
                    }
                    .toggleStyle(ButtonToggleStyle())
                    .tint(source.color)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ButtonToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    configuration.isOn ? Color.accentColor : Color(.systemGray6)
                )
                .foregroundColor(configuration.isOn ? .white : .primary)
                .cornerRadius(20)
        }
    }
}
