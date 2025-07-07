//
//  DataModel.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 13.06.24.
//

import UIKit

struct CharacterResults: Codable {
    let info: Info
    var results: [Character]
}

//struct LocationResults: Codable {
//    let info: Info
//    var results: [Location]
//}
//
//struct EpisodeResults: Codable {
//    let info: Info
//    var results: [Episode]
//}

struct Character: Codable, Identifiable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var origin: [String: String]
    var location: [String: String]
    var image: String
    let url: String
    let created: String
}

//struct Location: Codable, Identifiable {
//    var id: Int
//    var name: String
//    var type: String
//    var dimension: String
//}
//
//struct Episode: Codable, Identifiable {
//    var id: Int
//    var name: String
//    var air_date: String
//    var episode: String
//}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
}
