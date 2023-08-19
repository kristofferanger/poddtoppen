//
//  PodsViewModel.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-03.
//

import Foundation
import Combine

class PodsViewModel: ObservableObject {
    
    @Published var allPodcasts = [Podcast]()
    @Published var allGenres = [Genre]()
    
    let podsDataService: PodsDataServiceProtocol
    
    // get data
    func loadMorePodcasts() {
        podsDataService.loadPods()
    }
    
    init(dataService: PodsDataServiceProtocol) {
        self.podsDataService = dataService
        addSubscribers()
    }
        
    // MARK: - private stuff
    private var cancellables = Set<AnyCancellable>()
    private var activeFiltersIds = Set<Int>()

    // receive podpcasts and genres
    private func addSubscribers() {
        podsDataService.genresPublisher
            .sink{ [weak self] genres in
                self?.allGenres = genres
            }
            .store(in: &cancellables)
        
        podsDataService.podsPublisher
            .sink { [weak self] podcasts in
                self?.allPodcasts = podcasts
            }
            .store(in: &cancellables)
    }
}
