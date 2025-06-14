//
//  GetUsersStoriesUseCase.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation

protocol GetUsersStoriesUseCase {
    func execute(page: Int) async throws -> UsersPage
}

final class GetUsersStoriesUseCaseImpl: GetUsersStoriesUseCase {
    
    private let repository: UsersRepository

    init(repository: UsersRepository = UsersRepositoryImpl()) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> UsersPage {
            let result = try await repository.fetchUsersPage(page)

            let users = result.users.map(UserMapper.map)

            return UsersPage(
                users: users,
                currentPage: result.currentPage,
                totalPages: result.totalPages
            )
        }
}
