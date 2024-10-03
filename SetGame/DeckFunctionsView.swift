//
//  DeckFunctionsView.swift
//  SetGame
//
//  Created by Alfredo Perry on 10/2/24.
//

import SwiftUI

struct DeckFunctionsView: View {
    typealias Card = SetGameModel.Card

    var body: some View {
        HStack{
            undealtCards
        }
    }
    
    private let deckWidth: CGFloat = 50

    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool{
        dealt.contains(card.id)
    }
    private var undealtCards: [Card] {
        viewModel.deck
    }
    
    private var discardedCard: [Card]
        
    private func deal(){
        var delay: TimeInterval = 0
        var cardsToDeal: Int = undealtCards.count == 80 ? 12 : 3
        for _ in 0..<cardsToDeal{
            withAnimation(dealAnimation.delay(0.125)){
                _ = dealt.insert(undealtCards.count)
            }
            delay += 0.1
        }
    }
    
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    
    private var discardPile: some View{
        ZStack{
            ForEach(discardedCard){ card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
    }
    
    
    private var deckToDealFrom: some View{
        ZStack{
            ForEach(undealtCards){ card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            deal()
        }
}
}

#Preview {
    DeckFunctionsView()
}
