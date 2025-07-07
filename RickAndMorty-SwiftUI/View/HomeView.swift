//
//  CharactersView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 13.06.24.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: CharacterModel
    @State private var heartStates = [Int: Bool]()
    @State private var showCommentScreen: Bool = false
    @State private var textFieldValue: String = ""
    @State private var comments: [String] = []
    
    //For AppStorage
    @AppStorage("userName") var userName: String = "Guest"
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                characterIcons
            }
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    characterList
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    menu
                }
                ToolbarItem(placement: .topBarTrailing) {
                    navigationLink
                }
            }
        }
        .onAppear {
            initializeHeartStates()
        }
    }
    
    //MARK: DropMenu items
    private var menu: some View {
        Menu {
            Button(action: {
                print("followers button selected")
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "person.2")
                    Text("Followers")
                }
            }
            Button(action: {
                print("favourites button selected")
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "star")
                    Text("Favourites")
                }
            }
        } label: {
            HStack {
                Text("For You")
                    .font(.title).bold()
                Image(systemName: "chevron.down")
                    .font(.callout)
            }
            .foregroundStyle(Color.accentColor)
        }
    }
    
    private var navigationLink: some View {
        NavigationLink(destination: Text("Favourites")) {
            Image(systemName: "heart")
                .foregroundStyle(Color.accentColor)
        }
    }
    
    //MARK: Stories
    private var characterIcons: some View {
        HStack {
            ForEach(viewModel.filteredCharacters) { character in
                NavigationLink(destination: CharacterDetailView(character: character)) {
                    AsyncImage(url: URL(string: character.image)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                }
            }
            .padding(.trailing)
        }
        .padding()
    }
    
    //MARK: Posts
    private var characterList: some View {
        ForEach(viewModel.filteredCharacters) { character in
            VStack(alignment: .leading) {
                userHeader
                characterImage(character)
                actionButtons(character)
            }
        }
    }
    
    //Post Items
    private var userHeader: some View {
        HStack {
            Circle()
                .fill(Color.gray)
                .scaledToFit()
                .frame(width: 40, height: 40)
            Text("@\(userName)") // Dynamically display the username
        }
        .padding(.leading)
    }
    
    private func characterImage(_ character: Character) -> some View {
        AsyncImage(url: URL(string: character.image)) { image in
            image.resizable()
        } placeholder: {
            Color.gray
        }
        .frame(width: .infinity, height: 300)
        .shadow(radius: 5)
    }
    
    //MARK: Functions
    private func actionButtons(_ character: Character) -> some View {
        HStack {
            Button {
                heartStates[character.id, default: false].toggle()
            } label: {
                Image(systemName: heartStates[character.id, default: false] ? "heart.fill" : "heart")
                    .foregroundStyle(heartStates[character.id, default: false] ? Color.red : Color.black)
                    .font(.title2)
            }
            Button {
                showCommentScreen.toggle()
            } label: {
                Image(systemName: "bubble.right")
            }
            .sheet(isPresented: $showCommentScreen) {
                commentScreen(textFieldValue: $textFieldValue, comments: $comments, userName: userName)
            }
        }
        .font(.title2)
        .padding()
    }
    
    private func initializeHeartStates() {
        for character in viewModel.filteredCharacters {
            heartStates[character.id] = false
        }
    }
}

//MARK: For Comments
struct commentScreen: View {
    @Binding var textFieldValue: String
    @Binding var comments: [String]
    let userName: String
    
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
            commentsSection
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
                        comments.append("\(userName): \(textFieldValue)") // Append with username
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
    
    private var commentsSection: some View {
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
}

#Preview {
    HomeView(viewModel: CharacterModel(networkManager: NetworkManager()))
}
