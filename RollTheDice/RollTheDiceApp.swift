//
//  RollTheDiceApp.swift
//  RollTheDice
//
//  Created by Martin Davy on 5/3/24.
//

import SwiftUI
import DiceView3D

@main
struct RollTheDiceApp: App {
    @State var diceModel : DiceModel
    @State var gameViewModel : GameViewModel
    
    let faces =  "🍋🫐🍉🍒🍓🍇".map { String($0) }
    let combos =  "🍟🍔🏠🍷🍸🎂".map { String($0) }
    let forfeits =  "👟👕👖👗🩲👙".map { String($0) }
    let players = ["player1", "player2", "player3"]
    
    init() {
       
        let faceScheme = FaceRenderingScheme.string
        let (values, faces) = Self.initialValues(dieCount: 5, faceScheme: faceScheme)
        
        diceModel = DiceModel(
            initialValues: values,
            faceScheme: faceScheme,
            faces: faces,
            selectedColor: .yellow,
            canSelect: true
        )
        
        gameViewModel = GameViewModel(
            players: players,
            faces: faces,
            combos: combos,
            forfeits: forfeits
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(diceModel)
                .environment(gameViewModel)
            
        }
    }
    
    static func initialValues(dieCount: Int, faceScheme: FaceRenderingScheme) -> ([Int],[String])
    {
        precondition(dieCount > 0 && dieCount < 6)
        let initialValues = (1...dieCount).map { _ in Int.random(in: 1...6) }
        var faces: [String]
        
        switch faceScheme {
        case .namedImage:
            faces = (1...6).map { "dice\($0)" }
        case .string:
            faces = "🍋🫐🍉🍒🍓🍇".map { String($0) }
        }
        return (initialValues, faces)
    }
}
