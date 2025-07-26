//
//  HeadlinesTests.swift
//  HeadlinesTests
//
//  Created by Spud on 7/26/25.
//

import SwiftUI
import Testing

@testable import Headlines

struct HeadlinesTests {

    @Test func fetchHeadlines() async throws {
        let viewModel = HeadlinesViewModel(api: MockAPI())

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            #expect(viewModel.headlines.count == 10)
        }
    }

}
