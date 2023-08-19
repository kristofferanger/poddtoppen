//
//  Podcast.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-03.
//

import Foundation
/*
 {
       "id": "28ba59be5b8346589e910e24d4b3eed7",
       "rss": "https://pultepodcast.libsyn.com/rss",
       "type": "episodic",
       "email": "Bill@pulte.org",
       "extra": {
         "url1": "",
         "url2": "",
         "url3": "",
         "google_url": "https://podcasts.google.com/feed/aHR0cHM6Ly9wdWx0ZXBvZGNhc3QubGlic3luLmNvbS9yc3M=",
         "spotify_url": "https://open.spotify.com/show/31g21O5kSlCstxSswwtPzh",
         "youtube_url": "",
         "linkedin_url": "",
         "wechat_handle": "",
         "patreon_handle": "",
         "twitter_handle": "",
         "facebook_handle": "",
         "amazon_music_url": "",
         "instagram_handle": ""
       },
       "image": "https://production.listennotes.com/podcasts/the-pulte-podcast-8PvlfCgcR_X-xBWa8_-4MTR.1400x1400.jpg",
       "title": "The Pulte Podcast",
       "country": "United States",
       "website": "http://www.pulte.org?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
       "language": "English",
       "genre_ids": [
         171,
         93,
         94,
         67
       ],
       "itunes_id": 1525585134,
       "publisher": "Bill Pulte | Giving Money and Knowledge",
       "thumbnail": "https://production.listennotes.com/podcasts/the-pulte-podcast-gqCft_ZYOIz-xBWa8_-4MTR.300x300.jpg",
       "is_claimed": false,
       "description": "I'm giving away money, rent, food, and knowledge to people in need. I've built and sold 8 figure companies and now I want to help people.",
       "looking_for": {
         "guests": false,
         "cohosts": false,
         "sponsors": false,
         "cross_promotion": false
       },
       "listen_score": 73,
       "total_episodes": 12,
       "listennotes_url": "https://www.listennotes.com/c/28ba59be5b8346589e910e24d4b3eed7/",
       "audio_length_sec": 446,
       "explicit_content": false,
       "latest_episode_id": "e26262d976694428bc1cc8c7af791d1b",
       "latest_pub_date_ms": 1621426832000,
       "earliest_pub_date_ms": 1596040778010,
       "update_frequency_hours": 202,
       "listen_score_global_rank": "0.01%"
     },
 */

// podcast
struct Podcast: Codable, Identifiable {
    let id: String
    let image: String
    let title: String
    let country: String
    let description: String
    let language: String
    let genreIds: [Int]
    let publisher: String
    let thumbnail: String
    // optionals
    var episodes: [Episode]?
}

// additional vars
extension Podcast {
    // listenScore is a premium feature - so give a random number for now
    var scoreNumber: Double {
        Double.random(in: 5.0..<10.0)
    }
}

// holding the podcasts
struct PodcastResult: Codable, Identifiable {
    let id: Int
    let podcasts: [Podcast]
    let total: Int
    let hasNext: Bool
    let hasPrevious: Bool
    let pageNumber: Int
    let previousPageNumber: Int
    let nextPageNumber: Int
}

// episode - loads on detail view
struct Episode: Codable, Identifiable, Equatable {
    let id: String
    let audio: String
    let image: String
    let title: String
    let thumbnail: String
    let description: String
    let pubDateMs: Double
    let listennotesUrl: String
    let audioLengthSec: Int
    
    
}
