//
//  SetGameModel.swift
//  SetGame
//
//  Created by Alfredo Perry on 9/10/24.
//

import Foundation
import SwiftUI

struct SetGameModel{
    
    private(set) var deck: [Card]
    private(set) var dealtCards: [Card]
    
    init(){
        enum CardColor:String, CaseIterable{
            case red = "red"
            case green = "green"
            case purple = "purple"
        }
        enum CardShape: String, CaseIterable{
            case rectangle = "rectangle"
            case oval = "oval"
            case diamond = "diamond"
        }
        enum CardShading: String, CaseIterable{
            case filled = "filled"
            case outlined = "outlined"
            case transparent = "transparent"
        }
        enum CardNumber: String, CaseIterable{
            case one = "one"
            case two = "two"
            case three = "three"
        }
        
        deck = []
        dealtCards = []
        var id = 0
        for cardShape in CardShape.allCases{
            for cardColor in CardColor.allCases{
                for cardShading in CardShading.allCases{
                    for cardNumber in CardNumber.allCases{
                        let attributes = Card.Attributes(color: cardColor.rawValue, shape: cardShape.rawValue, shading: cardShading.rawValue, number: cardNumber.rawValue)
                        deck.append(Card(id: id, Attributes: attributes))
                        id += 1
                    }
                }
            }
        }
        deck.shuffle()
        dealCards(cardsToDeal: 12)
    }
    
    
    mutating func chooseCards(_ card: Card) -> Bool?{
        let selectedCards = dealtCards.filter{$0.isChosen}
        if let chosenIndex = dealtCards.firstIndex(where: {$0.id == card.id}){
            dealtCards[chosenIndex].isChosen.toggle()
            if(selectedCards.count == 3){
                let isASet = isSet()
                withAnimation{
                    if(isASet){
                        dealtCards.removeAll(where:{$0.isChosen})
                    }
                    else{
                        for index in dealtCards.indices{
                            dealtCards[index].isChosen = false
                        }
                    }
                }
                return isASet
            }
        }
        //We are returning nil if there are only 3 cards selected
        return nil
    }
    
    mutating func isSet() -> Bool{
        let selectedCards = dealtCards.filter{$0.isChosen}
        let cardOne = selectedCards[0]
        let cardTwo = selectedCards[1]
        let cardThree = selectedCards[2]
        
        //If all these cases are true it means that the cards in each category are either all the same or all different (which is a set)
        if(checkIndividualAttributes(cardOne.Attributes.color, cardTwo.Attributes.color, cardThree.Attributes.color)){
            if(checkIndividualAttributes(cardOne.Attributes.number, cardTwo.Attributes.number, cardThree.Attributes.number)){
                if(checkIndividualAttributes(cardOne.Attributes.shading, cardTwo.Attributes.shading, cardThree.Attributes.shading)){
                    if(checkIndividualAttributes(cardOne.Attributes.shape, cardTwo.Attributes.shape, cardThree.Attributes.shape)){
                        return true
                    }
                }
            }
        }
        return false
    }
    
    //This tests the cards attributes to see if they are all the same or different.
    func checkIndividualAttributes(_ cardOne: String,_ cardTwo: String,_ cardThree: String) -> Bool{
        let firstTest = cardOne == cardTwo
        let secondTest = cardTwo == cardThree
        let thirdTest = cardOne == cardThree
        //True because all the cards are different from eachother
        if(firstTest == false && secondTest == false && thirdTest == false){
            return true
        }
        return firstTest && secondTest && thirdTest
    }

    
    mutating func dealCards(cardsToDeal: Int){
        for _ in 0..<cardsToDeal{
            if let card = deck.popLast(){
                dealtCards.append(card)
            }
        }
    }

    struct Card: Identifiable, CustomDebugStringConvertible{
        let id: Int
        var isMatched: Bool = false
        var isChosen: Bool = false
        struct Attributes{
            var color: String
            var shape: String
            var shading: String
            var number: String
        }
        var Attributes: Attributes
        var debugDescription: String {
            return "\(id)"
        }
        

    }
}
