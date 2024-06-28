//
//  FlickrModel.swift
//  FlickrSearch
//
//  Created by Tauseef Riasat on 6/27/24.
//

import Foundation

struct FlickrResponse: Codable {
    let items: [FlickrItem]
}

struct FlickrItem: Codable, Identifiable, Hashable {
    static func == (lhs: FlickrItem, rhs: FlickrItem) -> Bool {
        return lhs.title == rhs.title
    }
    
    var id: UUID {
        return UUID()
    }
    let title: String
    let link: String
    let media: Media
    let date_taken: String
    let description: String
    let published: String
    let author: String
    let author_id: String
    let tags: String
}

struct Media: Codable, Hashable {
    let m: String
}
