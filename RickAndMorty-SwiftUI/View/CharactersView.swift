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
        NavigationStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.filteredCharacters) { character in
                        NavigationLink(destination: CharacterDetailView(character: character)) {
                            AsyncImage(url: URL(string: character.image)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                        }
                    }
                    .padding(.trailing)
                }
                .padding()
            }
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    ForEach(viewModel.filteredCharacters) { character in
                        VStack(alignment: .leading) {
                            HStack {
                                Circle()
                                    .fill(Color.gray)
                                    .scaledToFit().frame(width: 40, height: 40)
                                Text("@userName")
                            }
                            .padding(.leading)
                            AsyncImage(url: URL(string: character.image)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: .infinity, height: 300)
                            .shadow(radius: 5)
                            
                            HStack {
                                Image(systemName: "heart")
                                Image(systemName: "bubble.right")
                            }
                            .font(.title2)
                            .padding()
                            
                        }
//                        .onAppear {
//                            viewModel.loadMoreContentIfNeeded(currentItem: character)
//                        }
                    }
                }
            }
            //            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Button(action: {
                                print("followers button selected")
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "person.2")
                                    Text("Followers")
                                }
                            }
                            Button(action: {
                                print("favourites button selected")
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "star")
                                    Text("Favourites")
                                }
                            }
                        } label: {
                            HStack {
                                Text("For You")
                                    .font(.title).bold()
                                Image(systemName: "chevron.down")
                                    .font(.callout)
                            }
                            .foregroundStyle(Color.accentColor)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: Text("Heart")) {
                            Image(systemName: "heart")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                //            .searchable(text: $viewModel.searchText)
                //            .onChange(of: viewModel.searchText) { oldValue, newValue in
                //                viewModel.filteredCharacters = viewModel.characters.filter { character in
                //                    newValue.isEmpty || character.name.localizedCaseInsensitiveContains(newValue)
                //                }
                //            }
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

