//
//  StoryMapper.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation

enum StoryMapper {
    static func map(from entity: StoryEntity) -> Story {
        Story(
            id: entity.id,
            imageURL: entity.imageURL,
            timestamp: entity.timestamp,
            isSeen: entity.isSeen,
            isLiked: entity.isLiked
        )
    }
}
