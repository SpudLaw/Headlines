//
//  ContentView.swift
//  Headlines
//
//  Created by Spud on 7/26/25.
//

import SwiftUI

struct HeadlinesView: View {
    @State var viewModel = HeadlinesViewModel(api: HeadlinesAPI())
    @State var finishedLoading: Bool = false
    var body: some View {
        if viewModel.headlines.isEmpty {
            ProgressView()
        } else {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.headlines, id: \.uid) { headline in
                            NavigationLink {
                                BrowserView(url: headline.webLink)
                            } label: {
                                HeadlineItemView(
                                    title: headline.title,
                                    imageURL: headline.imageURL)
                            }
                            .accentColor(.primary)
                            .navigationTitle("Top NPR Headlines")
                        }
                    }
                }.padding()
            }
        }
    }
}

struct HeadlineItemView: View {
    let title: String
    let imageURL: URL?

    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .multilineTextAlignment(.leading)
            
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .padding()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            Divider()
        }
    }
}

#Preview {
    HeadlinesView()
}
