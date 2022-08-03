//
//  Tokens.swift
//  Fiero
//
//  Created by Marina De Pazzi on 01/07/22.
//

import Foundation
import SwiftUI

/**
 Usage:
 let someColor = Tokens.Colors.Brand.primaryColor
 let view = Text("").background(someColor.value)
 
 let colorArray = Tokens.Colors.Brand.allCases.map(\.value)
 colorArray[0]
 
 OR
 
 let EnumColorArray = Tokens.Colors.Brand.allCases
 colorArray[0].value
 
 */
enum Tokens {
    //MARK: - Blur
    enum Blur {
        case none
        case small
        
        var value: CGFloat {
            switch self {
                case .none:
                    return CGFloat(0.0)
                case .small:
                    return CGFloat(10.0)
            }
        }
    }
    
    //MARK: - Border
    enum Border {
        enum BorderRadius {
            case none
            case small
            case circular
            
            var value: CGFloat {
                switch self {
                    case .none:
                        return CGFloat(0.0)
                    case .small:
                        return CGFloat(8.0)
                    case .circular:
                        return CGFloat(500.0)
                }
            }
        }
        
        enum BorderWidth {
            case none
            case hairline
            case thin
            case thick
            case heavy
            
            
            var value: CGFloat {
                switch self {
                    case .none:
                        return CGFloat(0)
                    case .hairline:
                        return CGFloat(0.5)
                    case .thin:
                        return CGFloat(1)
                    case .thick:
                        return CGFloat(2)
                    case .heavy:
                        return CGFloat(4)
                }
            }
        }
    }
    
    //MARK: - Colors
    enum Colors {
        
        //MARK: - Colors | Brand
        enum Brand: CaseIterable {
            
            //MARK: - Colors | Brand | Primary
            enum Primary: CaseIterable {
                case pure
                case light
                case dark
                
                //TODO: .light and .dark to be defined
                var value: Color {
                    switch self {
                        case .pure:
                            return Color(red: 1, green: 0, blue: 0.267, opacity: 1)
                        case .light:
                            return Color(red: 1, green: 0, blue: 0.267, opacity: 1)
                        case .dark:
                            return Color(red: 1, green: 0, blue: 0.267, opacity: 1)
                    }
                }
            }
            
            //MARK: - Colors | Brand | Secondary
            enum Secondary: CaseIterable {
                case pure
                case light
                case dark
                
                //TODO: .light and .dark to be defined
                var value: Color {
                    switch self {
                        case .pure:
                        return Color(red: 0.2, green: 0.423, blue: 1, opacity: 1)
                        case .light:
                            return Color(red: 1, green: 0, blue: 0.267, opacity: 1)
                        case .dark:
                            return Color(red: 1, green: 0, blue: 0.267, opacity: 1)
                    }
                }
            }
        }
        
        //MARK: - Colors | Neutral
        enum Neutral: CaseIterable {
            
            //MARK: - Colors | Neutral | Low
            enum Low {
                case pure
                case light
                case dark
                
                
                var value: Color {
                    switch self {
                        case .pure:
                            return Color(red: 0, green: 0, blue: 0, opacity: 1)
                        case .light:
                            return Color(red: 0.741, green: 0.745, blue: 0.776, opacity: 1)
                        case .dark:
                            return Color(red: 0.141, green: 0.141, blue: 0.141, opacity: 1)
                    }
                }
            }
            
            //MARK: - Colors | Neutral | High
            enum High {
                case pure
                case light
                case dark
                
                var value: Color {
                    switch self {
                        case .pure:
                            return Color(red: 1, green: 1, blue: 1, opacity: 1)
                        case .light:
                            return Color(red: 0.961, green: 0.965, blue: 0.98, opacity: 1)
                        case .dark:
                            return Color(red: 0.894, green: 0.894, blue: 0.914, opacity: 1)
                    }
                }
            }
        }
        
        //MARK: - Colors | Highlight
        enum Highlight {
            case wrong
            case one //purple
            case two //yellow
            case three //little pink
            case four //dark green
            case five //blue
            case six //light green
            
            var value: Color {
                switch self {
                    case .wrong:
                        return Color(red: 1, green: 0, blue: 0, opacity: 1)
                    case .one:
                        return Color(red: 0.345, green: 0.322, blue: 0.855, opacity: 1)
                    case .two:
                        return Color(red: 1, green: 0.722, blue: 0, opacity: 1)
                    case .three:
                        return Color(red: 1, green: 0.349, blue: 0.408, opacity: 1)
                    case .four:
                        return Color(red: 0.251, green: 0.612, blue: 0.522, opacity: 1)
                    case .five:
                        return Color(red: 0.173, green: 0.157, blue: 0.89, opacity: 1)
                    case .six:
                        return Color(red: 0.278, green: 0.758, blue: 0.557, opacity: 1)
                }
            }
        }
        
        //MARK: - Colors | Background
        enum Background {
            case light
            case dark
            
            var value: Color {
                switch self {
                    case .light:
                        return Color(red: 1, green: 1, blue: 1, opacity: 1)
                    case .dark:
                        return Color(red: 0.096, green: 0.096, blue: 0.096, opacity: 1)
                }
            }
        }
    }
    
    //MARK: - Fonts
    enum FontStyle {
        case caption2
        case caption //xxs
        case footnote
        case subheadline
        case callout //xs
        case body
        case headline
        case title3 //sm
        case title2 //=22 md= 24
        case title //=28 md= 24
        case largeTitle //=34 lg =32
        //xg= 40 
        
        var style: Font.TextStyle {
            switch self {
            case .caption2:
                return .caption2
            case .caption:
                return .caption
            case .footnote:
                return .footnote
            case .subheadline:
                return .subheadline
            case .callout:
                return .callout
            case .body:
                return .body
            case .headline:
                return .headline
            case .title3:
                return .title3
            case .title2:
                return .title2
            case .title:
                return .title
            case .largeTitle:
                return .largeTitle
            }
        }
        
        func font(weigth: Font.Weight = .regular, design: Font.Design = .default) -> Font {
            return Font.system(self.style, design: design).weight(weigth)
        }
    }
    
    //TODO: - Pending
    enum LineHeight {
        case `default`
        case small
        
        var value: CGFloat {
            switch self {
                case .default:
                    return CGFloat(1.0)
                case .small:
                    return CGFloat(1.2)
            }
        }
    }
    
    //MARK: - Spacing
    enum Spacing {
        case quarck
        case nano
        case xxxs
        case defaultMargin
        case xxs
        case xs
        case sm
        case md
        case lg
        case xl
        case xxl
        case xxxl
        
        var value: Double {
            switch self {
                case .quarck:
                    return 4.0
                case .nano:
                    return 8.0
                case .xxxs:
                    return 16.0
                case .defaultMargin:
                    return 20.0
                case .xxs:
                    return 24.0
                case .xs:
                    return 32.0
                case .sm:
                    return 40.0
                case .md:
                    return 48.0
                case .lg:
                    return 56.0
                case .xl:
                    return 64.0
                case .xxl:
                    return 80.0
                case .xxxl:
                    return 120.0
            }
        }
        
    }
}
