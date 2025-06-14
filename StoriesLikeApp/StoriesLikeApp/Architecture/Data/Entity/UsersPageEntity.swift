//
//  UsersPageEntity.swift
//  StoriesLikeApp
//
//  Created by Aitor Baragaño Fernández on 14/6/25.
//

import Foundation

struct UsersPageEntity {
    let users: [UserEntity]
    let currentPage: Int
    let totalPages: Int
}
