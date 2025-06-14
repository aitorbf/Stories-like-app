//
//  ToggleStoryLikeUseCase.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation

protocol ToggleStoryLikeUseCase {
    func execute(_ storyId: String) async throws
}

final class ToggleStoryLikeUseCaseImpl: ToggleStoryLikeUseCase {
    
    private let repository: StoryRepository
    
    init(repository: StoryRepository) {
        self.repository = repository
    }

    func execute(_ storyId: String) async throws {
        try await repository.toggleLike(for: storyId)
    }
}
