//
//  ContentView.swift
//  SetGameTesting
//
//  Created by Alfredo Perry on 9/19/24.
//

import SwiftUI


import SwiftUI

struct SetGameView: View {
    
    typealias Card = SetGameModel.Card
    
    @ObservedObject var viewModel = SetGame()
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        HStack{
            withAnimation(){
                Text("Score: \(viewModel.score)")
                    .bold()
            }
            Spacer()
            Button("New Game"){
                newGame()
            }
        }
        .padding()
        VStack{
            cards
                .padding()
            deckManipulators
        }
    }
    
    private func newGame(){
        viewModel.newGame()
        dealt.removeAll()
        discardedCards.removeAll()
        deckIndex = viewModel.deck.count - 1
    }
    
    private var deckManipulators: some View{
        HStack{
            discardPile
            Spacer()
            Button("Shuffle"){
                withAnimation{
                    dealt.shuffle()
                }
            }
            Spacer()
            deckToDealFrom
        }
        .padding()
    }
    
    private let deckWidth: CGFloat = 50
    
    @State private var dealt: [Card] = []
    @State private var discardedCards: [Card] = []
    private func isDealt(_ card: Card) -> Bool{
        dealt.contains(card)
    }
    private func isDiscarded(_ card: Card) -> Bool{
        discardedCards.contains(card)
    }
    
    private func isInDeck(_ card: Card) -> Bool {
        !isDealt(card) && !isDiscarded(card)
    }
    
    @State private var deckIndex = 80
    private func deal(){
        var delay: TimeInterval = 0
        let cardsToDeal: Int = dealt.isEmpty ? 12 : 3
        
        for _ in 0..<cardsToDeal{
            if(deckIndex >= 0){
                withAnimation(dealAnimation.delay(delay)){
                    dealt.append(viewModel.deck[deckIndex])
                }
            }
            deckIndex -= 1
            delay += 0.25
        }
    }
    
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    
    
    @Namespace private var discardNamespace
    private var discardPile: some View{
        ZStack{
            ForEach(discardedCards){ card in
                CardView(card: card, selected: [], discardedCards: $discardedCards, dealt: $dealt)
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
    }
    
    @Namespace private var dealingNamespace
    
    private var deckToDealFrom: some View{
        ZStack{
            ForEach(viewModel.deck.filter{isInDeck($0)}){ card in
                CardView(card: card, selected: viewModel.selectedCards, discardedCards: $discardedCards, dealt: $dealt)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 5), count: 4)
    
    var cards: some View{
        ScrollView{
            LazyVGrid(columns: columns, spacing: 10){
                ForEach(dealt){ card in
                    CardView(card: card, selected: viewModel.selectedCards, discardedCards: $discardedCards, dealt: $dealt)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .matchedGeometryEffect(id: card.id, in: discardNamespace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                        .padding(4)
                        .onTapGesture {
                            viewModel.chooseCards(card)
                            selectingCards()
                        }
                }
            }
        }
    }
    
    @State private var increaseDecrease: Bool?
    
    private func selectingCards(){
        if(viewModel.selectedCards.count == 3){
            let setAnswer = viewModel.isSet(cards: viewModel.selectedCards)
            if(setAnswer == true){
                withAnimation(.smooth){
                    for card in viewModel.selectedCards{
                        discardedCards.append(card)
                    }
                    dealt = dealt.filter{!viewModel.selectedCards.contains($0)}
                    increaseDecrease = viewModel.changeScore(increment: 1)
                }
                viewModel.selectedCards.removeAll()
                deal()
                increaseDecrease = false
            }
            else{
                withAnimation(.linear(duration: 1)){
                    viewModel.selectedCards.removeAll()
                    
                }
                increaseDecrease = viewModel.changeScore(increment: -1)
            }
        }
    }
}

struct CardView: View{
    let card: SetGameModel.Card
    let selected: [SetGameModel.Card]
    @Binding var discardedCards: [SetGameModel.Card]
    @Binding var dealt: [SetGameModel.Card]
    
    var facing: Bool{
        if(dealt.contains(card)){
            return false
        } else if discardedCards.contains(card){
            return false
        }
        return true
    }
    
    var body: some View{
        ZStack{
            let base = RoundedRectangle(cornerRadius: 12)
            base.strokeBorder(lineWidth: selected.contains(card) ? 5 : 2)
                .background(base.fill(.white))
            
            ShapeView(card: card)
                .aspectRatio(2/3, contentMode: .fit)
            
            //Will cover the card if it hasn't been dealt
            let cardFacing = RoundedRectangle(cornerRadius: 12)
            cardFacing.strokeBorder(lineWidth: 2)
                .foregroundStyle(.teal)
                .opacity(2)
            cardFacing.fill(facing ? .teal : .clear)
        }
    }
}

#Preview {
    SetGameView()
}
