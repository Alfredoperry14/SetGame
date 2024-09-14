//
//  SetGameView.swift
//  SetGame
//
//  Created by Alfredo Perry on 9/10/24.
//

import Foundation
import SwiftUI


class SetGame: ObservableObject{
    @Published private var model = SetGame.createSetGame()

    private static func createSetGame() -> SetGameModel{
        return SetGameModel()
    }
    
    
    var deck: [SetGameModel.Card]{
        return model.deck
    }
    
    var dealtCards: [SetGameModel.Card]{
        return model.dealtCards
    }
    
     
    //MARK: - Intents
    func chooseCards(_ card: SetGameModel.Card) -> Bool?{
        return model.chooseCards(card)
    }
    
    func dealCards(cardsToDeal: Int){
        model.dealCards(cardsToDeal: cardsToDeal)
    }
}
