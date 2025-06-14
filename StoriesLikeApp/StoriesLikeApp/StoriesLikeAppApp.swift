//
//  StoriesLikeAppApp.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import SwiftUI

@main
struct StoriesLikeAppApp: App {

    var body: some Scene {
        WindowGroup {
            StoryListView(viewModel: StoryListViewModelImpl())
        }
    }
}
