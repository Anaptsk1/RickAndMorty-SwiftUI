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
            NavigationLink(destination: CharacterDetailView(character: character)) {
                Text(character.name)
            }
        }
        .onAppear {
            viewModel.fetchCharacters()
        }
        .navigationTitle("Characters")
    }
}

class CharactersViewModel: ObservableObject {
    
    @Published var characters: [Character] = []
    
    func fetchCharacters() {
        NetworkManager.shared.fetchData(from: .characters) { (result: Result<CharacterResults, Error>) in
            switch result {
            case .success(let characterResults):
                self.characters = characterResults.results
            case .failure(let error):
                print(error)
            }
        }
    }
}


