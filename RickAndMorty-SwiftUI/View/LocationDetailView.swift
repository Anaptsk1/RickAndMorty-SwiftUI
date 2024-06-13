//
//  LocationDetailView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 13.06.24.
//

import SwiftUI

struct LocationDetailView: View {
    
    var location: Location
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name: \(location.name)")
            Text("Status: \(location.type)")
            Text("Origin: \(location.dimension)")
        }
        .padding()
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

