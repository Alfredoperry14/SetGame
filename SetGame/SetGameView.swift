//
//  ContentView.swift
//  SetGameTesting
//
//  Created by Alfredo Perry on 9/19/24.
//

import SwiftUI


import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel = SetGame()
    private let aspectRatio: CGFloat = 2/3
    @State private var isSetAnswer: Bool?
    
    var body: some View {
        HStack{
            Text("Score: \(viewModel.score)")
                .bold()
            Spacer()
            Button("New Game"){
                viewModel.newGame()
                isSetAnswer = nil
            }
        }
        .padding()
        VStack{
            cards
                .padding()
                .animation(.default, value: viewModel.dealtCards)
            if let isSetAnswer{
                Text(isSetAnswer ? "It's a Set! +1" : "Not a Set, -1")
                    .foregroundStyle((isSetAnswer ? .green : .red) ?? .white)
            }
            Button("Deal 3"){
                viewModel.dealCards(cardsToDeal: 3)
            }
            .disabled(viewModel.deckIndex < 0)
            //.foregroundStyle(viewModel.deckIsEmpty() ? .gray : .blue)
        }
    }
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 5), count: 4)
    
    private var cards: some View{
        ScrollView{
            LazyVGrid(columns: columns, spacing: 10){
                ForEach(viewModel.dealtCards){ card in
                    CardView(card: card, isSelected: viewModel.selectedCards.contains(where: { $0.id == card.id }))
                        .padding(4)
                        .onTapGesture {
                            viewModel.chooseCards(card)
                            isSetAnswer = nil
                            if(viewModel.selectedCards.count == 3){
                                let setAnswer = viewModel.isSet(cards: viewModel.selectedCards)
                                if(setAnswer == true){
                                    viewModel.dealtCards.removeAll(where: { viewModel.selectedCards.contains($0)})
                                    viewModel.selectedCards.removeAll()
                                    isSetAnswer = true
                                    viewModel.dealCards(cardsToDeal: 3)
                                    viewModel.increaseScore(increment: 1)
                                }
                                else{
                                    viewModel.selectedCards.removeAll()
                                    isSetAnswer = false
                                    viewModel.increaseScore(increment: -1)
                                }
                            }
                        }
                }
            }
        }
    }
}

struct CardView: View{
    let card: SetGameModel.Card
    var isSelected: Bool
    var body: some View{
        ZStack{
            let base = RoundedRectangle(cornerRadius: 12)
            base.strokeBorder(lineWidth: isSelected ? 5 : 2)
            ShapeView(card: card)
                .aspectRatio(2/3, contentMode: .fit)
        }
    }
}


#Preview {
    SetGameView()
}
