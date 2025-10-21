//
//  ComicListView.swift
//  Comic Collection
//
//  Created by Sourav on 21/10/25.
//

import SwiftUI

struct ComicListView: View {
    @StateObject private var viewModel = ComicViewModel()
    @State private var isFavorite = false
    @State private var showShare: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Comic...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let comic = viewModel.currentComic {
                    ComicCellView(comic: comic, viewModel: viewModel)
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("Tap to load the latest xkcd comic.")
                        .foregroundColor(.gray)
                }
                
                // MARK: - Navigation Controls & Favourites
                BottomControlView(viewModel: viewModel, isFavorite: $isFavorite)
            }
            .navigationTitle(viewModel.currentComic?.title ?? "No title")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchInitialComic()
            }
            .sheet(isPresented: $showShare) {
                if let comic = viewModel.currentComic {
                    ActivityViewController(activityItems: [comic.img, comic.title])
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showShare.toggle()
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .padding(20)
        }
    }
}

struct BottomControlView: View {
    @ObservedObject var viewModel : ComicViewModel
    @Binding var isFavorite: Bool
    
    var body: some View {
        HStack(spacing: 30) {
            Button {
                viewModel.goToPreviousComic()
            } label: {
                Image(systemName: "arrow.backward.circle.fill")
                    .font(.largeTitle)
            }
            .disabled(viewModel.currentComic?.num == 1 || viewModel.isLoading)
            
            Button{
                //Favorit Button Action (TODO)
                isFavorite.toggle()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.gray)
                    .clipShape(Circle())
            }
            .disabled(viewModel.isLoading)
            
            Button {
                viewModel.goToNextComic()
            } label: {
                Image(systemName: "arrow.forward.circle.fill")
                    .font(.largeTitle)
            }
            .disabled(viewModel.isLoading)
        }
        .padding(.vertical)
    }
}


#Preview {
    ComicListView()
}
