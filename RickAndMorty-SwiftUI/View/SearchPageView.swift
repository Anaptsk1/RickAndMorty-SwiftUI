//
//  SearchPageView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 03.05.25.
//

import SwiftUI

struct SearchPageView: View {
    
    @ObservedObject var viewModel: CharacterModel
    
    init(viewModel: CharacterModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    ForEach(viewModel.filteredCharacters) { character in
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: character.image)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 300, height: 300)
                            .shadow(radius: 5)
                        }
                        .padding(.top)
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { oldValue, newValue in
                viewModel.filteredCharacters = viewModel.characters.filter { character in
                    newValue.isEmpty || character.name.localizedCaseInsensitiveContains(newValue)
                }
            }
        }
    }
}

