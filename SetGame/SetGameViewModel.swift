//
//  SetGameViewModel.swift
//  SetGameTesting
//
//  Created by Alfredo Perry on 9/19/24.
//

import Foundation
import SwiftUI

class SetGame: ObservableObject{
    @Published private var model = SetGame.createSetGame()
    @Published var selectedCards = [SetGameModel.Card]()
    @Published var dealtCards: [SetGameModel.Card] = []
    
    var deckIndex = 80
    
    init(){
        dealCards(cardsToDeal: 12)
    }
    
    private static func createSetGame() -> SetGameModel{
        return SetGameModel()
    }
    
    var deck: [SetGameModel.Card]{
        return model.deck
    }
    
    var score: Int{
        return model.score
    }
    
    
    
    //MARK: Intents
    
    func increaseScore(increment: Int){
        model.score += increment
    }
    
    func newGame(){
        model = SetGame.createSetGame()
        selectedCards.removeAll()
        dealtCards.removeAll()
        deckIndex = 80
        dealCards(cardsToDeal: 12)
    }
    
    func removeFromDealtCards(_ card: SetGameModel.Card){
        dealtCards.removeAll(where: { $0 == card })
    }
    
    func dealCards(cardsToDeal: Int){
        for _ in 0..<cardsToDeal {
            if (deckIndex >= 0){
                dealtCards.append(model.deck[deckIndex])
                deckIndex -= 1
            }
        }
    }
    
    func isSet(cards: [SetGameModel.Card]) -> Bool {
        return model.isSet(cards: cards)
    }
    
    func chooseCards(_ card: SetGameModel.Card){
        if dealtCards.firstIndex(where: {$0.id == card.id}) != nil{
            if(selectedCards.contains(where: {$0.id == card.id})){
                selectedCards.removeAll(where: { $0 == card })
            }
            else {
                selectedCards.append(card)
            }
        }
    }
    
}
