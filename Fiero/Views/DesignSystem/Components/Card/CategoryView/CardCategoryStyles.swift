import SwiftUI

enum CardCategoryStyles {
    case amount
    case blocked
    
    //MARK: - Lottie
    var lottieName: String {
        switch self {
        case .amount:
            return "quantity2"
        case .blocked:
            return "blockCategory"
        }
    }
    
    var lottieLoop: Bool {
        switch self {
        case .amount:
            return true
        case .blocked:
            return false
        }
    }
    
    //MARK: - Colors
    var cardBackgroundColor: Color {
        return Tokens.Colors.Neutral.Low.dark.value
    }
    
    var textColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    
    var buttonBackgroundColor: Color {
        return Tokens.Colors.Highlight.three.value
    }
    
    //MARK: - CornerRadius
    var cardCornerRadius: CGFloat {
        return Tokens.Border.BorderRadius.normal.value
    }
    
    var buttonCornerRadius: CGFloat {
        return Tokens.Border.BorderRadius.normal.value
    }
    
    //MARK: - Font
    var titleFont: Font {
        return Tokens.FontStyle.title.font(weigth: .bold, design: .default)
    }
    
    var subtitleFont: Font {
        return Tokens.FontStyle.callout.font()
    }
    
    var buttonFont: Font {
        return Tokens.FontStyle.callout.font(weigth: .bold, design: .default)
    }
    
    //MARK: - Spacing
    var vStackSpacing: CGFloat {
        return Tokens.Spacing.quarck.value
    }
    
    var lottieSpacing: CGFloat {
        return Tokens.Spacing.xxs.value
    }
    
    var horizontalButtonSpacing: CGFloat {
        return Tokens.Spacing.xxs.value
    }
    
    var verticalButtonSpacing: CGFloat {
        return Tokens.Spacing.nano.value
    }
    
    var titleSpacing: CGFloat {
        switch self {
        case .amount:
            return Tokens.Spacing.nano.value
        case .blocked:
            return Tokens.Spacing.xxxs.value
        }
    }
    
    var subtitleSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
    
    var cardSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
    
    
}
