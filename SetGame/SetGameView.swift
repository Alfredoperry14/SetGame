//
//  ContentView.swift
//  SetGame
//
//  Created by Alfredo Perry on 9/10/24.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel = SetGame()
    private let aspectRatio: CGFloat = 2/3
    @State private var isSetAnswer: Bool?
    
    var body: some View {
        VStack{
            cards
                .padding()
            if let isSetAnswer{
                Text(isSetAnswer ? "It's a Set!" : "Not a Set")
                    .foregroundStyle((isSetAnswer ? .green : .red) ?? .white)
            }
            Button("Deal 3"){
                viewModel.dealCards(cardsToDeal: 3)
            }
        }
    }
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 5), count: 4)
    
    private var cards: some View{
        ScrollView{
            LazyVGrid(columns: columns, spacing: 10){
                ForEach(viewModel.dealtCards){ card in
                    CardView(card: card)
                        .padding(4)
                        .onTapGesture {
                            let isSet = viewModel.chooseCards(card)
                            if(isSet == true){
                                viewModel.dealCards(cardsToDeal: 3)
                                isSetAnswer = true
                            }
                            else if(isSet == false){
                                isSetAnswer = false
                            }
                            else{
                                isSetAnswer = nil
                            }
                        }
                }
            }
        }
    }
    
    struct CardView: View{
        let card: SetGameModel.Card
        var body: some View{
            ZStack{
                let base = RoundedRectangle(cornerRadius: 12)
                base.strokeBorder(lineWidth: card.isChosen ? 5 : 2)
                ShapeView(card: card)
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
    }
}


//Creates the shape
struct ShapeView: View {
    var card: SetGameModel.Card
    
    var body: some View {
        VStack{
            numberOfShapes{
                shape(card)
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .padding()
    }
    
    func shape(_ card: SetGameModel.Card) -> some View {
        let color = makeColor(card.Attributes.color)
        let shading = card.Attributes.shading
        switch card.Attributes.shape {
        case "rectangle":
            return ShadedShape(shape: AnyShape(Rectangle()), color: color, shading: shading)
            
        case "oval":
            return ShadedShape(shape: AnyShape(Ellipse()), color: color, shading: shading)
            
        case "diamond":
            return ShadedShape(shape: AnyShape(Diamond()), color: color, shading: shading)
            
        default:
            return ShadedShape(shape: AnyShape(Capsule()), color: color, shading: shading)
        }
    }
    
    @ViewBuilder
    func numberOfShapes<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        switch card.Attributes.number {
        case "one":
            content()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 75, maxHeight: 75)
        case "two":
            VStack{
                content()
                content()
            }
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 100, maxHeight: 100)
        case "three":
            VStack{
                content()
                content()
                content()
            }
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 100, maxHeight: 150)
        default:
            Text("Error")
                .font(.largeTitle)
        }
    }
    
    func makeColor(_ color: String) -> Color{
        switch color{
        case "red": return .red
        case "green": return .green
        case "purple": return .purple
        default: return .black
        }
    }
    struct Diamond: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            // Starting point: Top center of the rectangle
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            
            // Right point
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            
            // Bottom point
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            
            // Left point
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            
            // Close the path to return to the starting point
            path.closeSubpath()
            
            return path
        }
    }
    
    //Ensures the shape being returned is a view
    struct ShadedShape<S: Shape>: View {
        var shape: S
        var color: Color
        var shading: String
        
        var body: some View {
            switch shading {
            case "filled":
                shape.fill(color)
            case "transparent":
                shape.fill(color.opacity(0.3))
            case "outlined":
                shape.stroke(color, lineWidth: 2)
            default:
                shape.fill(.white)
            }
        }
    }
    
    
}

#Preview {
    SetGameView(viewModel: SetGame())
}

