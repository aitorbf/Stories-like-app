//
//  StoryListViewModel.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation
import Combine

protocol StoryListViewModel: ObservableObject {
    var users: [User] { get }
    
    func loadStories() async
    func loadMoreStories(currentIndex: Int) async
    func updateSeenStatus(for updatedStories: [[Story]]) async
}
    
final class StoryListViewModelImpl: StoryListViewModel {
    
    @Published var users: [User] = []
    
    private let useCase: GetUsersStoriesUseCase
    
    private var currentPage = 0
    private var isFetching = false
    private var canLoadMore = true
    
    init(useCase: GetUsersStoriesUseCase) {
        self.useCase = useCase
    }
    
    @MainActor
    func loadStories() async {
        guard !isFetching && canLoadMore else {
            return
        }
        
        isFetching = true
        
        do {
            let usersPage = try await useCase.execute(page: currentPage)
            users.append(contentsOf: usersPage.users)
            canLoadMore = currentPage < usersPage.totalPages
            currentPage += 1
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        isFetching = false
    }
    
    func loadMoreStories(currentIndex: Int) async {
        guard !isFetching, canLoadMore else {
            return
        }
        
        if currentIndex >= users.count - 5 {
            await loadStories()
        }
    }
    
    @MainActor
    func updateSeenStatus(for updatedStories: [[Story]]) async {
        for (userIndex, updatedGroup) in updatedStories.enumerated() {
            guard users.indices.contains(userIndex) else { continue }
            users[userIndex].stories = updatedGroup
        }
    }
}
