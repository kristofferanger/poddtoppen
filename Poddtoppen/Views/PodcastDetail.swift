//
//  PodcastDetail.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-05.
//

import SwiftUI

struct PodcastDetail: View {
    
    @ObservedObject var viewModel: PodDetailsViewModel
    
    init(podcast: Podcast) {
        self.viewModel = PodDetailsViewModel(podcast: podcast)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PosterImage(url: viewModel.podcast.image)
                    .frame(width: 200, height: 200)
                infoSection()
                    .multilineTextAlignment(.center)
                if let episodes = viewModel.podcast.episodes {
                    episodeSection(episodes: episodes)
                }
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1), radius: 8)
            .padding(.horizontal, 16)
        }
        .background(Color.background())
        .onAppear {
            self.viewModel.updatePodcast()
        }
    }
}

// MARK: - views
extension PodcastDetail {
    
    func infoSection() -> some View {
        VStack(spacing: 10) {
            Text(viewModel.podcast.title)
                .font(.title)
            Text(viewModel.podcast.publisher)
                .font(.body)
            Text(viewModel.podcast.description.htmlStripped())
        }
    }
    
    func episodeSection(episodes: [Episode]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(episodes) { episode in
                EpisodeCell(episode: episode, viewModel: viewModel)
            }
        }
        .padding()
    }
}

struct PodcastDetail_Previews: PreviewProvider {
    
    static let podcast = MockDataService.podcastWithEpisodes()
    static var previews: some View {
        PodcastDetail(podcast: podcast)
    }
}
