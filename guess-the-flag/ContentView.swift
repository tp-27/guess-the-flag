//
//  ContentView.swift
//  guess-the-flag
//
//  Created by Thomas Phan on 2023-05-11.
//

import SwiftUI

// makes a view have a large blue font
struct BlueView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func largeBlueView() -> some View {
        modifier(BlueView())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingResults = false
    @State private var scoreTitle = ""
    @State private var finalTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userScore = 0
    @State private var numAsked = 0
    let maxQuestions = 3
    
    // creates a view of an image according to specified modifiers
    struct FlagImage: View {
        var number: Int
        var theCountries: [String]
        
        var body: some View {
            Image(theCountries[number])
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius:5)
        }
    }
        
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary) // vibrancy effect to let little of background color through
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(number: number, theCountries: countries)
                        }
                    }
                }
        
                // add transparent frame around flags
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                .alert(scoreTitle, isPresented: $showingScore) {
                    Button("Continue", action: askQuestion)
                } message: {
                    Text("Your score is \(userScore)")
                }
                
                .alert(finalTitle, isPresented: $showingResults) {
                    Button("Restart", action: resetGame)
                }
                
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
    }
    
    // checks the validity of the flag tapped
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong. You selected the flag of \(countries[number])."
            if (userScore > 0) {
                userScore -= 1
            }
        }
        
        numAsked += 1
        showingScore = true
        
        if numAsked == maxQuestions {
            finalTitle = "Game over. Total score: \(userScore)"
            showingResults = true
        }
    }
    
    // resets the round by shuffling array
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    // resets game
    func resetGame() {
        userScore = 0
        numAsked = 0
        askQuestion()
    }
}
  
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
