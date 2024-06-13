//
//  CharacterDetailView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 13.06.24.
//

import SwiftUI

struct CharacterDetailView: View {
    
    var character: Character
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            AsyncImage(url: URL(string: character.image)) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 300, height: 300)
            
            Text("Name: \(character.name)")
            Text("Status: \(character.status)")
            Text("Origin: \(character.origin["name"] ?? "Unknown")")
            Text("Location: \(character.location["name"] ?? "Unknown")")
        }
        .padding()
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
