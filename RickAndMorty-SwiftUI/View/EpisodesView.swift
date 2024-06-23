//
//  EpisodesView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 13.06.24.
//

import SwiftUI

struct EpisodesView: View {
    
    @ObservedObject var viewModel = EpisodesViewModel()
    
    var body: some View {
        List(viewModel.episodes) { episode in
            NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                Text(episode.name)
            }
            .onAppear {
                viewModel.loadMoreContentIfNeeded(currentItem: episode)
            }
        }
        .navigationTitle("Episodes")
    }
}

class EpisodesViewModel: ObservableObject {
    
    @Published var episodes: [Episode] = []
    @Published var isLoading = false
    private var nextPageURL: URL? = URL(string: "https://rickandmortyapi.com/api/episode")
    
    init() {
        loadMoreContent()
    }
    
    func loadMoreContent() {
        guard !isLoading, let nextPageURL = nextPageURL else {
            return
        }
        
        isLoading = true
        
        NetworkManager.shared.fetchData(from: .custom(url: nextPageURL)) { [weak self] (result: Result<EpisodeResults, Error>) in
            switch result {
            case .success(let episodeResults):
                DispatchQueue.main.async {
                    self?.episodes.append(contentsOf: episodeResults.results)
                    self?.nextPageURL = URL(string: episodeResults.info.next ?? "")
                    self?.isLoading = false
                }
            case .failure(let error):
                print("Failed to fetch episodes: \(error)")
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }
    }
    
    func loadMoreContentIfNeeded(currentItem episode: Episode?) {
        guard let episode = episode else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = episodes.index(episodes.endIndex, offsetBy: -5)
        if episodes.firstIndex(where: { $0.id == episode.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
}
