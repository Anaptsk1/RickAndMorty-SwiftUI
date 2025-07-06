//
//  EpisodeDetailView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 13.06.24.
//

import SwiftUI

struct EpisodeDetailView: View {
    
    var episode: Episode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name \(episode.name)")
            Text("Air date \(episode.air_date)")
            Text("Episode \(episode.episode)")
        }
        .padding()
        .navigationTitle(episode.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

