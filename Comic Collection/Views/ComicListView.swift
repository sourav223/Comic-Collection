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
                HStack(spacing: 30) {
                    Button {
                        viewModel.goToPreviousComic()
                    } label: {
                        Image(systemName: "arrow.backward.circle.fill")
                            .font(.largeTitle)
                    }
                    .disabled(viewModel.currentComic?.num == 1 || viewModel.isLoading)
                    
                    Button(action: {
                        //Favorit Button Action (TODO)
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.gray)
                            .clipShape(Circle())
                    }
                    .disabled(viewModel.isLoading || viewModel.currentComic == nil)
                    
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
            .navigationTitle(viewModel.currentComic?.title ?? "No title")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchInitialComic()
            }
            .padding(20)
        }
    }
}


#Preview {
    ComicListView()
}
