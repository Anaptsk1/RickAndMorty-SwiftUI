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
            .onAppear {
                viewmodel.loadMoreContentIfNeeded(currentItem: location)
            }
        }
        .navigationTitle("Locations")
    }
}

class LocationsViewModel: ObservableObject {
    
    @Published var locations: [Location] = []
    @Published var isLoading = false
    private var nextPageURL: URL? = URL(string: "https://rickandmortyapi.com/api/location")
    
    init() {
        loadMoreContent()
    }
    
    func loadMoreContent() {
        guard !isLoading, let nextPageURL = nextPageURL else {
            return
        }
        
        isLoading = true
        
        NetworkManager.shared.fetchData(from: .custom(url: nextPageURL)) { [weak self] (result: Result<LocationResults, Error>) in
            switch result {
            case .success(let locationResults):
                DispatchQueue.main.async {
                    self?.locations.append(contentsOf: locationResults.results)
                    self?.nextPageURL = URL(string: locationResults.info.next ?? "")
                    self?.isLoading = false
                }
            case .failure(let error):
                print("Failed to fetch locations: \(error)")
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }
    }
    
    func loadMoreContentIfNeeded(currentItem location: Location?) {
        guard let location = location else {
            loadMoreContent()
            return
        }
        
        let thresholdIndex = locations.index(locations.endIndex, offsetBy: -5)
        if locations.firstIndex(where: { $0.id == location.id }) == thresholdIndex {
            loadMoreContent()
        }
    }
}




