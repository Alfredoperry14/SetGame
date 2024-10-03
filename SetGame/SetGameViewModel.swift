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
    //@Published var dealtCards: [SetGameModel.Card] = []
    //@Published var discardPile: [SetGameModel.Card] = []
    
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
    
    
    func newGame(){
        model = SetGameModel()
        selectedCards.removeAll()
        model.score = 0
    }
    
    func changeScore(increment: Int) -> Bool{
        model.score += increment
        return increment > 0 ? true : false
    }
        
    func isSet(cards: [SetGameModel.Card]) -> Bool {
        return model.isSet(cards: cards)
    }
    
    func chooseCards(_ card: SetGameModel.Card){
        if deck.firstIndex(where: {$0.id == card.id}) != nil{
            if(selectedCards.contains(where: {$0.id == card.id})){
                selectedCards.removeAll(where: { $0 == card })
            }
            else {
                selectedCards.append(card)
            }
        }
    }
    
}
