//
//  PodDetailsDataService.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-05.
//

import Foundation
import Combine

protocol PodDetailsDataServiceProtocol {
    // subscribe vars
    var podcastPublisher: Published<Podcast?>.Publisher { get }
    // method to ask for updates
    func loadPodcast(id: String)
}

class PodDetailsDataService: PodDetailsDataServiceProtocol {
    
    @Published var podcast: Podcast!
    var podcastPublisher: Published<Podcast?>.Publisher { $podcast }
    
    private var podcastSubscription: AnyCancellable?
  
    func loadPodcast(id: String) {
        let endpoint = String(format: "/podcasts/%@?sort=recent_first", id)
        guard let url = NetworkingManager.url(endpoint: endpoint) else { return }
        podcastSubscription = NetworkingManager.download(url: url)
            .decode(type: Podcast.self, decoder: NetworkingManager.defaultDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedData in
                self?.podcast = receivedData
                self?.podcastSubscription?.cancel()
            })
    }
}

