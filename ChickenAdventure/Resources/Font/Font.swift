
import SwiftUI

extension Font {
    enum Kalam {
        static let kalamRegular = "Kalam-Regular"
        static let kalamLight = "Kalam-Light"
        static let kalamBold = "Kalam-Bold"
    }
    
    static func uiPrimaryBold(size: CGFloat) -> UIFont {
        return UIFont(name: Kalam.kalamBold, size: size)!
    }

    static func primaryBold(size: CGFloat) -> Font {
        return .custom(Kalam.kalamBold, size: size)
    }

    static func primaryRegular(size: CGFloat) -> Font {
        return .custom(Kalam.kalamRegular, size: size)
    }
}


struct TextStyle: Hashable {
    let font: Font
    let color: Color
}

struct TextConfig: Hashable {
    let text: String
    let style: TextStyle
    
    static let empty: Self = .init(text: "", style: .init(font: .callout, color: .green))
    
    init(
        text: String,
        style: TextStyle
    ) {
        self.text = text
        self.style = style
    }
}

