//
//  HeadlinesAPI.swift
//  Headlines
//
//  Created by Spud on 7/26/25.
//

import Foundation

protocol API {
    func fetchTopHeadlines() async throws -> TopHeadlines?
}

class HeadlinesAPI: API {
    
    private let baseURL = "https://legacy.npr.org/assets/api/listening-api-response.json"
    
    func fetchTopHeadlines() async throws -> TopHeadlines? {
        guard let url = URL(string: baseURL) else {
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        return try JSONDecoder().decode(TopHeadlines.self, from: data)
    }
}

class MockAPI: API {
    func fetchTopHeadlines() async throws -> TopHeadlines? {
        guard let url = Bundle.main.url(forResource: "listening-api-response", withExtension: "json") else {
                print("JSON file not found in bundle.")
                return nil
            }
        
        let topheadlines = try JSONDecoder().decode(TopHeadlines.self, from: try Data(contentsOf: url))
        
        return topheadlines
    }
}

struct Item: Codable {
    var version: String
    var href: String
    let attributes: HeadlineAttributes
    let links: Link
    let errors: [String]
}

struct Link: Codable {
    var image: [HeadlineImage]
    var web: [WebContent]
}

struct WebContent: Codable {
    var contentType: String
    var href: String
    
    enum CodingKeys: String, CodingKey {
        case contentType = "content-type"
        case href
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.contentType = try container.decode(String.self, forKey: .contentType)
        self.href = try container.decode(String.self, forKey: .href)
    }
}

struct HeadlineImage: Codable {
    let contentType: String
    let href: String
    let rel: String?
    let producer: String?
    let provider: String
    let caption: String
    
    enum CodingKeys: String, CodingKey {
        case contentType = "content-type"
        case href
        case rel
        case producer
        case provider
        case caption
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.contentType = try container.decode(String.self, forKey: .contentType)
        self.href = try container.decode(String.self, forKey: .href)
        self.rel = try container.decodeIfPresent(String.self, forKey: .rel)
        self.producer = try container.decodeIfPresent(String.self, forKey: .producer)
        self.provider = try container.decode(String.self, forKey: .provider)
        self.caption = try container.decode(String.self, forKey: .caption)
    }
}

struct TopHeadlines: Codable {
    let version: String
    let href: String
    let attributes: Attributes
    let items: [Item]?
    let errors: [String]
}

struct Attributes: Codable {
    let id: String
    let type: String
    let title: String
    let deepLinkId: String
    let itemType: String
    let renderType: String
}

struct HeadlineAttributes: Codable {
    let title: String
    let uid: String
    let label: String?
    let storyId: String
    let type: String
    let renderType: String
    let slug: Slug
    let provider: String
    let date: String // Format: 2024-08-16T11:00:00+00:00
    let description: String
}

struct Slug: Codable {
    let href: String
    let title: String
    let externalId: String
    let badge: String?
}
