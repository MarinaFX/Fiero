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
 let view = Text("").background(someColor.color)
 
 let colorArray = Tokens.Colors.Brand.allCases.map(\.color)
 colorArray[0]
 
 OR
 
 let EnumColorArray = Tokens.Colors.Brand.allCases
 colorArray[0].color
 
 */
enum Tokens {
    //MARK: - Blur
    enum Blur {
        case none
        case small
        
        var blur: CGFloat {
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
            
            var borderRadius: CGFloat {
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
                var color: Color {
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
                var color: Color {
                    switch self {
                        case .pure:
                            return Color(red: 1, green: 0.251, blue: 0.137, opacity: 1)
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
                
                var color: Color {
                    switch self {
                        case .pure:
                            return Color(red: 0, green: 0, blue: 0, opacity: 1)
                        case .light:
                            return Color(red: 0.741, green: 0.745, blue: 0.776, opacity: 1)
                        case .dark:
                            return Color(red: 0.203, green: 0.204, blue: 0.213, opacity: 1)
                    }
                }
            }
            
            //MARK: - Colors | Neutral | High
            enum High {
                case pure
                case light
                case dark
                
                var color: Color {
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
            
            var color: Color {
                switch self {
                    case .wrong:
                        return Color(red: 1, green: 0, blue: 0, opacity: 1)
                }
            }
        }
    }
    
    //MARK: - Fonts
    enum Fonts {
        //MARK: - Font Sizes
        enum Size {
            case xxs
            case xs
            case sm
            case md
            case lg
            case xg
            
            var size: CGFloat {
                switch self {
                case .xxs:
                    return CGFloat(12)
                case .xs:
                    return CGFloat(16)
                case .sm:
                    return CGFloat(20)
                case .md:
                    return CGFloat(24)
                case .lg:
                    return CGFloat(32)
                case .xg:
                    return CGFloat(40)
                }
            }
        }
        
        //MARK: - Font Family
        enum Familiy {
            case sfprodisplay
            case sfprorounded
            
            var family: Font.Design {
                switch self {
                    case .sfprodisplay:
                        return .default
                    case .sfprorounded:
                        return .rounded
                }
            }
        }
        
        //MARK: - Font Weight
        enum Weight {
            case regular
            case bold
            case black
            
            var weight: Font.Weight {
                switch self {
                    case .regular:
                        return .regular
                    case .bold:
                        return .bold
                    case .black:
                        return .black
                }
            }
        }
    }
    
    //TODO: - Pending
    enum LineHeight {
        case `default`
        case small
        
        //var lineHeight:
    }
    
    //MARK: - Spacing
    enum Spacing {
        case quarck
        case nano
        case xxxs
        case xxs
        case xs
        case sm
        case md
        case lg
        case xl
        case xxl
        case xxxl
        
        var spacing: Double {
            switch self {
                case .quarck:
                    return 4.0
                case .nano:
                    return 8.0
                case .xxxs:
                    return 16.0
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
