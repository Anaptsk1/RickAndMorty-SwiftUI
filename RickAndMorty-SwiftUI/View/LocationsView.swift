//
//  LocationsView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 13.06.24.
//

import SwiftUI

struct LocationsView: View {
    
    @ObservedObject var viewmodel = LocationsViewModel()
    
    var body: some View {
        List(viewmodel.locations) { location in
            NavigationLink(destination: LocationDetailView(location: location)) {
                Text(location.name)
            }
        }
        .onAppear {
            viewmodel.fetchLocations()
        }
        .navigationTitle("Locations")
    }
}

class LocationsViewModel: ObservableObject {
    
    @Published var locations: [Location] = []
    
    func fetchLocations () {
        NetworkManager.shared.fetchData(from: .locations) {(result: Result<LocationResults, any Error>) in
            switch result {
            case .success(let locationResults):
                self.locations = locationResults.results
            case .failure(let error):
                print(error)
            }
        }
    }
}



