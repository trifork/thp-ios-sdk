import SwiftUI

public struct THPIODCSafariWebView: View {
    private let url: URL

    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        SafariWebView(url: url)
            .ignoresSafeArea()
    }
}
