//
//  GameView.swift
//  RollTheDice
//
//  Created by Martin Davy on 5/3/24.
//


import SwiftUI
import DiceView3D

struct GameView: View {
    @Environment (DiceModel.self) private var diceModel
    @Environment (GameViewModel.self) private var gameViewModel
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 6)
        
        LazyVGrid(columns: columns) {
            ForEach(0..<6, id: \.self) { row in
                ForEach(0..<6) { column in
                    let index = column * 6 + row
                    ZStack {
                        RoundedRectangle(cornerRadius:4)
                            .strokeBorder(lineWidth: 2)
                            .fill(gameViewModel.canChoose(index) ? Color.secondary : Color.primary)
                            .opacity(0.2)
                            .frame(height: 50)
                        
                        Text(gameViewModel.values[index])
                            .font(.title)
                    }
                    .clipped()
                    .id(row * 6 + column) // Unique ID for each child view
                    .onTapGesture {
                        if gameViewModel.canChoose(index) {
                            print("Cell \(index) clicked")
                            gameViewModel.choose(index)
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    GameView()
}
