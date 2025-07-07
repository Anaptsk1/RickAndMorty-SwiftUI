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

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
}
