////
////  SearchResultListView.swift
////  RickAndMorty-SwiftUI
////
////  Created by Ana Ptskialadze on 13.06.24.
////
//
//import SwiftUI
//
//struct SearchResultListView<Presenter, Content: View>: View {
//  @ObservedObject var datasource: SearchResultListDatasource<Presenter>
//  var itemsView: () -> Content
//
//  var body: some View {
//    switch viewModel.state {
//    case .loading:
//      loadingView
//    case let .empty(message):
//      makeMessageView(message)
//    default:
//      contentView
//    }
//  }
//
//  private var loadingView: some View {
//    MediumProgressView()
//  }
//
//  private func makeMessageView(_ message: String) -> some View {
//    Text(message)
//  }
//
//  private var contentView: some View {
//    List {
//      itemsView()
//      switch viewModel.state {
//      case .loadingNextPage:
//        MediumProgressView()
//      case .data, .nextPageData:
//        MediumProgressView()
//          .onAppear {
//            Task { await datasource.fetchNextPage() }
//          }
//      default:
//        EmptyView()
//      }
//    }
//    .scrollDismissesKeyboard(.immediately)
//    .scrollContentBackground(.hidden)
//    .listStyle(.plain)
//  }
//}
