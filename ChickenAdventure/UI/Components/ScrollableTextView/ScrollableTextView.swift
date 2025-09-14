import SwiftUI

struct ScrollableTextView: View {
    let text: String
    let font: Font
    let color: Color
    let minHeight: CGFloat
    let maxHeight: CGFloat
    
    init(
        text: String,
        font: Font = AppTheme.typography.bodyLarge,
        color: Color = .appDarkPink,
        minHeight: CGFloat = 100,
        maxHeight: CGFloat = 200
    ) {
        self.text = text
        self.font = font
        self.color = color
        self.minHeight = minHeight
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        ScrollView {
            Text(text)
                .font(font)
                .foregroundColor(color)
                .multilineTextAlignment(.center)
                .padding(AppTheme.spacing.cardPadding)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(minHeight: minHeight, maxHeight: maxHeight)
    }
}

#Preview {
    VStack(spacing: 20) {
        AppCard {
            ScrollableTextView(
                text: "Short text"
            )
        }
        
        AppCard {
            ScrollableTextView(
                text: "This is a long text for scrolling demonstration. When the text becomes too long to display in a limited area, the user can scroll the content to see the entire text. This is a very useful feature for a text adventure game, where the scene descriptions can be quite detailed and contain a lot of important information for the player."
            )
        }
    }
    .padding()
    .background(AppBackground())
}
