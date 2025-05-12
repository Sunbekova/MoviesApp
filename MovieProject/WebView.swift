//
//  WebView.swift
//  MovieProject
//
//  Created by Тулепберген Анель  on 12.05.2025.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: url) else { return }
        uiView.load(URLRequest(url: url))
    }
}
