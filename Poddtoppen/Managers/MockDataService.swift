//
//  MockDataService.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-04.
//

import Foundation
import Combine

class MockDataService: PodsDataServiceProtocol, PodDetailsDataServiceProtocol {
    
    @Published var allPodcasts = [Podcast]()
    @Published var allGenres = [Genre]()
    @Published var podcast: Podcast!
    
    var podsPublisher: Published<[Podcast]>.Publisher { $allPodcasts }
    var genresPublisher: Published<[Genre]>.Publisher { $allGenres }
    var podcastPublisher: Published<Podcast?>.Publisher { $podcast }
    
    private var podsSubscription: AnyCancellable?
    private var genresSubscription: AnyCancellable?
    private var podcastSubscription: AnyCancellable?
    
    init() {
        loadGenres()
        loadPods()
    }
    
    func loadPods() {
        let data = MockDataService.podsJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        podsSubscription = Just(data)
            .decode(type: PodcastResult.self, decoder: NetworkingManager.defaultDecoder())
            .delay(for: 1.5, scheduler: RunLoop.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedData in
                self?.allPodcasts = receivedData.podcasts
                self?.podsSubscription?.cancel()
            })
    }
    
    func loadGenres() {
        let data = MockDataService.genreJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        genresSubscription = Just(data)
            .decode(type: GenreResult.self, decoder: NetworkingManager.defaultDecoder())
            .delay(for: 1, scheduler: RunLoop.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedData in
                self?.allGenres = receivedData.genres
                self?.genresSubscription?.cancel()
            })
    }
    
    func loadPodcast(id: String) {
        let data = MockDataService.podcastDetailJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        podcastSubscription = Just(data)
            .decode(type: Podcast.self, decoder: NetworkingManager.defaultDecoder())
            .delay(for: 1, scheduler: RunLoop.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedData in
                self?.podcast = receivedData
                self?.podcastSubscription?.cancel()
            })
    }
}

// MARK: - data for testing
extension MockDataService {
    static func genre(random: Bool = false) -> Genre {
        let data = genreJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let genreResult = try! NetworkingManager.defaultDecoder().decode(GenreResult.self, from: data)
        return random ? genreResult.genres.randomElement()! : genreResult.genres.first!
    }
    
    static func podcast(random: Bool = false) -> Podcast {
        let data = podsJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let podcastResult = try! NetworkingManager.defaultDecoder().decode(PodcastResult.self, from: data)
        return random ? podcastResult.podcasts.randomElement()! : podcastResult.podcasts.first!
    }
    
    static func podcastWithEpisodes() -> Podcast {
        let data = podcastDetailJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        return try! NetworkingManager.defaultDecoder().decode(Podcast.self, from: data)
    }
}

// MARK: - JSON data
extension MockDataService {
    
    private static var genreJSON: String {
        return """
    {"genres": [{"id": 144, "name": "Personal Finance", "parent_id": 67}, {"id": 151, "name": "Locally Focused", "parent_id": 67}, {"id": 77, "name": "Sports", "parent_id": 67}, {"id": 125, "name": "History", "parent_id": 67}, {"id": 93, "name": "Business", "parent_id": 67}, {"id": 122, "name": "Society & Culture", "parent_id": 67}, {"id": 127, "name": "Technology", "parent_id": 67}, {"id": 132, "name": "Kids & Family", "parent_id": 67}, {"id": 168, "name": "Fiction", "parent_id": 67}, {"id": 88, "name": "Health & Fitness", "parent_id": 67}, {"id": 134, "name": "Music", "parent_id": 67}, {"id": 99, "name": "News", "parent_id": 67}, {"id": 133, "name": "Comedy", "parent_id": 67}, {"id": 100, "name": "Arts", "parent_id": 67}, {"id": 69, "name": "Religion & Spirituality", "parent_id": 67}, {"id": 117, "name": "Government", "parent_id": 67}, {"id": 68, "name": "TV & Film", "parent_id": 67}, {"id": 82, "name": "Leisure", "parent_id": 67}, {"id": 111, "name": "Education", "parent_id": 67}, {"id": 107, "name": "Science", "parent_id": 67}, {"id": 135, "name": "True Crime", "parent_id": 67}]}
    """
    }
    
    private static var podsJSON: String {
        return """
    {
        "id": 67,
        "name": "Podcasts",
        "parent_id": null,
        "podcasts": [{
            "id": "f2eb196b20884b0490cc60a58b05bbb6",
            "title": "The Daily",
            "publisher": "The New York Times",
            "image": "https://production.listennotes.com/podcasts/the-daily-the-new-york-times-lDnVGaIf7Ks-xp7nhsmSkX2.300x300.jpg",
            "thumbnail": "https://production.listennotes.com/podcasts/the-daily-the-new-york-times-lDnVGaIf7Ks-xp7nhsmSkX2.300x300.jpg",
            "listennotes_url": "https://www.listennotes.com/c/f2eb196b20884b0490cc60a58b05bbb6/",
            "listen_score": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "listen_score_global_rank": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "total_episodes": 1879,
            "audio_length_sec": 1705,
            "update_frequency_hours": 31,
            "explicit_content": false,
            "description": "This is what the news should sound like. The biggest stories of our time, told by the best journalists in the world. Hosted by Michael Barbaro and Sabrina Tavernise.",
            "itunes_id": 1200361736,
            "rss": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "latest_pub_date_ms": 1688377500000,
            "latest_episode_id": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "earliest_pub_date_ms": 1484687988860,
            "language": "English",
            "country": "United States",
            "website": "https://www.nytimes.com/the-daily?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "extra": {
                "twitter_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "facebook_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "instagram_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "wechat_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "patreon_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "youtube_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "linkedin_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "spotify_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "google_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "amazon_music_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "url1": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "url2": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "url3": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing"
            },
            "is_claimed": true,
            "email": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "type": "episodic",
            "looking_for": {
                "sponsors": false,
                "guests": false,
                "cohosts": false,
                "cross_promotion": false
            },
            "genre_ids": [93, 216, 213, 99, 67]
        }, {
            "id": "6d2ab9d90973430dbec3c5c24e689f00",
            "title": "Serial",
            "publisher": "Serial Productions & The New York Times",
            "image": "https://production.listennotes.com/podcasts/serial-serial-productions-the-new-york-times-RgmG8YyL-nk-V1NRH-2wzoB.300x300.jpg",
            "thumbnail": "https://production.listennotes.com/podcasts/serial-serial-productions-the-new-york-times-RgmG8YyL-nk-V1NRH-2wzoB.300x300.jpg",
            "listennotes_url": "https://www.listennotes.com/c/6d2ab9d90973430dbec3c5c24e689f00/",
            "listen_score": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "listen_score_global_rank": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "total_episodes": 83,
            "audio_length_sec": 2564,
            "update_frequency_hours": 302,
            "explicit_content": false,
            "description": "Serial Productions makes narrative podcasts whose quality and innovation transformed the medium. Serial began in 2014 as a spinoff of the public radio show. This American Life. In 2020, we joined the New York Times Company. Our shows have reached many millions of listeners and have won nearly every major journalism award for audio, including the first-ever Peabody Award given to a podcast. Subscribe to our newsletter for the latest Serial Productions news: https://bit.ly/3FIOJj9 Have thoughts or feedback on our shows? Email us at serialshows@nytimes.com",
            "itunes_id": 917918570,
            "rss": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "latest_pub_date_ms": 1687428000000,
            "latest_episode_id": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "earliest_pub_date_ms": 1412343900075,
            "language": "English",
            "country": "United States",
            "website": "https://serialpodcast.org?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "extra": {
                "twitter_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "facebook_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "instagram_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "wechat_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "patreon_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "youtube_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "linkedin_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "spotify_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "google_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "amazon_music_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "url1": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "url2": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "url3": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing"
            },
            "is_claimed": false,
            "email": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "type": "episodic",
            "looking_for": {
                "sponsors": false,
                "guests": false,
                "cohosts": false,
                "cross_promotion": false
            },
            "genre_ids": [165, 99, 68, 104, 135]
        }, {
            "id": "581fc67e281047d09fa90f7782c51feb",
            "title": "Dirty John",
            "publisher": "Los Angeles Times | Wondery",
            "image": "https://production.listennotes.com/podcasts/dirty-john-los-angeles-times-wondery-qZAerlh56VY-1rJzL4wEyuY.300x300.jpg",
            "thumbnail": "https://production.listennotes.com/podcasts/dirty-john-los-angeles-times-wondery-qZAerlh56VY-1rJzL4wEyuY.300x300.jpg",
            "listennotes_url": "https://www.listennotes.com/c/581fc67e281047d09fa90f7782c51feb/",
            "listen_score": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "listen_score_global_rank": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "total_episodes": 12,
            "audio_length_sec": 1913,
            "update_frequency_hours": 1162,
            "explicit_content": false,
            "description": "All episodes are available for free, with remastered ad-free episodes available for Wondery+ subscribers.Debra Newell is a successful interior designer. She meets John Meehan, a handsome man who seems to check all the boxes: attentive, available, just back from a year in Iraq with Doctors Without Borders. But her family doesnt like John, and they get entangled in an increasingly complex web of love, deception, forgiveness, denial, and ultimately, survival. Reported and hosted by Christopher Goffard from the L.A. Times.",
            "itunes_id": 1272970334,
            "rss": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "latest_pub_date_ms": 1684411200000,
            "latest_episode_id": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "earliest_pub_date_ms": 1505113500011,
            "language": "English",
            "country": "United States",
            "website": "https://wondery.com/shows/dirty-john-remastered/?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "extra": {
                "twitter_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "facebook_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "instagram_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "wechat_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "patreon_handle": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "youtube_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "linkedin_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "spotify_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "google_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "amazon_music_url": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "url1": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "url2": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
                "url3": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing"
            },
            "is_claimed": false,
            "email": "Please upgrade to PRO or ENTERPRISE plan to see this field. Learn more: listennotes.com/api/pricing",
            "type": "serial",
            "looking_for": {
                "sponsors": false,
                "guests": false,
                "cohosts": false,
                "cross_promotion": false
            },
            "genre_ids": [122, 124, 165, 68, 67, 135]
        }],
        "total": 765,
        "has_next": true,
        "has_previous": false,
        "page_number": 1,
        "previous_page_number": 0,
        "next_page_number": 2,
        "listennotes_url": "https://www.listennotes.com/best-podcasts/"
    }
    """
    }
    
    private static var podcastDetailJSON: String {
        return """
{
    "id": "4d3fe717742d4963a85562e9f84d8c79",
    "rss": "http://sw7x7.libsyn.com/rss",
    "type": "episodic",
    "email": "allen@sw7x7.com",
    "extra": {
        "url1": "",
        "url2": "",
        "url3": "",
        "google_url": "https://play.google.com/music/listen?u=0#/ps/I7gdcrqcmvhfnhh2cyqkcg32tkq",
        "spotify_url": "https://open.spotify.com/show/2rQJUP9Y3HxemiW3JHt9WV",
        "youtube_url": "https://www.youtube.com/sw7x7",
        "linkedin_url": "",
        "wechat_handle": "",
        "patreon_handle": "sw7x7",
        "twitter_handle": "",
        "facebook_handle": "sw7x7",
        "amazon_music_url": "",
        "instagram_handle": ""
    },
    "image": "https://production.listennotes.com/podcasts/star-wars-7x7-the-daily-star-wars-podcast-HN08OoDE7pc-AIg3cZVKCsL.1400x1400.jpg",
    "title": "Star Wars 7x7: The Daily Star Wars Podcast",
    "country": "United States",
    "website": "https://sw7x7.com?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
    "episodes": [{
            "id": "4e7c59e10e4640b98f2f3cb1777dbb43",
            "link": "https://sites.libsyn.com/55931/864-part-2-of-my-new-conversation-with-bobby-roberts?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "audio": "https://www.listennotes.com/e/p/4e7c59e10e4640b98f2f3cb1777dbb43/",
            "image": "https://production.listennotes.com/podcasts/star-wars-7x7-the/864-part-2-of-my-new--vDBMTjY_mK-2WVsxtU0f3m.600x315.jpg",
            "title": "864: Part 2 of My (New) Conversation With Bobby Roberts",
            "thumbnail": "https://production.listennotes.com/podcasts/star-wars-7x7-the/864-part-2-of-my-new-yqjrzNDEXaS-2WVsxtU0f3m.300x157.jpg",
            "description": "<p>The second half of my latest conversation with Bobby Roberts, Podcast Emeritus from Full of Sith and now Star Wars 'Podcast Force Ghost at Large.' Punch it!</p> <p>***We’re listener supported! Go to http://Patreon.com/sw7x7 to donate to the Star Wars 7x7 podcast, and you’ll get some fabulous rewards for your pledge.*** </p> <p>Check out SW7x7.com for full Star Wars 7x7 show notes and links, and to comment on any of the content of this episode! If you like what you've heard, please leave us a rating or review on iTunes or Stitcher, which will also help more people discover this Star Wars podcast.</p> <p>Don't forget to join the Star Wars 7x7 fun on Facebook at Facebook.com/SW7x7, and follow the breaking news Twitter feed at Twitter.com/SW7x7Podcast. We're also on Pinterest and Instagram too, and we'd love to connect with you there!</p>",
            "pub_date_ms": 1479110402174,
            "guid_from_rss": "bbada2b3a99054ce93b0eb95dd762b4d",
            "listennotes_url": "https://www.listennotes.com/e/4e7c59e10e4640b98f2f3cb1777dbb43/",
            "audio_length_sec": 2447,
            "explicit_content": false,
            "maybe_audio_invalid": false,
            "listennotes_edit_url": "https://www.listennotes.com/e/4e7c59e10e4640b98f2f3cb1777dbb43/#edit"
        },
        {
            "id": "9ae0e2e49a9c477191263df90adf7f3e",
            "link": "https://sites.libsyn.com/55931/863-a-new-conversation-with-bobby-roberts-part-1?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "audio": "https://www.listennotes.com/e/p/9ae0e2e49a9c477191263df90adf7f3e/",
            "image": "https://production.listennotes.com/podcasts/star-wars-7x7-the/863-a-new-conversation-with-e_vHo9SM7ft-0YRBTlgiVeU.600x315.jpg",
            "title": "863: A (New) Conversation With Bobby Roberts, Part 1",
            "thumbnail": "https://production.listennotes.com/podcasts/star-wars-7x7-the/863-a-new-conversation-with-lcQsDS5uvYb-0YRBTlgiVeU.300x157.jpg",
            "description": "<p>An in-depth conversation about the Star Wars 'Story' movies and so much more, featuring Bobby Roberts, Star Wars 'Podcast Force Ghost at Large.' Punch it!</p> <p>***We’re listener supported! Go to http://Patreon.com/sw7x7 to donate to the Star Wars 7x7 podcast, and you’ll get some fabulous rewards for your pledge.*** </p> <p>Check out SW7x7.com for full Star Wars 7x7 show notes and links, and to comment on any of the content of this episode! If you like what you've heard, please leave us a rating or review on iTunes or Stitcher, which will also help more people discover this Star Wars podcast.</p> <p>Don't forget to join the Star Wars 7x7 fun on Facebook at Facebook.com/SW7x7, and follow the breaking news Twitter feed at Twitter.com/SW7x7Podcast. We're also on Pinterest and Instagram as 'SW7x7' too, and we'd love to connect with you there!</p>",
            "pub_date_ms": 1479024002175,
            "guid_from_rss": "2c298fe68246aad30bd5afe0b79fdd76",
            "listennotes_url": "https://www.listennotes.com/e/9ae0e2e49a9c477191263df90adf7f3e/",
            "audio_length_sec": 2916,
            "explicit_content": false,
            "maybe_audio_invalid": false,
            "listennotes_edit_url": "https://www.listennotes.com/e/9ae0e2e49a9c477191263df90adf7f3e/#edit"
        },
        {
            "id": "98bcfa3fd1b44727913385938788bcc5",
            "link": "https://sites.libsyn.com/55931/862-assassin-clone-wars-briefing-season-3-episode-7?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "audio": "https://www.listennotes.com/e/p/98bcfa3fd1b44727913385938788bcc5/",
            "image": "https://production.listennotes.com/podcasts/star-wars-7x7-the/862-assassin-clone-wars-lP94b2q5iOz-jEcMAdTntzs.600x315.jpg",
            "title": "862: 'Assassin' - Clone Wars Briefing, Season 3, Episode 7",
            "thumbnail": "https://production.listennotes.com/podcasts/star-wars-7x7-the/862-assassin-clone-wars-Uh3E0GwOQRX-jEcMAdTntzs.300x157.jpg",
            "description": "<p>The beginnings of the true power of the Force, revealed in 'Assassin,' season 3, episode 7 of the Star Wars: The Clone Wars cartoon series. Punch it!</p> <p>***We’re listener supported! Go to http://Patreon.com/sw7x7 to donate to the Star Wars 7x7 podcast, and you’ll get some fabulous rewards for your pledge.*** </p> <p>Check out SW7x7.com for full Star Wars 7x7 show notes and links, and to comment on any of the content of this episode! If you like what you've heard, please leave us a rating or review on iTunes or Stitcher, which will also help more people discover this Star Wars podcast.</p> <p>Don't forget to join the Star Wars 7x7 fun on Facebook at Facebook.com/SW7x7, and follow the breaking news Twitter feed at Twitter.com/SW7x7Podcast. We're also on Pinterest and Instagram as 'SW7x7' too, and we'd love to connect with you there!</p>",
            "pub_date_ms": 1478937602176,
            "guid_from_rss": "6f64d1b37c661bbd066e773ae3b72d5e",
            "listennotes_url": "https://www.listennotes.com/e/98bcfa3fd1b44727913385938788bcc5/",
            "audio_length_sec": 636,
            "explicit_content": false,
            "maybe_audio_invalid": false,
            "listennotes_edit_url": "https://www.listennotes.com/e/98bcfa3fd1b44727913385938788bcc5/#edit"
        },
        {
            "id": "61d1de72f97e48e887c5d6280d3de384",
            "link": "https://sites.libsyn.com/55931/861-rogue-one-international-trailer-breakdown?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "audio": "https://www.listennotes.com/e/p/61d1de72f97e48e887c5d6280d3de384/",
            "image": "https://production.listennotes.com/podcasts/star-wars-7x7-the/861-rogue-one-international-6rZOEiJHPpx-nGxaRC95V6o.600x315.jpg",
            "title": "861: Rogue One International Trailer Breakdown",
            "thumbnail": "https://production.listennotes.com/podcasts/star-wars-7x7-the/861-rogue-one-international-AFlEBXPHG6d-nGxaRC95V6o.300x157.jpg",
            "description": "<p>Surprise! An international trailer for Rogue One has dropped, and it includes new scenes, new dialogue, and some heavy foreshadowing about Jyn Erso's fate. Punch it!</p> <p>***We’re listener supported! Go to http://Patreon.com/sw7x7 to donate to the Star Wars 7x7 podcast, and you’ll get some fabulous rewards for your pledge.*** </p> <p>Check out SW7x7.com for full Star Wars 7x7 show notes and links, and to comment on any of the content of this episode! If you like what you've heard, please leave us a rating or review on iTunes or Stitcher, which will also help more people discover this Star Wars podcast.</p> <p>Don't forget to join the Star Wars 7x7 fun on Facebook at Facebook.com/SW7x7, and follow the breaking news Twitter feed at Twitter.com/SW7x7Podcast. We're also on Pinterest and Instagram as 'SW7x7' too, and we'd love to connect with you there!</p>",
            "pub_date_ms": 1478851458177,
            "guid_from_rss": "10f042cf7346e078e201769b1097d651",
            "listennotes_url": "https://www.listennotes.com/e/61d1de72f97e48e887c5d6280d3de384/",
            "audio_length_sec": 1082,
            "explicit_content": false,
            "maybe_audio_invalid": false,
            "listennotes_edit_url": "https://www.listennotes.com/e/61d1de72f97e48e887c5d6280d3de384/#edit"
        },
        {
            "id": "53f5d00491134367ac3baf8c75b9a46b",
            "link": "https://sites.libsyn.com/55931/860-will-jyn-and-cassian-survive-rogue-one?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "audio": "https://www.listennotes.com/e/p/53f5d00491134367ac3baf8c75b9a46b/",
            "image": "https://production.listennotes.com/podcasts/star-wars-7x7-the/860-will-jyn-and-cassian-VHAJQ1N57hE-l_3qXNfHAU0.600x315.jpg",
            "title": "860: Will Jyn and Cassian Survive Rogue One?",
            "thumbnail": "https://production.listennotes.com/podcasts/star-wars-7x7-the/860-will-jyn-and-cassian-k-2Si6HYjTP-l_3qXNfHAU0.300x157.jpg",
            "description": "<p>Today I conclude a two-episode set looking at the odds of survival for major Rogue One characters. Today: Jyn Erso, Cassian Andor, Bodhi Rook, and K-2SO. Punch it!</p> <p>***We’re listener supported! Go to http://Patreon.com/sw7x7 to donate to the Star Wars 7x7 podcast, and you’ll get some fabulous rewards for your pledge.*** </p> <p>Check out SW7x7.com for full Star Wars 7x7 show notes and links, and to comment on any of the content of this episode! If you like what you've heard, please leave us a rating or review on iTunes or Stitcher, which will also help more people discover this Star Wars podcast.</p> <p>Don't forget to join the Star Wars 7x7 fun on Facebook at Facebook.com/SW7x7, and follow the breaking news Twitter feed at Twitter.com/SW7x7Podcast. We're also on Pinterest and Instagram as 'SW7x7' too, and we'd love to connect with you there!</p>",
            "pub_date_ms": 1478764802178,
            "guid_from_rss": "18062743dbffa4ce293686607ce30af4",
            "listennotes_url": "https://www.listennotes.com/e/53f5d00491134367ac3baf8c75b9a46b/",
            "audio_length_sec": 651,
            "explicit_content": false,
            "maybe_audio_invalid": false,
            "listennotes_edit_url": "https://www.listennotes.com/e/53f5d00491134367ac3baf8c75b9a46b/#edit"
        },
        {
            "id": "76c00b559f7d4f1c8be3ff1e2d808af9",
            "link": "https://sites.libsyn.com/55931/859-the-odds-who-will-survive-rogue-one?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "audio": "https://www.listennotes.com/e/p/76c00b559f7d4f1c8be3ff1e2d808af9/",
            "image": "https://production.listennotes.com/podcasts/star-wars-7x7-the/859-the-odds-who-will-nM7l1BNPbIa-kprAXUCS8uQ.600x315.jpg",
            "title": "859: The Odds: Who Will Survive Rogue One?",
            "thumbnail": "https://production.listennotes.com/podcasts/star-wars-7x7-the/859-the-odds-who-will-RlXojiI5Wm6-kprAXUCS8uQ.300x157.jpg",
            "description": "<p>Will Galen Erso, Lyra Erso, Saw Gerrera, and Orson Krennic survive the events of Rogue One: A Star Wars Story? Starting a mini-series to look at the odds... Punch it!</p> <p>***We’re listener supported! Go to http://Patreon.com/sw7x7 to donate to the Star Wars 7x7 podcast, and you’ll get some fabulous rewards for your pledge.*** </p> <p>Check out SW7x7.com for full Star Wars 7x7 show notes and links, and to comment on any of the content of this episode! If you like what you've heard, please leave us a rating or review on iTunes or Stitcher, which will also help more people discover this Star Wars podcast.</p> <p>Don't forget to join the Star Wars 7x7 fun on Facebook at Facebook.com/SW7x7, and follow the breaking news Twitter feed at Twitter.com/SW7x7Podcast. We're also on Pinterest and Instagram as 'SW7x7' too, and we'd love to connect with you there!</p>",
            "pub_date_ms": 1478678402179,
            "guid_from_rss": "98e4d31b23bc7f48db490effe4d77e73",
            "listennotes_url": "https://www.listennotes.com/e/76c00b559f7d4f1c8be3ff1e2d808af9/",
            "audio_length_sec": 483,
            "explicit_content": false,
            "maybe_audio_invalid": false,
            "listennotes_edit_url": "https://www.listennotes.com/e/76c00b559f7d4f1c8be3ff1e2d808af9/#edit"
        },
        {
            "id": "62cdfe0b9ef64d1288a975a659dcf442",
            "link": "https://sites.libsyn.com/55931/858-together-new-rogue-one-commercial-dialogue?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "audio": "https://www.listennotes.com/e/p/62cdfe0b9ef64d1288a975a659dcf442/",
            "image": "https://production.listennotes.com/podcasts/star-wars-7x7-the/858-together-new-rogue-one-TsLghBq5enX-WpFSsNUOzcL.600x315.jpg",
            "title": "858: 'Together' - New Rogue One Commercial Dialogue",
            "thumbnail": "https://production.listennotes.com/podcasts/star-wars-7x7-the/858-together-new-rogue-one-dJF6XLmfYl4-WpFSsNUOzcL.300x157.jpg",
            "description": "<p>A new Rogue One commercial dropped Sunday, with some new dialogue that hints at the relationship between Jyn Erso, Saw Gerrera, the Rebellion, and the Partisans. Punch it!</p> <p>***We’re listener supported! Go to http://Patreon.com/sw7x7 to donate to the Star Wars 7x7 podcast, and you’ll get some fabulous rewards for your pledge.*** </p> <p>Check out SW7x7.com for full Star Wars 7x7 show notes and links, and to comment on any of the content of this episode! If you like what you've heard, please leave us a rating or review on iTunes or Stitcher, which will also help more people discover this Star Wars podcast.</p> <p>Don't forget to join the Star Wars 7x7 fun on Facebook at Facebook.com/SW7x7, and follow the breaking news Twitter feed at Twitter.com/SW7x7Podcast. We're also on Pinterest and Instagram as 'SW7x7' too, and we'd love to connect with you there!</p>",
            "pub_date_ms": 1478592002180,
            "guid_from_rss": "c6dd42254e561130bf891f92e944041b",
            "listennotes_url": "https://www.listennotes.com/e/62cdfe0b9ef64d1288a975a659dcf442/",
            "audio_length_sec": 448,
            "explicit_content": false,
            "maybe_audio_invalid": false,
            "listennotes_edit_url": "https://www.listennotes.com/e/62cdfe0b9ef64d1288a975a659dcf442/#edit"
        },
        {
            "id": "a98c9cb497f04aec9e09cc50ce25ea59",
            "link": "https://sites.libsyn.com/55931/857-imperial-supercommandos-star-wars-rebels-season-3-episode-7?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "audio": "https://www.listennotes.com/e/p/a98c9cb497f04aec9e09cc50ce25ea59/",
            "image": "https://production.listennotes.com/podcasts/star-wars-7x7-the/857-imperial-supercommandos-d0c7L1grbaI-L6bAOKCmyqt.600x315.jpg",
            "title": "857: 'Imperial Supercommandos' - Star Wars Rebels Season 3, Episode 7",
            "thumbnail": "https://production.listennotes.com/podcasts/star-wars-7x7-the/857-imperial-supercommandos-OFpdNki02M_-L6bAOKCmyqt.300x157.jpg",
            "description": "<p>'Imperial Supercommandos' is Season 3, episode 7 of Star Wars Rebels, referring to Mandalorians serving the Empire. But can Fenn Rau be trusted, either? Punch it!</p> <p>***We’re listener supported! Go to http://Patreon.com/sw7x7 to donate to the Star Wars 7x7 podcast, and you’ll get some fabulous rewards for your pledge.*** </p> <p>Check out SW7x7.com for full Star Wars 7x7 show notes and links, and to comment on any of the content of this episode! If you like what you've heard, please leave us a rating or review on iTunes or Stitcher, which will also help more people discover this Star Wars podcast.</p> <p>Don't forget to join the Star Wars 7x7 fun on Facebook at Facebook.com/SW7x7, and follow the breaking news Twitter feed at Twitter.com/SW7x7Podcast. We're also on Pinterest and Instagram as 'SW7x7' too, and we'd love to connect with you there!</p>",
            "pub_date_ms": 1478505602181,
            "guid_from_rss": "007883a51d5ddc49b8b8d7fee80cb1ba",
            "listennotes_url": "https://www.listennotes.com/e/a98c9cb497f04aec9e09cc50ce25ea59/",
            "audio_length_sec": 494,
            "explicit_content": false,
            "maybe_audio_invalid": false,
            "listennotes_edit_url": "https://www.listennotes.com/e/a98c9cb497f04aec9e09cc50ce25ea59/#edit"
        },
        {
            "id": "e055bd1750a745a6adfcb70b935c03b7",
            "link": "https://sites.libsyn.com/55931/856-the-academy-clone-wars-briefing-season-3-episode-6?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "audio": "https://www.listennotes.com/e/p/e055bd1750a745a6adfcb70b935c03b7/",
            "image": "https://production.listennotes.com/podcasts/star-wars-7x7-the/856-the-academy-clone-wars-6-EXfkbp4Sz-l6QpC-2RDTH.600x315.jpg",
            "title": "856: 'The Academy' - Clone Wars Briefing, Season 3, Episode 6",
            "thumbnail": "https://production.listennotes.com/podcasts/star-wars-7x7-the/856-the-academy-clone-wars-x6_sqVGe-KS-l6QpC-2RDTH.300x157.jpg",
            "description": "<p>'The Academy,' Season 3 Episode 6 of the Clone Wars cartoon series, is a quieter episode that highlights the importance of Mandalore to the Star Wars franchise. Punch it!</p> <p>***We’re listener supported! Go to http://Patreon.com/sw7x7 to donate to the Star Wars 7x7 podcast, and you’ll get some fabulous rewards for your pledge.*** </p> <p>Check out SW7x7.com for full Star Wars 7x7 show notes and links, and to comment on any of the content of this episode! If you like what you've heard, please leave us a rating or review on iTunes or Stitcher, which will also help more people discover this Star Wars podcast.</p> <p>Don't forget to join the Star Wars 7x7 fun on Facebook at Facebook.com/SW7x7, and follow the breaking news Twitter feed at Twitter.com/SW7x7Podcast. We're also on Pinterest and Instagram as 'SW7x7' too, and we'd love to connect with you there!</p>",
            "pub_date_ms": 1478415602182,
            "guid_from_rss": "f346a6e7575ab41197cacc6648070da2",
            "listennotes_url": "https://www.listennotes.com/e/e055bd1750a745a6adfcb70b935c03b7/",
            "audio_length_sec": 561,
            "explicit_content": false,
            "maybe_audio_invalid": false,
            "listennotes_edit_url": "https://www.listennotes.com/e/e055bd1750a745a6adfcb70b935c03b7/#edit"
        },
        {
            "id": "d602a45cdb524f3fac1effd79a61f828",
            "link": "https://sites.libsyn.com/55931/855-episode-viii-and-han-solo-movie-updates?utm_source=listennotes.com&utm_campaign=Listen+Notes&utm_medium=website",
            "audio": "https://www.listennotes.com/e/p/d602a45cdb524f3fac1effd79a61f828/",
            "image": "https://production.listennotes.com/podcasts/star-wars-7x7-the/855-episode-viii-and-han-3Wkgr82DBxf-9vz38ko_X2s.600x315.jpg",
            "title": "855: Episode VIII and Han Solo Movie Updates",
            "thumbnail": "https://production.listennotes.com/podcasts/star-wars-7x7-the/855-episode-viii-and-han-naM8NWQxR19-9vz38ko_X2s.300x157.jpg",
            "description": "<p>Daisy Ridley says wait for Episode VIII for answers about Rey's parents. Bradford Young says the Han Solo movie won't be what you expect. Updates here... Punch it!</p> <p>***We’re listener supported! Go to http://Patreon.com/sw7x7 to donate to the Star Wars 7x7 podcast, and you’ll get some fabulous rewards for your pledge.*** </p> <p>Check out SW7x7.com for full Star Wars 7x7 show notes and links, and to comment on any of the content of this episode! If you like what you've heard, please leave us a rating or review on iTunes or Stitcher, which will also help more people discover this Star Wars podcast.</p> <p>Don't forget to join the Star Wars 7x7 fun on Facebook at Facebook.com/SW7x7, and follow the breaking news Twitter feed at Twitter.com/SW7x7Podcast. We're also on Pinterest and Instagram as 'SW7x7' too, and we'd love to connect with you there!</p>",
            "pub_date_ms": 1478329202183,
            "guid_from_rss": "89ac7c92db19f7d06f523eb2c093bde6",
            "listennotes_url": "https://www.listennotes.com/e/d602a45cdb524f3fac1effd79a61f828/",
            "audio_length_sec": 1103,
            "explicit_content": false,
            "maybe_audio_invalid": false,
            "listennotes_edit_url": "https://www.listennotes.com/e/d602a45cdb524f3fac1effd79a61f828/#edit"
        }
    ],
    "language": "English",
    "genre_ids": [
        86,
        67,
        68,
        82,
        100,
        101,
        160,
        138
    ],
    "itunes_id": 896354638,
    "publisher": "Star Wars 7x7",
    "thumbnail": "https://production.listennotes.com/podcasts/star-wars-7x7-the-daily-star-wars-podcast-2LryqMj-sGP-AIg3cZVKCsL.300x300.jpg",
    "is_claimed": false,
    "description": "The Star Wars 7x7 Podcast is Rebel-rousing fun for everyday Jedi, generally between 7 and 14 minutes a day, always 7 days a week. Join host Allen Voivod for Star Wars news, history, interviews, trivia, and deep dives into the Star Wars story as told in movies, books, comics, games, cartoons, and more. Follow now for your daily dose of Star Wars joy. It's destiny unleashed! #SW7x7",
    "looking_for": {
        "guests": false,
        "cohosts": false,
        "sponsors": false,
        "cross_promotion": false
    },
    "listen_score": 49,
    "total_episodes": 3273,
    "listennotes_url": "https://www.listennotes.com/c/4d3fe717742d4963a85562e9f84d8c79/",
    "audio_length_sec": 595,
    "explicit_content": false,
    "latest_episode_id": "59d005135885495eb4258356ee7aaf97",
    "latest_pub_date_ms": 1681803000000,
    "earliest_pub_date_ms": 1404637200000,
    "next_episode_pub_date": 1478329202183,
    "update_frequency_hours": 21,
    "listen_score_global_rank": "0.5%"
}
"""
    }
    
}
