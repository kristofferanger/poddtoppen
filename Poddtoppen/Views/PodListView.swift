//
//  PodListView.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-04.
//

import SwiftUI

struct PodListView: View {
    
    @ObservedObject var viewModel: PodsViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack() {
                    LazyVGrid(columns: columns) {
                        ForEach(Array(viewModel.allPodcasts.enumerated()), id: \.element.id) { index, podcast in
                            NavigationLink(destination: PodcastDetail(podcast: podcast)) {
                                PodcastCell(genres: viewModel.allGenres, podcast: podcast, index: index)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .onAppear {
                                // load more when we are close to bottom
                                if viewModel.allPodcasts.count - 8 == index {
                                    viewModel.loadMorePodcasts()
                                }
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 16))
            }
            .background(Color.background())
            .navigationTitle(Text("Poddtoppen"))
        }
    }
    
    private var columns: [GridItem] {
        return [GridItem(.adaptive(minimum: 280), spacing: 10)]
    }
    
}

// MARK: - Preview
struct PodListView_Previews: PreviewProvider {
    
    static var previews: some View {
        PodListView(viewModel: PodsViewModel(dataService: Constants.api == .mock ? MockDataService() :  PodsDataService()))
    }
}
