//
//  Photo.swift
//  Rightloom
//

import Foundation

struct Photo: Codable, Identifiable {
    let path: String
    let id: Int64
    let tags: String
    let updated_at: String
    let created_at: String
    
    init() {
        path = ""
        id = 0
        tags = ""
        updated_at = ""
        created_at = ""
    }
}
