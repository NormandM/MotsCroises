//
//  ContentView.swift
//  KeyboardTest
//
//  Created by Normand Martin on 2023-02-01.
//

import SwiftUI
import UIKit
import Combine
struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var fieldInFocus: Bool
    @State private var orientationSubscription: AnyCancellable?
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    @State private var orientation = UIDevice.current.orientation
    @State private var grid = Array(repeating: Array(repeating: "", count: 12), count: 12)
    @State private var selectedRow = 0
    @State private var selectedColumn = 0
    @State private var selectedLetter: String = ""
    @State private var isHorizontal = true
    @State private var countingTappedLetters = 150
    @State private var grille = [[String]]()
    var motsCroisesSelected: String
    @State private var pListLettres = String()
    let dimension: Int
    @State private var definitions = [[[String]]]()
    @State private var textFieldDisabled = true
    @State private var arrayOfDefAndPosition = [(String, Int, String)](repeating: ("", 0, ""), count: 12)
    @State private var arrayOfDefAndPositionV = [(String, Int, String)](repeating: ("", 0, ""), count: 12)
    @State private var  squareWidth = CGFloat()
    @State private var wordIsSelectedH = [Bool](repeating: false, count: 100)
    @State private var wordIsSelectedV = [Bool](repeating: false, count: 100)
    @State private var letterIsGood = [[Bool]](repeating: Array(repeating: true, count: 12), count: 12)
    @State private var validerMotPressed = false
    @State private var valideLettrePressed = false
    @State private var validerGrillePressed = false
    @State private var  verticalSelectedCell = [Int]()
    @State private var showLetter = false
    @State private var showMot = false
    @State private var showAlert = false
    @State private var alertType = AlertType.noError
    @State private var selectedItem = [0,0]
    @State private var selectedItemH = 0
    @State private var selectedItemV = 0
    @State private var listLenght = 0.0
    @State private var arrayOfDefinitionsH = [String]()
    @State private var arrayOfDefinitionsV = [String]()
    @State private var arrowTyped = false
    @State private var removeAlertWindow = false
    @State private var secondsElapsed = 0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var showTousLesTemps = false

    var body: some View {
        let minutes = secondsElapsed / 60
        let seconds = secondsElapsed % 60
        ZStack{
            ColorReferenceC.coralColorLigh
                .ignoresSafeArea()
            VStack{
                HStack{
                    Text("MOTS CROISÉS \(motsCroisesSelected)")
                        .font(.title)
                        .fontWeight(.bold)
                }

                ZStack {
                    ColorReferenceC.coralColorLigh
                    HStack{
                        VStack{
                            Text("HORIZONTALEMENT")
                                .fontWeight(.bold)
                                .padding(.top)
                            ScrollView{
                                ScrollViewReader{ proxy in
                                    VStack(alignment: .leading){
                                        ForEach ((0..<arrayOfDefinitionsH.count), id: \.self) {n in
                                            Text("\(arrayOfDefAndPosition[n].2). \(arrayOfDefAndPosition[n].0)")
                                                .font(wordIsSelectedH[n] ? Font.body.italic() : Font.body)
                                                .fontWeight(wordIsSelectedH[n] ? .bold : .regular)
                                                .lineLimit(nil)
                                                .multilineTextAlignment(.leading)
                                                .frame(width: deviceWidth * 0.20 ,alignment: .leading)
                                                .id(n)
                                        }
                                    }
                                    .padding(.top)
                                    .onChange(of: selectedItem) { _ in
                                        withAnimation {
                                            proxy.scrollTo(selectedItemH, anchor: .top)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width: deviceWidth * 0.25 ,height: squareWidth * CGFloat(dimension + 1))
                        .background(ColorReferenceC.sandColor)
                        .border(.black, width: 1)
                        .offset(y: squareWidth/2)
                        .padding()
                        Spacer()
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 0){
                                ForEach(0 ..< dimension + 1, id:\.self){number in
                                    Text(String(number + 1))
                                        .frame(width: squareWidth, height: squareWidth)
                                }
                            }
                            .offset(x: squareWidth/2)
                            ForEach(0 ..< dimension + 1, id:\.self) { row in
                                HStack(spacing:0) {
                                    Text(String(row + 1))
                                        .frame(width: squareWidth, height: squareWidth)
                                    
                                    ForEach(0 ..< dimension + 1, id:\.self) {column in
                                        TextField("", text: self.$grid[row][column], onCommit: {
                                            if self.isHorizontal {
                                                self.selectedRow += 1
                                                
                                            } else {
                                                self.selectedColumn += 1
                                            }
                                        })
                                        .frame(width: squareWidth, height: squareWidth)
                                        .disabled(true)
                                        .focused($fieldInFocus)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 22))
                                        .foregroundColor(returnCollorOfLetter(row: row, column: column).0)
                                        .fontWeight(returnCollorOfLetter(row: row, column: column).1)
                                        .background(getBackgroundColor(row: row, column: column).0)
                                        .border(Color.black, width: 2)
                                        .onTapGesture {
                                            selectedItem = [row, column]
                                            findPositionInDefList(row: row, column: column)
                                            self.selectedRow = row
                                            self.selectedColumn = column
                                            highlightDefinition()
                                            if grid[row][column] == "#"{
                                                if isHorizontal {
                                                    selectedColumn += 1
                                                }else{selectedRow += 1}
                                            }
                                        }
                                        .onChange(of: getBackgroundColor(row: row, column: column).1, perform: {value in
                                            verticalSelectedCell = value
                                        })
                                    }
                                }
                            }
                        }
                        Spacer()
                        VStack{
                            Text("VERTICALEMENT")
                                .fontWeight(.bold)
                                .padding(.top)
                            ScrollView{
                                ScrollViewReader{ proxy in
                                    VStack(alignment: .leading){
                                        ForEach ((0..<arrayOfDefinitionsV.count), id: \.self) {n in
                                            Text("\(arrayOfDefAndPositionV[n].2). \(arrayOfDefAndPositionV[n].0)")
                                                .font(wordIsSelectedV[n] ? Font.body.italic() : Font.body)
                                                .fontWeight(wordIsSelectedV[n] ? .bold : .regular)
                                                .lineLimit(nil)
                                                .multilineTextAlignment(.leading)
                                                .frame(width: deviceWidth * 0.20 ,alignment: .leading)
                                                .id(n)
                                        }
                                    }
                                    .padding(.top)
                                    .onChange(of: selectedItem) { _ in
                                        withAnimation {
                                            proxy.scrollTo(selectedItemV, anchor: .top)
                                        }
                                    }
                                    .onAppear {
                                        print(arrayOfDefinitionsV)
                                    }
                                }
                            }
                        }
                        .frame(width: deviceWidth * 0.25 ,height: squareWidth * CGFloat(dimension + 1))
                        .background(ColorReferenceC.sandColor)
                        .border(.black, width: 1)
                        .offset(y: squareWidth/2)
                        .padding()
                        Spacer()
                    }
                }
                HStack{
                    Spacer()
                    VStack {
                        Button {
                            isHorizontal.toggle()
                            highlightDefinition()
                        } label: {
                            Image("Icône horizontal-verticalBG3")
                                .resizable()
                                .font(.system(size: 20, weight: .heavy))
                                .frame(width: deviceWidth * 0.044, height: deviceWidth * 0.044)
                                .background(ColorReferenceC.sandColor)
                                .foregroundColor(.white)
                        }
                        .padding()
                        
                        Button {
                            alertType = .deleteGrid
                            showAlert = true
                            
                        } label: {
                            Image("cancel-cross")
                                .resizable()
                                .font(.system(size: 20, weight: .heavy))
                                .frame(width: deviceWidth * 0.044, height: deviceWidth * 0.044)
                                .background(ColorReferenceC.sandColor)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    Spacer()
                    Keyboard(selectedLetter: $selectedLetter, selectedRow: $selectedRow, selectedColumn: $selectedColumn,isHorizontal: $isHorizontal, countingTappedLetters: $countingTappedLetters, grid: $grid, motsCroisesSelected: motsCroisesSelected, cursorMovement: cursorMovement, reverseCursorMovement: reverseCursorMovement, arrowTyped: $arrowTyped)
                        .onChange(of: countingTappedLetters, perform: { _ in
                            resetColorConditions()
                            let noDeLettre = "\(selectedRow),\(selectedColumn)"
                            CoreDataHandler.fetchItemSaveLetter(noDeLettre: noDeLettre, newLetter: selectedLetter, grilleSelected: motsCroisesSelected)
                            cursorMovement()
                            highlightDefinition()
                            checkGridFinished()
                        })
                        .padding()
                    Spacer()
                    VStack {
                        Menu {
                            Button("Lettre", action: validerLettre)
                            Button("Mot", action: validerMot)
                            Button("Grille", action: validerGrille)
                            
                        } label: {
                            Image("check-symbolArranged")
                                .resizable()
                                .font(.system(size: 20, weight: .heavy))
                                .frame(width: deviceWidth * 0.044, height: deviceWidth * 0.044)
                                .background(ColorReferenceC.sandColor)
                                .foregroundColor(.white)
                        }
                        .padding()
                        Menu {
                            Button("Lettre", action: revelerLettre)
                            Button("Mot", action: revelerMot)
                            Button("Grille", action: revelerGrille)
                            
                        } label: {
                            Image("magnifying-glass-iconArranged")
                                .resizable()
                                .font(.system(size: 20, weight: .heavy))
                                .frame(width: deviceWidth * 0.044, height: deviceWidth * 0.044)
                                .background(ColorReferenceC.sandColor)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .noError:
                return Alert(title: Text("Il n'y a pas d'erreur"), message: Text(""))
            case .finished:
                timer.upstream.connect().cancel()
                return Alert(title: Text("Félicitations!"), message: texteAlerteTerminé())
            case .deleteGrid:
                return Alert(
                            title: Text("Mots Croisés Classiques"),
                            message: Text("Êtes-vous sûr de vouloir tout effacer?"),
                            primaryButton: .destructive(Text("Oui"), action: {
                                for n in 0...dimension {
                                    for m in 0...dimension{
                                        if CoreDataHandler.fetchLetters(noDeLettre: "\(n),\(m)", grilleSelected: motsCroisesSelected) != "#" {
                                            grid[n][m] = ""
                                            CoreDataHandler.fetchItemSaveLetter(noDeLettre: "\(n),\(m)", newLetter: "", grilleSelected: motsCroisesSelected)
                                        }

                                    }
                                }
                                UserDefaults.standard.set(0, forKey: motsCroisesSelected)
                                CoreDataHandler.saveUncompleteStatus(grilleSelected: motsCroisesSelected)
                                secondsElapsed = 0
                                let indiceMotsCroisesSelected = motsCroisesSelected + "indice"
                                UserDefaults.standard.set(false, forKey: indiceMotsCroisesSelected)
                                removeAlertWindow = false
                            }),
                            secondaryButton: .default(Text("Non"), action: {
                                removeAlertWindow = false
                            })
                        )
            }
        }
        .navigationBarItems(trailing:
                                HStack{
            Text("Temps: ")
            Text(String(format: "%02d:%02d", minutes, seconds))
                .onReceive(timer) { _ in
                    let isMotsCroisesFinished = CoreDataHandler.isMotsCroisesFinished(noDeLettre: "0,0", grilleSelected: motsCroisesSelected)
                    if !isMotsCroisesFinished{
                        secondsElapsed += 1
                    }
                }
                .onDisappear {
                    UserDefaults.standard.set(secondsElapsed, forKey: motsCroisesSelected)
                    timer.upstream.connect().cancel()
                }
        }
            .foregroundColor(.black)
        )
        .onAppear{
            orientationSubscription = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
                .sink(receiveValue: { _ in
                    if UIDevice.current.orientation.isPortrait {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            squareWidth = 0.033 * deviceWidth
            fileNewGrid()
            let savedTime = UserDefaults.standard.integer(forKey: motsCroisesSelected)
            secondsElapsed = savedTime
            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            highlightDefinition()
        }
        .colorScheme(.light)
    }
    //MARK: ALL FUNCTIONS
    func fileNewGrid() {
        grid = [[String]]()
        print("dimension: \(dimension)")
        grid = Array(repeating: Array(repeating: "", count: dimension + 1), count: dimension + 1)
        arrayOfDefAndPosition = [(String, Int, String)](repeating: ("", 0, ""), count: dimension)
        arrayOfDefAndPositionV = [(String, Int, String)](repeating: ("", 0, ""), count: dimension)
        let pListLettres = "Lettres" + motsCroisesSelected
        let pListDefinitions = "Definitions" + motsCroisesSelected
        if let plistPath = Bundle.main.path(forResource: pListLettres, ofType: "plist"),
           let motCr = NSArray(contentsOfFile: plistPath){
            grille = motCr as! [[String]]
        }
        print("grille: \(grille)")
        if let plistPath = Bundle.main.path(forResource: pListDefinitions, ofType: "plist"),
           let def = NSArray(contentsOfFile: plistPath){
            definitions = def as! [[[String]]]
        }
        print("definitions: \(definitions)")
        var item = CoreDataHandler.fetchGrille(grilleSelected: motsCroisesSelected)
        if item == [] {
            GrilleData.prepareGrille(dimension: dimension, item:item!, grilleSelected: motsCroisesSelected, grille: grille)
            item = CoreDataHandler.fetchGrille(grilleSelected: motsCroisesSelected)
        }
        arrayOfDefAndPosition = [(String, Int, String)]()
        var i = 0
        _ = definitions.map { horizontal in
            horizontal.map { def in
                if !arrayOfDefinitionsH.contains(def[0]){
                    var numberOfDef = String()
                    if def[0] != "" {
                        numberOfDef = String(Range.horizontal(i: i, dimension: dimension))
                        arrayOfDefinitionsH.append(def[0])
                        arrayOfDefAndPosition.append((def[0],i, numberOfDef))
                    }
                }
                i = i + 1
            }
        }
        arrayOfDefAndPositionV = [(String, Int, String)]()
        i = 0
        _ = definitions.map { vertical in
           _ = vertical.map { def in
                if !arrayOfDefinitionsV.contains(def[1]){
                    var numberOfDef = String()
                    if def[1] != "" {
                        numberOfDef = String(Range.vertical(i: i, dimension: dimension))
                        arrayOfDefinitionsV.append(def[1])
                        arrayOfDefAndPositionV.append((def[1],i, numberOfDef))
                    }
                }
                i = i + 1
            }
            arrayOfDefAndPositionV = Order.vertical(defs: arrayOfDefAndPositionV)
        }
        var m = 0
        var n = 0
        for line in grid{
            n = 0
            for _ in line {
                grid[m][n] = CoreDataHandler.fetchLetters(noDeLettre: "\(m),\(n)", grilleSelected: motsCroisesSelected)
                n += 1
            }
            m += 1
        }
    }
    func getBackgroundColor(row: Int, column: Int) -> (Color, [Int]) {
        if grid[row][column] == "#" {
            return (Color.black, [])
        } else if self.selectedRow == row && self.selectedColumn == column {
            let groupOfSelectedCells = groupingArray(array: grid[row])
            _ = (arrayForElement(arrayOfArrays: groupOfSelectedCells, element: column)!)
            return (ColorReferenceC.coralColorVDardk, [])
        } else if isHorizontal {
            let groupOfSelectedCells = groupingArray(array: grid[self.selectedRow])
            var selectedCells = [Int]()
            if let cells = arrayForElement(arrayOfArrays: groupOfSelectedCells, element: self.selectedColumn) {
                selectedCells = cells
            }
            let backgroundColor = selectedCells.contains(column) && self.selectedRow == row ? ColorReferenceC.coralColorDark : ColorReferenceC.sandColor
            return (backgroundColor, selectedCells)
        } else {
            let selectedSquare = getSelectedColumn(grid: grid, selectedColumn: selectedColumn)
            let groupedArray = groupingArray(array: selectedSquare)
            var selectedCells = [Int]()
            if let cells = arrayForElement(arrayOfArrays: groupedArray, element: selectedRow) {
                selectedCells = cells
            }
            let backgroundColor = selectedCells.contains(row) && self.selectedColumn == column ? ColorReferenceC.coralColorDark : ColorReferenceC.sandColor
            return (backgroundColor, selectedCells)
        }
    }
    func groupingArray(array: [String]) -> [[Int]] {
        var result: [[Int]] = []
        var group: [Int] = []
        for (index, element) in array.enumerated() {
            if element == "#" {
                if !group.isEmpty {
                    result.append(group)
                    group = []
                }
            } else {
                group.append(index)
            }
        }
        if !group.isEmpty {
            result.append(group)
        }
        return result
    }
    
    func arrayForElement(arrayOfArrays: [[Int]], element: Int) -> [Int]? {
        for subArray in arrayOfArrays {
            if subArray.contains(element) {
                return subArray
            }
        }
        return nil
    }
    func getSelectedColumn(grid: [[String]], selectedColumn: Int) -> [String] {
        return grid.map { $0[selectedColumn] }
    }
    func cursorMovement() {
        if !arrowTyped{
            grid[selectedRow][selectedColumn] = selectedLetter
            arrowTyped = true
        }
        if selectedColumn == dimension && selectedRow == dimension && selectedLetter != "#"{
            selectedColumn = 0
            selectedRow = 0
        }else if isHorizontal && selectedLetter != "#" {
            if selectedColumn == dimension {
                selectedColumn = 0
                selectedRow += 1
            }else{
                selectedColumn += 1
            }
        }else if !isHorizontal && selectedLetter != "#"{
            if selectedRow == dimension {
                selectedRow = 0
                selectedColumn += 1
            }else{
                selectedRow += 1
            }
        }
        var counter = 0
        if isHorizontal{
            while selectedColumn <= dimension && (grid[selectedRow][selectedColumn] != " " && grid[selectedRow][selectedColumn] != ""){
                counter += 1
                if counter == (dimension + 1) * (dimension + 1) {
                    break
                }
                if selectedColumn < dimension{
                    selectedColumn += 1
                }else{
                    if selectedRow < dimension{
                        selectedColumn = 0
                        selectedRow += 1
                    }else{
                        selectedRow = 0
                        selectedColumn = 0
                    }

                }
            }
        }else{
            while selectedRow <= dimension && (grid[selectedRow][selectedColumn] != " " && grid[selectedRow][selectedColumn] != ""){
                counter += 1
                if counter == (dimension + 1) * (dimension + 1) {
                    break
                }
                if selectedRow < dimension {
                    selectedRow += 1
                }else{
                    if selectedColumn < dimension{
                        selectedRow = 0
                        selectedColumn += 1
                    }else{
                        selectedRow = 0
                        selectedColumn = 0
                    }
                }
                
            }
        }
        grid[selectedRow][selectedColumn] = CoreDataHandler.fetchLetters(noDeLettre: "\(selectedRow),\(selectedColumn)", grilleSelected: motsCroisesSelected)
        highlightDefinition()
    }
    func reverseCursorMovement() {
        if !arrowTyped{
            grid[selectedRow][selectedColumn] = selectedLetter
            arrowTyped = true
        }
        if selectedColumn == 0 && selectedRow == 0  && selectedLetter != "#"{
            selectedColumn = dimension
            selectedRow = dimension
        }else if isHorizontal && selectedLetter != "#"{
            if selectedColumn == 0 {
                selectedColumn = dimension
                selectedRow -= 1
            }else{
                selectedColumn -= 1
            }
        }else if !isHorizontal && selectedLetter != "#"{
            if selectedRow == 0 {
                selectedRow = dimension
                selectedColumn -= 1
            }else{
                selectedRow -= 1
            }
        }
        if isHorizontal{
            while selectedColumn > 0 && grid[selectedRow][selectedColumn] == "#"{
                selectedColumn -= 1
            }
        }else{
            while selectedRow > 0 && grid[selectedRow][selectedColumn] == "#"{
                selectedRow -= 1
            }
        }
        if grid[selectedRow][selectedColumn] == "#"  && selectedRow != 0 && selectedColumn != 0{
            if isHorizontal{
                selectedColumn -= 1
            }else{
                selectedRow -= 1
            }
        }else if grid[selectedRow][selectedColumn] == "#" && selectedRow == 0 && selectedColumn == 0{
            selectedRow = dimension
            selectedColumn = dimension
        }else if isHorizontal &&  grid[selectedRow][selectedColumn] == "#" && selectedColumn == 0 {
            selectedColumn = dimension
            selectedRow -= 1
        }else if !isHorizontal &&  grid[selectedRow][selectedColumn] == "#" && selectedRow == 0 {
            selectedColumn -= 1
            selectedRow = dimension
        }
        grid[selectedRow][selectedColumn] = CoreDataHandler.fetchLetters(noDeLettre: "\(selectedRow),\(selectedColumn)", grilleSelected: motsCroisesSelected)
        highlightDefinition()
    }
    func highlightDefinition() {
        let defToHighlight = definitions[selectedRow][selectedColumn]
        var n = 0
        for tupple in arrayOfDefAndPosition {
            if tupple.0 == defToHighlight[0]{
                wordIsSelectedH[n] = true
            }else{
                wordIsSelectedH[n] = false
            }
            n += 1
        }
        n = 0
        for tupple in arrayOfDefAndPositionV{
            if tupple.0 == defToHighlight[1]{
                wordIsSelectedV[n] = true
            }else{
                wordIsSelectedV[n] = false
            }
            n += 1
        }
    }
    func validerLettre() {
        helpUsed()
        valideLettrePressed = true
        let lettreToCheck = grille[selectedRow][selectedColumn]
        let letterTyped = CoreDataHandler.fetchLetters(noDeLettre: "\(selectedRow),\(selectedColumn)", grilleSelected: motsCroisesSelected)
        if lettreToCheck == letterTyped {
            letterIsGood[selectedRow][selectedColumn] = true
            alertType = .noError
            showAlert = true
        }else{
            letterIsGood[selectedRow][selectedColumn] = false
        }
    }
    func validerMot(){
        helpUsed()
        validerMotPressed = true
        var finalVerticalCellSelected = [String]()
        let groupOfSelectedCells = groupingArray(array: grid[self.selectedRow])
        var selectedCells = [Int]()
        let lettersForRow =  grid[selectedRow]
        var arrayOfLetters = [String]()
        if isHorizontal {
            if let cells = arrayForElement(arrayOfArrays: groupOfSelectedCells, element: self.selectedColumn){
                selectedCells = cells
                for cell in selectedCells {
                    arrayOfLetters.append(lettersForRow[cell])
                }
            }else{
                
            }
        }else{
            arrayOfLetters = getSelectedColumn(grid: grid, selectedColumn: selectedColumn)
            for cell in verticalSelectedCell {
                finalVerticalCellSelected.append(arrayOfLetters[cell])
            }
        }
        let grilleWordH = definitions[selectedRow][selectedColumn][2].trimmingCharacters(in: .whitespacesAndNewlines)
        let grilleWordV = definitions[selectedRow][selectedColumn][3].trimmingCharacters(in: .whitespacesAndNewlines)
        let arrayOfWordLettersH = grilleWordH.map({ String($0) })
        let arrayOfWordLettersV = grilleWordV.map({ String($0) })
        if isHorizontal {
            if arrayOfWordLettersH == arrayOfLetters {
                alertType = .noError
                showAlert = true
                for column in selectedCells {
                    letterIsGood[selectedRow][column] = true
                }
            }else{
                var index = 0
                for column in selectedCells {
                    if arrayOfWordLettersH[index] == arrayOfLetters [index]{
                        letterIsGood[selectedRow][column] = true
                    }else{
                        letterIsGood[selectedRow][column] = false
                    }
                    index += 1
                }
            }
        }else{
            
            if arrayOfWordLettersV == finalVerticalCellSelected {
                alertType = .noError
                showAlert = true
                for row in verticalSelectedCell {
                    letterIsGood[row][selectedColumn] = true
                }
            }else{
                var index = 0
                for row in verticalSelectedCell {
                    if arrayOfWordLettersV[index] == finalVerticalCellSelected[index]{
                        letterIsGood[row][selectedColumn] = true
                    }else{
                        letterIsGood[row][selectedColumn] = false
                    }
                    index += 1
                }
            }
        }
    }
    func validerGrille(){
        helpUsed()
        validerGrillePressed = true
        for m in 0...dimension {
            for n in 0...dimension{
                if grid[m][n] != grille[m][n] {
                    letterIsGood[m][n] = false
                }
            }
        }
    }
    
    func revelerLettre(){
        helpUsed()
        showLetter = true
        let lettreToCheck = grille[selectedRow][selectedColumn]
        let letterTyped = CoreDataHandler.fetchLetters(noDeLettre: "\(selectedRow),\(selectedColumn)", grilleSelected: motsCroisesSelected)
        if lettreToCheck == letterTyped {
            letterIsGood[selectedRow][selectedColumn] = true
        }else{
            grid[selectedRow][selectedColumn] = lettreToCheck
            CoreDataHandler.fetchItemSaveLetter(noDeLettre: "\(selectedRow),\(selectedColumn)", newLetter: lettreToCheck, grilleSelected: motsCroisesSelected)
        }
        checkGridFinished()
        
    }
    func revelerMot(){
        helpUsed()
        showMot = true
        var finalVerticalCellSelected = [String]()
        let groupOfSelectedCells = groupingArray(array: grid[self.selectedRow])
        var selectedCells = [Int]()
        let lettersForRow =  grid[selectedRow]
        var arrayOfLetters = [String]()
        if isHorizontal {
            if let cells = arrayForElement(arrayOfArrays: groupOfSelectedCells, element: self.selectedColumn){
                selectedCells = cells
                for cell in selectedCells {
                    arrayOfLetters.append(lettersForRow[cell])
                }
            }else{
                
            }
        }else{
            arrayOfLetters = getSelectedColumn(grid: grid, selectedColumn: selectedColumn)
            for cell in verticalSelectedCell {
                finalVerticalCellSelected.append(arrayOfLetters[cell])
            }
        }
        let grilleWordH = definitions[selectedRow][selectedColumn][2].trimmingCharacters(in: .whitespacesAndNewlines)
        let grilleWordV = definitions[selectedRow][selectedColumn][3].trimmingCharacters(in: .whitespacesAndNewlines)
        let arrayOfWordLettersH = grilleWordH.map({ String($0) })
        let arrayOfWordLettersV = grilleWordV.map({ String($0) })
        if isHorizontal {
            if arrayOfWordLettersH == arrayOfLetters {
                for column in selectedCells {
                    letterIsGood[selectedRow][column] = true
                }
            }else{
                var n = 0
                for column in selectedCells {
                    grid[selectedRow][column] = arrayOfWordLettersH[n]
                    CoreDataHandler.fetchItemSaveLetter(noDeLettre: "\(selectedRow),\(column)", newLetter: arrayOfWordLettersH[n], grilleSelected: motsCroisesSelected)
                    n += 1
                }
            }
        }else{
            if arrayOfWordLettersV == finalVerticalCellSelected {
                for row in verticalSelectedCell {
                    letterIsGood[row][selectedColumn] = true
                }
            }else{
                var n  = 0
                for row in verticalSelectedCell {
                    grid[row][selectedColumn] = arrayOfWordLettersV[n]
                    CoreDataHandler.fetchItemSaveLetter(noDeLettre: "\(row),\(selectedColumn)", newLetter: arrayOfWordLettersV[n], grilleSelected: motsCroisesSelected)
                    n += 1
                }
            }
        }
        checkGridFinished()
    }
    func revelerGrille(){
        helpUsed()
        grid = grille
        for m in 0...dimension {
            for n in 0...dimension{
                CoreDataHandler.fetchItemSaveLetter(noDeLettre: "\(m),\(n)", newLetter: grid[m][n], grilleSelected: motsCroisesSelected)
            }
        }
        checkGridFinished()
    }
    func returnCollorOfLetter(row: Int, column:Int) -> (Color, Font.Weight){
        if letterIsGood[row][column]{
            return (.black, .regular)
        }else if !letterIsGood[row][column] && (showLetter || showMot || validerMotPressed || valideLettrePressed || validerGrillePressed){
            return (.red, .heavy)
            
        }else{
            return (.black, .regular)
        }
    }
    func resetColorConditions() {
        showLetter = false
        showMot = false
        validerMotPressed = false
        valideLettrePressed = false
    }
    func findPositionInDefList(row: Int, column: Int) {
        let definH = definitions[row][column][0]
        let definV = definitions[row][column][1]
        var n = 0
        for def in arrayOfDefAndPosition {
            if definH == def.0 {
                selectedItemH = n
            }
            n += 1
        }
        n = 0
        for def in arrayOfDefAndPositionV {
            if definV == def.0 {
                selectedItemV = n
            }
            n += 1
        }
    }
    func checkGridFinished() {
        if grille == grid {
            alertType = .finished
            showAlert = true
            CoreDataHandler.saveCompletedStatus(grilleSelected: motsCroisesSelected)
        }
    }
    func helpUsed() {
        let indiceMotsCroisesSelected = motsCroisesSelected + "indice"
        UserDefaults.standard.set(true, forKey: indiceMotsCroisesSelected)
    }
    func texteAlerteTerminé() -> Text {
        let indiceMotsCroisesSelected = motsCroisesSelected + "indice"
        let minutes = secondsElapsed / 60
        let seconds = secondsElapsed % 60
        if UserDefaults.standard.bool(forKey: indiceMotsCroisesSelected){
            return Text("Vous avez complété la grille!\nÀ l'aide d'indices")
        }else{
            return Text("Vous avez complété la grille!\n Temps: \(String(format: "%02d:%02d", minutes, seconds))")
        }
    }

    
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(motsCroisesSelected: "14E")
//    }
//}

