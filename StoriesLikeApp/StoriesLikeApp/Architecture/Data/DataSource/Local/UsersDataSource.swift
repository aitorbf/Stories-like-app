//
//  UsersDataSource.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation

struct RootDTO: Decodable {
    let pages: [PageDTO]
}

struct PageDTO: Decodable {
    let users: [UserDTO]
}

struct UserDTO: Decodable {
    let id: Int
    let name: String
    let profile_picture_url: String
}

protocol UsersDataSource {
    func fetchPage(_ pageIndex: Int) -> UsersPageEntity?
}

final class UsersDataSourceImpl: UsersDataSource {
    
    private let filePath = "users"
    private let fileExtension = "json"

    func fetchPage(_ pageIndex: Int) -> UsersPageEntity? {
        guard let url = Bundle.main.url(forResource: filePath, withExtension: fileExtension),
              let data = try? Data(contentsOf: url),
              let root = try? JSONDecoder().decode(RootDTO.self, from: data),
              root.pages.indices.contains(pageIndex)
        else {
            return nil
        }

        let page = root.pages[pageIndex]
        let userEntities: [UserEntity] = page.users.map { dto in
            let user = UserEntity(
                id: dto.id,
                name: dto.name,
                profilePictureURL: URL(string: dto.profile_picture_url)!
            )
            user.stories = (1...3).map { i in
                let storyId = "\(user.id)\(i)"
                return StoryEntity(
                    id: storyId,
                    imageURL: URL(string: "https://picsum.photos/id/\(storyId)/600/1000")!,
                    timestamp: Date().addingTimeInterval(-Double(i * 3600))
                )
            }
            return user
        }

        return UsersPageEntity(
            users: userEntities,
            currentPage: pageIndex,
            totalPages: root.pages.count
        )
    }
}
