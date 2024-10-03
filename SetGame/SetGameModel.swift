//
//  SetGameModel.swift
//  SetGameTesting
//
//  Created by Alfredo Perry on 9/19/24.
//

import Foundation
import SwiftUI

struct SetGameModel{

    var score = 0
    
    @State private(set) var deck: [Card] = {
        var cards = [Card]()
        var id = 1
        for number in Card.Number.allCases {
            for symbol in Card.ShapeType.allCases {
                for shading in Card.ShadingType.allCases {
                    for color in Card.ColorType.allCases {
                        cards.append(Card(id: id, number: number, symbol: symbol, shading: shading, color: color))
                        id += 1
                    }
                }
            }
        }
        return cards.shuffled()
        //The () after the closing bracket executes the closure immediately so it is already initiated.
    }()
    
    func isSet(cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }
        let numbers = Set(cards.map{ $0.number})
        let symbols = Set(cards.map{ $0.symbol})
        let shadings = Set(cards.map({$0.shading}))
        let colors = Set(cards.map({$0.color}))
        
        var features = [Int]()
        
        features.append(numbers.count)
        features.append(symbols.count)
        features.append(shadings.count)
        features.append(colors.count)
        
        return features.allSatisfy{$0 == 1 || $0 == 3}
    }
    
    struct Card: Equatable, Identifiable {
        enum Number: Int, CaseIterable {
            case one = 1, two, three
        }
        enum ShapeType: CaseIterable {
            case oval, rectangle, diamond
        }
        enum ShadingType: CaseIterable {
            case filled, transparent, outlined
        }
        enum ColorType: CaseIterable {
            case red, green, purple
            var cardColor: Color{
                switch self {
                case .red:
                    return .red
                case .green:
                    return .green
                case .purple:
                    return .purple
                }
            }
        }
        var selected: Bool = false
        let id: Int
        let number: Number
        let symbol: ShapeType
        let shading: ShadingType
        let color: ColorType
    }
}
