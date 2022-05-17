//
//  newsResponse.swift
//  newsApp
//
//  Created by Ram Kumar on 18/03/22.
//

import Foundation


// MARK: - News
struct News: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    var source: Source
    var author: String?
    var title: String
    var articleDescription: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    var id: String?
    var name: String
}



