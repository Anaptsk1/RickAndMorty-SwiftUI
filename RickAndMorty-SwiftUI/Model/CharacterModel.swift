//
//  CharacterModel.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 03.05.25.
//

import Foundation

class CharacterModel: ObservableObject {
    
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



