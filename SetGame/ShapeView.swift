//
//  ShapeView.swift
//  SetGameTesting
//
//  Created by Alfredo Perry on 9/21/24.
//

import SwiftUI

struct ShapeView: View {
    var card: SetGameModel.Card
    
    var body: some View {
        VStack {
            ForEach(0..<card.number.rawValue, id: \.self) { _ in
                shape(for: card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .frame(maxWidth: 75, maxHeight: 75)
            }
        }
        .padding()
    }
    
    // Return the appropriate shape based on card attributes
    @ViewBuilder
    func shape(for card: SetGameModel.Card) -> some View {
        let color = makeColor(card.color)
        let shading = card.shading
        
        // Use a switch statement to select the right shape
        switch card.symbol {
        case .rectangle:
            ShadedShape(shape: Rectangle(), color: color, shading: shading)
            
        case .oval:
            ShadedShape(shape: Ellipse(), color: color, shading: shading)
            
        case .diamond:
            ShadedShape(shape: Diamond(), color: color, shading: shading)
        }
    }
    
    // Helper function to return the correct color
    func makeColor(_ color: SetGameModel.Card.ColorType) -> Color {
        switch color {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }
    
    // Custom diamond shape
    struct Diamond: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.closeSubpath()
            return path
        }
    }
    
    // A view that returns the correct shading for the shape
    struct ShadedShape<S: Shape>: View {
        let shape: S
        let color: Color
        let shading: SetGameModel.Card.ShadingType
        
        var body: some View {
            switch shading {
            case .filled:
                shape.fill(color)
            case .transparent:
                shape.fill(color.opacity(0.3))
            case .outlined:
                shape.stroke(color, lineWidth: 2)
            }
        }
    }
}
