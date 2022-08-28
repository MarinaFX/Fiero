//
//  GIfImage.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 26/08/22.
//

import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
        )
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.backgroundColor = UIColor(.clear)
        webView.isOpaque = false
        webView.isUserInteractionEnabled = false

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }

}


struct GifImage_Previews: PreviewProvider {
    static var previews: some View {
        GifImage("ezgif.com-gif-maker (1)")
    }
}

