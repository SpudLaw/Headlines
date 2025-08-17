//
//  ContentView.swift
//  Headlines
//
//  Created by Spud on 7/26/25.
//

import SwiftUI

struct HeadlinesView: View {
    @State var viewModel = HeadlinesViewModel(api: HeadlinesAPI())
    @State var loading: Bool = false

    var body: some View {
        if viewModel.headlines.isEmpty {
            ProgressView()
        } else {
            NavigationStack {
                List {
                    ForEach(viewModel.headlines, id: \.uid) { headline in
                        HeadlineItemView(
                            title: headline.title,
                            imageURL: headline.imageURL
                        )
                        .overlay {
                            NavigationLink(
                                "",
                                destination: WebView(
                                    url: headline.webLink,
                                    loading: $loading
                                )
                                .onAppear {
                                    loading = true
                                }
                                .toolbar {
                                    ToolbarItem(placement: .topBarLeading) {
                                        if loading {
                                            ProgressView()
                                        }
                                    }
                                })
                        }
                    }
                }
                .navigationTitle("Top NPR Headlines")
                .listStyle(.plain)
            }
        }
    }
}

struct HeadlineItemView: View {
    let title: String
    let imageURL: URL?

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)

            AsyncImage(url: imageURL) { result in
                result.image?.resizable().aspectRatio(contentMode: .fit)
            }
        }
    }
}

#Preview {
    HeadlinesView()
}
