//
//  CharactersView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 13.06.24.
//

import SwiftUI

struct CharactersView: View {
    
    @ObservedObject var viewModel = CharactersViewModel()
    
    var body: some View {
        List(viewModel.characters) { character in
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
        .navigationTitle("Characters")
    }
}

class CharactersViewModel: ObservableObject {

    @Published var characters: [Character] = []
    @Published var isLoading = false
    private var nextPageURL: URL? = URL(string: "https://rickandmortyapi.com/api/character")
    
    init() {
        loadMoreContent()
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
    
    func loadMoreContent() {
        guard !isLoading, let nextPageURL = nextPageURL else {
            return
        }
        
        isLoading = true
        NetworkManager.shared.fetchData(from: .custom(url: nextPageURL)) { [weak self] (result: Result<CharacterResults, Error>) in
            switch result {
            case .success(let characterResults):
                DispatchQueue.main.async {
                    self?.characters.append(contentsOf: characterResults.results)
                    self?.nextPageURL = URL(string: characterResults.info.next ?? "")
                    self?.isLoading = false
                }
            case .failure(let error):
                print("Failed to fetch characters: \(error)")
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }
    }
}
