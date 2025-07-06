//
//  ReelsView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 01.07.25.
//
import SwiftUI
import AVKit

struct ReelsView: View {
    @State private var currentIndex: Int = 0
    @State private var favoritedIndices: Set<Int> = []
    @State private var showCommentScreen: Bool = false
    @State private var textFieldValue: String = ""
    @State private var comments: [String] = []

    let reels: [Reel] = [
        Reel(videoURL: "https://www.example.com/video1.mp4", caption: "Amazing view!", username: "@user1"),
        Reel(videoURL: "https://www.example.com/video2.mp4", caption: "Check this out!", username: "@user2"),
        Reel(videoURL: "https://www.example.com/video3.mp4", caption: "Incredible moment!", username: "@user3")
    ]

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(reels.indices, id: \ .self) { index in
                ReelPlayer(reel: reels[index], isFavorited: favoritedIndices.contains(index), onFavoriteToggle: {
                    if favoritedIndices.contains(index) {
                        favoritedIndices.remove(index)
                    } else {
                        favoritedIndices.insert(index)
                    }
                }, onCommentPressed: {
                    showCommentScreen.toggle()
                })
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showCommentScreen) {
            CommentScreen(textFieldValue: $textFieldValue, comments: $comments)
        }
    }
}

struct ReelPlayer: View {
    let reel: Reel
    let isFavorited: Bool
    let onFavoriteToggle: () -> Void
    let onCommentPressed: () -> Void

    var body: some View {
        ZStack {
            VideoPlayer(player: AVPlayer(url: URL(string: reel.videoURL)!))

            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text(reel.username)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(reel.caption)
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    VStack(spacing: 20) {
                        Button(action: onFavoriteToggle) {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                                .font(.title)
                                .foregroundColor(isFavorited ? .red : .white)
                        }
                        Button(action: onCommentPressed) {
                            Image(systemName: "bubble.right")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        Button(action: {
                            print("Share")
                        }) {
                            Image(systemName: "paperplane")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct CommentScreen: View {
    @Binding var textFieldValue: String
    @Binding var comments: [String]

    var body: some View {
        VStack {
            RoundedRectangle(cornerSize: .init(width: 20, height: 20))
                .frame(width: 50, height: 3)
                .foregroundColor(.gray)
                .padding(.top, 10)
            Text("Comments")
                .bold()
                .padding(.all, 5)
            RoundedRectangle(cornerSize: .init(width: 20, height: 20))
                .frame(width: .infinity, height: 0.3)
                .foregroundColor(.gray)
                .padding(.top, 5)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(comments, id: \ .self) { comment in
                        Text(comment)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
            HStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.gray)
                    .padding(.leading)
                TextField("Add a comment", text: $textFieldValue)
                    .frame(width: .infinity, height: 30)
                    .padding(.all, 15)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(radius: 5)
                    .padding(.all, 10)
                Button(action: {
                    if !textFieldValue.isEmpty {
                        comments.append(textFieldValue)
                        textFieldValue = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(Color.blue)
                        .font(.title2)
                }
                .padding(.trailing)
            }
        }
    }
}

struct Reel: Identifiable {
    let id = UUID()
    let videoURL: String
    let caption: String
    let username: String
}

#Preview {
    ReelsView()
}
