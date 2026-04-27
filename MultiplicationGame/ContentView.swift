//
//  ContentView.swift
//  MultiplicationGame
//
//  Created by Myron Snelson on 4/17/26.
//

import SwiftUI

// Test commit and push

struct Question: Identifiable {
    let id = UUID()
    let qProblem: String
    let qAnswer: Int
}

struct ContentView: View {
    
    @State private var multiplicand = 2
    @State private var multiplier = 2
    @State private var nbrQuestions = 5
    @State private var product = ""
    @State private var hasStarted = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var questions: [Question] = []
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var gameOver = false
    
    private var currentQuestionText: String {
        guard hasStarted, !gameOver, currentIndex >= 0, currentIndex < questions.count else { return "" }
        return questions[currentIndex].qProblem
    }
    
    private var progressText: String {
        guard hasStarted, questions.count > 0 else { return "" }
        let current = min(currentIndex + 1, questions.count)
        return "Question \(current) of \(questions.count)"
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Choose Multiplicand upper limit:")
                            .font(.headline)
                        Stepper(value: $multiplicand, in: 2...12, step: 1) {
                            Text("\(multiplicand)")
                                .font(.title3)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .disabled(hasStarted)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Choose Multiplier upper limit :")
                            .font(.headline)
                        Stepper(value: $multiplier, in: 2...12, step: 1) {
                            Text("\(multiplier)")
                                .font(.title3)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .disabled(hasStarted)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Choose Number of Questions:")
                            .font(.headline)
                        Stepper(value: $nbrQuestions, in: 5...20, step: 5) {
                            Text("\(nbrQuestions)")
                                .font(.title3)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .disabled(hasStarted)
                    }
                }
                .foregroundStyle(!hasStarted ? Color.black.opacity(1) : Color.gray.opacity(0.7))
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Button("Start Game") {
                                startGame()
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                            .tint(.green)
                            .disabled(hasStarted)
                            
                            Spacer()
                            
                            Button("Submit Answer") {
                                checkAnswer()
                                isTextFieldFocused = false
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                            .tint(.red)
                            .disabled(!hasStarted || gameOver)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Solve this multiplication problem:")
                        .font(.headline)
                    Text(currentQuestionText)
                        .font(.largeTitle)
                }
                
                .padding(.vertical, 8)
                TextField("Enter product, then tap Submit", text: $product)
                    .focused($isTextFieldFocused)
                    .disabled(!hasStarted || gameOver)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(hasStarted ? Color.accentColor : Color.gray.opacity(0.4), lineWidth: hasStarted ? 2 : 1)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(hasStarted ? Color.accentColor.opacity(0.08) : Color.gray.opacity(0.06))
                            )
                    )
                    .font(.title3)
                    .animation(.easeInOut(duration: 0.2), value: hasStarted)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(progressText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Score: \(score)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
 
                
                if gameOver {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("All done! You scored \(score) out of \(questions.count).")
                            .font(.headline)
                            .foregroundStyle(.red)
                        Text("To play again, press the Start button.")
                            .font(.headline)
                            .foregroundStyle(.green)
                   }
                    .padding(.vertical, 8)
            }
        }
            .navigationTitle("Multiplication Game")
        }
    }
    
    func startGame() {
        hasStarted = true
        isTextFieldFocused = true
        restartGame()
    }
    
    func restartGame() {
        gameOver = false
        score = 0
        currentIndex = 0
        product = ""

        questions.removeAll(keepingCapacity: true)

        for _ in 0..<nbrQuestions {
            let mcand = Int.random(in: 2...multiplicand)
            let mplier = Int.random(in: 2...multiplier)
            let mproblem = "\(mcand) x \(mplier)"
            let question = Question(qProblem: mproblem, qAnswer: mcand * mplier)
            questions.append(question)
        }
    }
    
    func checkAnswer() {
        guard hasStarted, !gameOver, currentIndex < questions.count else { return }

        let trimmed = product.trimmingCharacters(in: .whitespacesAndNewlines)
        if let typed = Int(trimmed) {
            let correct = questions[currentIndex].qAnswer
            if typed == correct {
                score += 1
            }
        }

        // Advance to next question
        currentIndex += 1
        product = ""

        if currentIndex >= questions.count {
            // End the game
            gameOver = true
            hasStarted = false
            isTextFieldFocused = false
        } else {
            // Keep focus for quick entry
            isTextFieldFocused = true
        }
    }
}
#Preview {
    ContentView()
}

