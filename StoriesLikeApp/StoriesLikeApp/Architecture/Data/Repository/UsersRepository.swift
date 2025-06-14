//
//  UserRepository.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation
import SwiftData

protocol UsersRepository {
    func fetchUsersPage(
        _ index: Int,
        context: ModelContext
    ) throws -> (users: [UserEntity], currentPage: Int, totalPages: Int)
}

final class UserRepositoryImpl: UsersRepository {
    
    private let dataSource: UsersDataSource
    
    init(dataSource: UsersDataSource = UsersDataSourceImpl()) {
        self.dataSource = dataSource
    }

    func fetchUsersPage(
        _ index: Int,
        context: ModelContext
    ) throws -> (users: [UserEntity], currentPage: Int, totalPages: Int) {
        
        guard let result = dataSource.fetchPage(index) else {
            throw NSError(domain: "UserRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Page not found"])
        }

        for user in result.users {
            for story in user.stories {
                let storyId = story.id
                let descriptor = FetchDescriptor<StoryEntity>(
                    predicate: #Predicate { $0.id == storyId }
                )
                
                if let cachedStory = try? context.fetch(descriptor).first {
                    story.isSeen = cachedStory.isSeen
                    story.isLiked = cachedStory.isLiked
                } else {
                    context.insert(story)
                }
            }
        }

        try context.save()

        return (
            users: result.users,
            currentPage: result.currentPage,
            totalPages: result.totalPages
        )
    }
}
