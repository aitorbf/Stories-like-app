//
//  StoryRepository.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation
import SwiftData

protocol StoryRepository {
    func markStoryAsSeen(id: String) async throws
    func toggleLike(for id: String) async throws
}

final class StoryPersistenceRepositoryImpl: StoryRepository {

    @MainActor
    func markStoryAsSeen(id: String) async throws {
        let context: ModelContext = SwiftDataManager.shared.modelContext
        let descriptor = FetchDescriptor<StoryEntity>(
            predicate: #Predicate { $0.id == id }
        )

        if let story = try context.fetch(descriptor).first {
            story.isSeen = true
            try context.save()
        }
    }

    @MainActor
    func toggleLike(for id: String) async throws {
        let context: ModelContext = SwiftDataManager.shared.modelContext
        let descriptor = FetchDescriptor<StoryEntity>(
            predicate: #Predicate { $0.id == id }
        )

        if let story = try context.fetch(descriptor).first {
            story.isLiked.toggle()
            try context.save()
        }
    }
}
