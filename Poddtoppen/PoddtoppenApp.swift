//
//  PoddtoppenApp.swift
//  Poddtoppen
//
//  Created by Kristoffer Anger on 2023-08-19.
//

import SwiftUI

@main
struct PoddtoppenApp: App {
    let dataService: PodsDataServiceProtocol = Constants.api == .mock ? MockDataService() : PodsDataService()
    
    var body: some Scene {
        WindowGroup {
            PodListView(viewModel: PodsViewModel(dataService: dataService))
        }
    }
}
