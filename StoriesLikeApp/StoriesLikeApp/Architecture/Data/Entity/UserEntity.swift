//
//  UserEntity.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation
import SwiftData


final class UserEntity {
    let id: Int
    let name: String
    let profilePictureURL: URL
    var stories: [StoryEntity] = []

    init(id: Int, name: String, profilePictureURL: URL) {
        self.id = id
        self.name = name
        self.profilePictureURL = profilePictureURL
    }
}
