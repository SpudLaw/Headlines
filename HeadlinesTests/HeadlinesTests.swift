//
//  HeadlinesTests.swift
//  HeadlinesTests
//
//  Created by Spud on 7/26/25.
//

import SwiftUI
import Testing
import WebKit

@testable import Headlines

struct HeadlinesTests {

    @Test func fetchHeadlines() async throws {
        let viewModel = HeadlinesViewModel(api: MockAPI())

        let headlines = try await viewModel.fetchHeadlines()
        #expect(headlines.count == 10)
    }
    
    @MainActor @Test func testLoadURL() {
        let url = "https://npr.com"
        let coordinator = WebView.Coordinator(WebView(url: URL(string: url)!, loading: .constant(false)))
        
        #expect(coordinator.parent.url.absoluteString == url)
    }
}
