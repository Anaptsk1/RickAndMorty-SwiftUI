//
//  ProfileView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 30.06.25.
//

import SwiftUI

import SwiftUI

struct ProfileView: View {
    let username: String = "User Name"
    let bio: String = "Photographer | Traveler | Dreamer"
    let posts: Int = 120
    let followers: Int = 340
    let following: Int = 180

    var body: some View {
        VStack(spacing: 20) {
            // Profile Picture and Stats
            HStack(spacing: 20) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 10) {
                    Text(username)
                        .font(.title2)
                        .bold()
                    HStack(spacing: 30) {
                        VStack {
                            Text("\(posts)")
                                .font(.headline)
                            Text("Posts")
                                .font(.subheadline)
                        }

                        VStack {
                            Text("\(followers)")
                                .font(.headline)
                            Text("Followers")
                                .font(.subheadline)
                        }

                        VStack {
                            Text("\(following)")
                                .font(.headline)
                            Text("Following")
                                .font(.subheadline)
                        }
                    }
                }
            }

            //Bio
            VStack(alignment: .leading, spacing: 5) {
                Text(bio)
                    .font(.body)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            // Buttons
            HStack {
                Button(action: {
                    // Action for editing profile
                }) {
                    Text("Edit Profile")
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.leading)
                
                Button(action: {
                    // Action for editing profile
                }) {
                    Text("Share Profile")
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.trailing)
                
            }
            // Grid of Posts
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                    ForEach(0..<10, id: \.self) { index in
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 300)
                            .overlay(
                                Text("Post \(index + 1)")
                                    .foregroundColor(.black)
                                    .font(.caption)
                            )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }
}

#Preview {
    ProfileView()
}
