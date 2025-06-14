//
//  StoryEntity.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation
import SwiftData

@Model
final class StoryEntity {
    @Attribute(.unique) var id: String
    var imageURL: URL
    var timestamp: Date
    var isSeen: Bool
    var isLiked: Bool

    init(
        id: String,
        imageURL: URL,
        timestamp: Date,
        isSeen: Bool = false,
        isLiked: Bool = false
    ) {
        self.id = id
        self.imageURL = imageURL
        self.timestamp = timestamp
        self.isSeen = isSeen
        self.isLiked = isLiked
    }
}
