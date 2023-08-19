//
//  EpisodeCell.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-06.
//

import SwiftUI
import AVKit

// handling audio
enum AudioState {
    case stopped
    case loading
    case ready
    case playing
    case paused
    
    func iconName() -> String {
        switch self {
        case .stopped:
            return "play.fill"
        case .playing:
            return "pause.fill"
        default:
            return "questionmark.diamond.fill"
        }
    }
}

struct EpisodeCell: View {
    
    var episode: Episode
    var viewModel: PodDetailsViewModel
    
    @State private var player: AVPlayer?
    @State private var audioState: AudioState = .stopped

    var body: some View {
        Button {
            viewModel.playingEpisode = episode
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(episode.pubDateMs.dateSting)
                        .font(.caption)
                    Text(episode.title)
                        .font(.headline)
                        .lineLimit(2)
                }
                HStack(alignment: .top) {
                    PosterImage(url: episode.thumbnail, placeholder: false)
                        .frame(width: 50, height: 50)
                        .padding(2)
                        .overlay(
                            playButtonOverlay()
                        )
                    Text(episode.description.htmlStripped())
                        .font(.caption)
                        .lineLimit(4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
        .onReceive(viewModel.$playingEpisode, perform: { playingEpisode in
            guard let playingEpisode else { return }
            // stop playing if other episodes play, otherwise play if not playing already
            if playingEpisode.id == episode.id, audioState != .playing {
                player?.play()
                audioState = .playing
            }
            else {
                player?.pause()
                audioState = .stopped
            }
        })
        .onAppear {
            guard let audioUrl = URL(string: episode.audio) else { return }
            player = AVPlayer(url: audioUrl)
        }
    }
    
    
}

// MARK: - views
extension EpisodeCell {
    
    private func playButtonOverlay() -> some View {
        ZStack {
            switch audioState {
            case .loading:
                ProgressView()
            default:
                Image(systemName: audioState.iconName())
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
        .foregroundColor(.white)
        .opacity(0.9)
    }
}

struct EpisodeCell_Previews: PreviewProvider {
    
    static let podcast = MockDataService.podcastWithEpisodes()
    static let episode = podcast.episodes!.first!
    
    static var previews: some View {
        Group {
            EpisodeCell(episode: episode, viewModel: PodDetailsViewModel(podcast: podcast))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            EpisodeCell(episode: episode, viewModel: PodDetailsViewModel(podcast: podcast))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
