//
//  KeyboardView.swift
//  CustomKeyboard
//
//  Created by Normand Martin on 2023-01-31.
//

import SwiftUI

struct Keyboard: View {
    var topRowArray = "QWERTYUIOP".map{ String($0) }
    var secondRowArray = "ASDFGHJKL".map{ String($0) }
    var thirdRowArray = "ZXCVBNM".map{ String($0) }
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    @State private var boutonDiameter: CGFloat = 54
    @Binding var selectedLetter: String
    @Binding var selectedRow: Int
    @Binding var selectedColumn: Int
    @Binding var isHorizontal: Bool
    @Binding var countingTappedLetters: Int
    @Binding var grid: [[String]]
    var motsCroisesSelected: String
    var cursorMovement: () -> ()
    var reverseCursorMovement: () -> ()
    @Binding var arrowTyped: Bool
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(topRowArray, id: \.self) { letter in
                    Button(action: {
                        if grid[selectedRow][selectedColumn] == "#"{
                            print("#")
                        }else{
                            self.selectedLetter = letter
                            changeGenerator()
                        }
                        arrowTyped = false
                    }) {
                        Text(letter)
                            .font(.system(size: 22))
                            .frame(width: boutonDiameter, height: boutonDiameter)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(boutonDiameter/2)
                    }
                }
            }
            HStack{
                Button {
                    reverseCursorMovement()
                    arrowTyped = true
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .heavy))
                        .frame(width: boutonDiameter, height: boutonDiameter)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(boutonDiameter/2)
                        
                }
                ForEach(secondRowArray, id: \.self) { letter in
                    Button(action: {
                        self.selectedLetter = letter
                        arrowTyped = false
                        changeGenerator()
                    }) {
                        Text(letter)
                            .font(.system(size: 22))
                            .frame(width: boutonDiameter, height: boutonDiameter)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(boutonDiameter/2)
                    }
                }
                Button {
                    cursorMovement()
                    arrowTyped = true
                } label: {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20, weight: .heavy))
                        .frame(width: boutonDiameter, height: boutonDiameter)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(boutonDiameter/2)
                }
            }
            HStack {
                ForEach(thirdRowArray, id: \.self) { letter in
                    Button(action: {
                        self.selectedLetter = letter
                        arrowTyped = false
                        changeGenerator()
                    }) {
                        Text(letter)
                            .font(.system(size: 22))
                            .frame(width: boutonDiameter, height: boutonDiameter)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(boutonDiameter/2)
                    }
                }
                Button {
                    selectedLetter = ""
                    CoreDataHandler.fetchItemSaveLetter(noDeLettre: "\(selectedRow),\(selectedColumn)", newLetter: selectedLetter, grilleSelected: motsCroisesSelected)
                    reverseCursorMovement()
                    selectedLetter = ""
                    arrowTyped = false
                    
                } label: {
                    Image(systemName: "delete.backward.fill")
                        .font(.system(size: 20, weight: .heavy))
                        .frame(width: boutonDiameter, height: boutonDiameter)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(boutonDiameter/2)
                }
            }
        }
        .onAppear{
            boutonDiameter = deviceWidth * 0.037
        }
    }
    func changeGenerator(){
        countingTappedLetters += 1
        if countingTappedLetters == 100 {countingTappedLetters = 0}
    }
}
//
//struct Keyboard_Previews: PreviewProvider {
//    static var previews: some View {
//        Keyboard(selectedLetter: .constant("A"),selectedRow: .constant(0), selectedColumn: .constant(0), isHorizontal: .constant(false), countingTappedLetters: .constant(0), grid: <#Binding<[[String]]>#>)
//    }
//}
