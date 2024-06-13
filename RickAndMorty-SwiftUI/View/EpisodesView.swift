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
        }
        .onAppear {
            viewModel.fetchEpisodeData()
        }
        .navigationTitle("Episodes")
    }
}

class EpisodesViewModel: ObservableObject {
    
    @Published var episodes: [Episode] = []
    
    func fetchEpisodeData() {
        
        NetworkManager.shared.fetchData(from: .episodes) { (result: Result<EpisodeResults, any Error>) in
            switch result {
            case .success(let episodeResults):
                self.episodes = episodeResults.results
            case .failure(let error):
                print(error)
            }
        }
    }
}
