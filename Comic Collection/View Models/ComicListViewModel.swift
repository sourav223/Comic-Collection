//
//  ComicListViewModel.swift
//  Comic Collection
//
//  Created by Sourav on 21/10/25.
//

import Foundation
import Combine

// MARK: - ViewModel (Presentation Logic)

@MainActor
final class ComicViewModel: ObservableObject {
    @Published var currentComic: Comic?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Comic Fetching
    func fetchInitialComic() {
        loadComic(number: 1)
    }
    
    func goToPreviousComic() {
        guard let currentNum = currentComic?.num, currentNum > 1 else { return }
        loadComic(number: currentNum - 1)
    }
    func goToNextComic() {
        guard let currentNum = currentComic?.num, currentNum < 3156 else { return }
        loadComic(number: currentNum + 1)
    }
    
    private func loadComic(number: Int?) {
        isLoading = true
        errorMessage = nil
        
        ComicAPIService().fetchComic(number: number)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to load comic: \(error.localizedDescription)"
                    self?.currentComic = nil
                }
            } receiveValue: { [weak self] comic in
                self?.currentComic = comic
            }
            .store(in: &cancellables)
    }
}
