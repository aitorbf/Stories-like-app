//
//  UserMapper.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation

enum UserMapper {
    static func map(from entity: UserEntity) -> User {
        User(
            id: entity.id,
            name: entity.name,
            profilePictureURL: entity.profilePictureURL,
            stories: entity.stories
                .sorted { $0.timestamp < $1.timestamp }
                .map(StoryMapper.map)
        )
    }
}
