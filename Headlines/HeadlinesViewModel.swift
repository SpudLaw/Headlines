//
//  HeadlinesViewModel.swift
//  Headlines
//
//  Created by Spud on 7/26/25.
//

import SwiftUI

@Observable
class HeadlinesViewModel {
    private let api: API
    var headlines: [Headline] = []

    init(api: API) {
        self.api = api

        Task {
            do {
                try await fetchHeadlines()
            } catch {
                print("Couldn't fetch headlines: \(error)")
            }
        }
    }

    internal func fetchHeadlines() async throws {
        let topHeadlines = try await api.fetchTopHeadlines()
        let items = topHeadlines?.items ?? []

        for item in items {
            let images = item.links.image
            let squareImage = images.filter({ image in
                image.rel == "square"
            })

            self.headlines.append(
                Headline(
                    uid: item.attributes.uid,
                    title: item.attributes.title,
                    imageURL: URL(string: squareImage[0].href),
                    webLink: URL(string: item.links.web[0].href)!
                ))
        }
    }
}

struct Headline {
    let uid: String
    let title: String
    let imageURL: URL?
    let webLink: URL
}
