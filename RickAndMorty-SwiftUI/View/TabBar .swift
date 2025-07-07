//
//  TabBar .swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 06.04.25.
//

import SwiftUI

struct TabBar: View {
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
            AddPhotosView()
                .tabItem {
                    Image(systemName: "plus.square")
                }
            ReelsView()
                .tabItem {
                    Image(systemName: "film")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    TabBar()
}
