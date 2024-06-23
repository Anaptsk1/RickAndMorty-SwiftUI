//
//  CharactersView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 13.06.24.
//

import SwiftUI

struct CharactersView: View {
    
    @StateObject var viewModel = CharactersViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: -8) {
                List(viewModel.filteredCharacters) { character in
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: character.image)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        
                        NavigationLink(destination: CharacterDetailView(character: character)) {
                            Text(character.name)
                                .font(.headline)
                        }
                        Text(character.species)
                            .font(.subheadline)
                    }
                    .onAppear {
                        viewModel.loadMoreContentIfNeeded(currentItem: character)
                    }
                }
            }
            .navigationTitle("Characters")
            .navigationBarTitleDisplayMode(.automatic)
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { oldValue, newValue in
                viewModel.filteredCharacters = viewModel.characters.filter { character in
                    newValue.isEmpty || character.name.localizedCaseInsensitiveContains(newValue)
                }
            }
        }
    }
    
    class CharactersViewModel: ObservableObject {
        
        @Published var characters: [Character] = []
        @Published var filteredCharacters: [Character] = []
        @Published var searchText = ""
        @Published var isLoading = false
        private var nextPageURL: URL? = URL(string: "https://rickandmortyapi.com/api/character")
        
        init() {
            loadMoreContent()
        }
        
        func loadMoreContent() {
            guard !isLoading, let nextPageURL = nextPageURL else {
                return
            }
            
            isLoading = true
            
            NetworkManager.shared.fetchData(from: .custom(url: nextPageURL)) { [weak self] (result: Result<CharacterResults, Error>) in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let characterResults):
                        self?.characters.append(contentsOf: characterResults.results)
                        self?.filteredCharacters = self?.characters.filter { self?.searchText.isEmpty ?? true || $0.name.localizedCaseInsensitiveContains(self?.searchText ?? "") } ?? []
                        self?.nextPageURL = URL(string: characterResults.info.next ?? "")
                    case .failure(let error):
                        print("Failed to fetch characters: \(error)")
                    }
                }
            }
        }
        
        func loadMoreContentIfNeeded(currentItem character: Character?) {
            guard let character = character else {
                loadMoreContent()
                return
            }
            
            let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
            if characters.firstIndex(where: { $0.id == character.id }) == thresholdIndex {
                loadMoreContent()
            }
        }
    }
}
