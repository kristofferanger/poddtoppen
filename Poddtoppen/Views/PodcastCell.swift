//
//  PodcastCell.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-05.
//

import SwiftUI

struct PodcastCell: View {
    
    var genres: [Genre]
    var podcast: Podcast
    var index: Int
    
    var body: some View {
        HStack(alignment: .top) {
            PosterImage(url: podcast.thumbnail)
                .frame(width: 80, height: 80)
                .padding(2)
            VStack(alignment: .leading, spacing: 4) {
                Text(podcast.publisher)
                    .font(.caption)
                    .lineLimit(1)
                Text([String(index + 1), podcast.title].joined(separator: ". "))
                    .font(.headline)
                    .lineLimit(2)
                scoreAndGenreSegment()
                Text(podcast.description.htmlStripped())
                    .font(.caption)
                    .lineLimit(3)
            }
            .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1), radius: 8)
    }
    
    private var genresString: String {
        let filtered = genres.filter { podcast.genreIds.contains($0.id) }
        return filtered.map{ $0.name }.joined(separator: ", ")
    }
}

// MARK: - views
extension PodcastCell {
    
    func scoreAndGenreSegment() -> some View {
        HStack(alignment: .top) {
            scorelabel(score: podcast.scoreNumber)
            Text(genresString)
                .italic()
        }
        .font(.caption)
    }
    
    func scorelabel(score: Double) -> some View {
        HStack(alignment: .lastTextBaseline, spacing: 2) {
            Text(String(format: "%.1f", score))
                .fontWeight(.bold)
            Image(systemName: "star.fill")
        }
        .foregroundColor(.accentColor)
    }
}

struct PodcastCell_Previews: PreviewProvider {
    static let genres = [MockDataService.genre(random: true), MockDataService.genre(random: true)]
    static let podcast = MockDataService.podcast()
    
    static var previews: some View {
        Group {
            PodcastCell(genres: genres, podcast: podcast, index: 2)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            PodcastCell(genres: genres, podcast: podcast, index: 2)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
