//
//  PodDetailsViewModel.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-05.
//

import Foundation
import Combine
import AVKit

class PodDetailsViewModel: ObservableObject {
    
    @Published var podcast: Podcast
    @Published var playingEpisode: Episode?
    
    init(podcast: Podcast) {
        self.podcast = podcast
        self.dataService = Constants.api == .mock ?  MockDataService() : PodDetailsDataService()
        addSubscribers()
    }
    
    // load data
    func updatePodcast() {
        dataService.loadPodcast(id: podcast.id)
    }
    
    //MARK: - Private stuff
    private let dataService: PodDetailsDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // receive data
    private func addSubscribers() {
        dataService.podcastPublisher
            .sink { [weak self] podcast in
                guard let pod = podcast else { return }
                self?.podcast = pod
            }
            .store(in: &cancellables)
    }
}
