//
//  ComicListView.swift
//  Comic Collection
//
//  Created by Sourav on 21/10/25.
//

import SwiftUI

struct ComicListView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.red
                    .ignoresSafeArea(.all)
                List {
                    ForEach(0..<20, id: \.self) { _ in
                        ComicCellView()
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
            }
            
        }
    }
}


#Preview {
    ComicListView()
}
