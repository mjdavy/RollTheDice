//
//  ContentView.swift
//  RollTheDice
//
//  Created by Martin Davy on 5/3/24.
//

import SwiftUI
import SceneKit
import DiceView3D

struct ContentView: View {
    
    @Environment (DiceModel.self) private var diceModel
    @Environment (GameViewModel.self) private var gameViewModel
    
    @State var rollButtonDisabled = false
    @State var rollCount = 0
    
    var body: some View {
        VStack {
            scores
                .padding()
            
            GameView()
            
            DiceView(diceModel: diceModel)
                .edgesIgnoringSafeArea(.all)
                .border(.black)
                .cornerRadius(10)
            
            buttons
                //.foregroundColor(Color(red: 0, green: 100.0/255.0, blue: 0)) // dark green
                .disabled(rollButtonDisabled)
                .opacity(rollButtonDisabled ? 0.3 : 1)
            
        }.padding()
    }
    
    var scores : some View {
        Text("Dice Values: \(diceModel.values.map { String($0) }.joined(separator: ", "))")
    }
    
    var buttons : some View {
        HStack {
            Button("Roll", systemImage: "dice") {
                rollButtonDisabled = true
                diceModel.roll = true
                diceModel.onRollComplete = { values in
                    print("roll complate \(values)")
                    rollCount += 1
                    rollButtonDisabled = false
                    diceModel.canSelectDice = rollCount > 0
                    gameViewModel.updatePossibleScores(dice: values, playerIndex: 0)
                }
            }
            
            Button("Arrange",systemImage: "align.horizontal.center.fill") {
                diceModel.arrangeDice = true
                
            }
        }
    }
}

#Preview {
    ContentView()
}

