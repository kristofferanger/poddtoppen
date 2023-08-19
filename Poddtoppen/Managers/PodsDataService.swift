//
//  PodsDataService.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-03.
//

import Foundation
import Combine

protocol PodsDataServiceProtocol {
    // subscribe vars
    var podsPublisher: Published<[Podcast]>.Publisher { get }
    var genresPublisher: Published<[Genre]>.Publisher { get }
    // method to ask for updates
    func loadPods()
}

class PodsDataService: PodsDataServiceProtocol {
    
    @Published var allPodcasts: [Podcast] = []
    @Published var allGenres: [Genre] = []

    var podsPublisher: Published<[Podcast]>.Publisher { $allPodcasts }
    var genresPublisher: Published<[Genre]>.Publisher { $allGenres }
    
    private var podsSubscription: AnyCancellable?
    private var genresSubscription: AnyCancellable?
    private var nextPage: Int?
    
    init() {
        // load genres
        loadGenres()
        // set the page number and load first patch
        self.nextPage = 1
        loadPods()
    }
    
    func loadGenres() {
        guard let url = NetworkingManager.url(endpoint: "/genres?top_level_only=1") else { return }
        genresSubscription = NetworkingManager.download(url: url)
            .decode(type: GenreResult.self, decoder: NetworkingManager.defaultDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedData in
                self?.allGenres = receivedData.genres
                self?.genresSubscription?.cancel()
            })
    }
    
    func loadPods() {
        guard let nextPage, let url = NetworkingManager.url(endpoint: String(format: "/best_podcasts?page=%d&region=se&publisher_region=se&sort=recent_added_first&safe_mode=0", nextPage)) else { return }
        podsSubscription = NetworkingManager.download(url: url)
            .decode(type: PodcastResult.self, decoder: NetworkingManager.defaultDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedData in
                // set next patch number and append data
                self?.nextPage = receivedData.hasNext ? receivedData.nextPageNumber : nil
                self?.allPodcasts.append(contentsOf: receivedData.podcasts)
                self?.podsSubscription?.cancel()
            })
    }
}
