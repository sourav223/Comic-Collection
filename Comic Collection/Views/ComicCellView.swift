//
//  ComicCellView.swift
//  Comic Collection
//
//  Created by Sourav on 21/10/25.
//

import SwiftUI

struct ComicCellView: View {
    let comic: Comic
    @ObservedObject var viewModel: ComicViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                AsyncImage(url: URL(string: comic.img)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
                
                Divider()
                
                // Change to a saperate view (TODO)
                VStack(alignment: .leading, spacing: 10) {
                    Text(comic.safeTitle)
                        .font(.headline)
                    
                    Text(comic.alt)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .italic()
                    
                    Text(comic.date?.formatted(date: .abbreviated, time: .omitted) ?? "")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.yellow.opacity(0.8))
        .cornerRadius(20)
        .shadow(color: Color(#colorLiteral(red: 0.5755557418, green: 0.7498796582, blue: 1, alpha: 0.5568087748)), radius: 5, x: 5, y: 5)
    }
}
