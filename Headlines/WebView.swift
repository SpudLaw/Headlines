//
//  WebView.swift
//  Headlines
//
//  Created by Spud on 7/26/25.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    var finishedLoading: Binding<Bool>

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // no updates needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.finishedLoading.wrappedValue = true
        }
    }
}

struct BrowserView: View {
    let url: URL
    @State var finishedLoading: Bool = false

    var body: some View {

        ZStack {
            WebView(url: url, finishedLoading: $finishedLoading)

            if !finishedLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    BrowserView(url: URL(string: "https://npr.com/")!)
}
