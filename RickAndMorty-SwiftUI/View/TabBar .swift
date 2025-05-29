//
//  TabBar .swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 06.04.25.
//

import SwiftUI

struct TabBar_: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            SearchPageView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            Text("Add photos")
                .tabItem {
                    Image(systemName: "plus.square")
                }
            Text("Reels")
                .tabItem {
                    Image(systemName: "film")
                }
            Text("Profile")
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    TabBar_()
}
