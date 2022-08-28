//
//  Game.swift
//  2D-Game-iOS
//
//  Created by Hung Le on 28/08/2022.
//

import SwiftUI

struct Game: View {
    // MARK: - PROPERTIES
    let icons = ["andesaurus","baryonyx","brachiosaurus","brontosaurus","carnotaurus","coelophysis", "diplodocus", "gallimimus", "lirainosaurus","raptor","stegosaurus","styracosaurus","triceratops"]
    
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var highscore = UserDefaults.standard.integer(forKey: "highscore")
    @State private var coins = 100
    @State private var betAmount = 10
    @State private var reels = [0, 1, 2, 3, 4, 5]
    
    @State private var isChooseBet10 = true
    @State private var isChooseBet50 = false
    
    @State private var showingInfoView = false
    @State private var showGameOverModal = false
    
    @State private var animatingIcon = false

    
    // MARK: - FUNCTIONS (GAME LOGICS)
    
    // MARK: - SPIN LOGIC
    func spinReels(){
        // reels[0] = Int.random(in: 0...symbols.count - 1)
        reels = reels.map({ _ in
            Int.random(in: 0...icons.count - 1)
        })
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    // MARK: - CHECK WINNING LOGIC
    func checkWinning(){
        var count: Int = 0
        let numbers = 1...5
        for i in numbers {
            if reels[0] == reels[i] {
                count += 1
            }
        }
        switch count{
        case 1:
            playerWins1()
        case 2:
            playerWins2()
        case 3:
            playerWins3()
        case 4:
            playerWins4()
        case 5:
            jackPot()
        default:
            playLoses()
        }
        
        if coins > highscore{
            newHighScore()
        }
//        if reels[0]==reels[1] || reels[1]==reels[2] || reels[2]==reels[0]{
//            // PLAYER WINS LOGIC
//            playerWins()
//
//            // NEW HIGHSCORE LOGIC
//            if coins > highscore{
//                newHighScore()
//            } else {
//                playSound(sound: "winning", type: "mp3")
//            }
//
//        } else {
//            // PLAYER LOSES
//            playLoses()
//        }
    }
    
    // MARK: - PLAYER WIN LOGIC
    func playerWins1() {
        coins += betAmount * 3
        playSound(sound: "winning", type: "mp3")
    }
    func playerWins2() {
        coins += betAmount * 6
        playSound(sound: "winning", type: "mp3")
    }
    func playerWins3() {
        coins += betAmount * 10
        playSound(sound: "winning", type: "mp3")
    }
    func playerWins4() {
        coins += betAmount * 16
        playSound(sound: "winning", type: "mp3")
    }
    func jackPot() {
        coins += betAmount * 50
        playSound(sound: "winning", type: "mp3")
    }
    
    // MARK: - HIGHSCORE LOGIC
    func newHighScore(){
        highscore = coins
        UserDefaults.standard.set(highscore, forKey: "highscore")
        playSound(sound: "highscore", type: "mp3")
    }
    
    // MARK: - PLAYER LOSE LOGIC
    func playLoses() {
        coins -= betAmount
    }
    
    // MARK: - BET 10 LOGIC
    func chooseBet10() {
        betAmount = 10
        isChooseBet10 = true
        isChooseBet50 = false
        playSound(sound: "bet-chip", type: "mp3")
    }
    
    // MARK: - BET 50 LOGIC
    func chooseBet50() {
        betAmount = 50
        isChooseBet10 = false
        isChooseBet50 = true
        playSound(sound: "bet-chip", type: "mp3")
    }
    
    // MARK: - GAME OVER LOGIC
    func isGameOver() {
        if coins <= 0 {
            // SHOW MODAL MESSAGE OF GAME OVER
            showGameOverModal = true
            playSound(sound: "gameover", type: "mp3")
        }
    }
    
    // MARK: - RESET GAME LOGIC
    func resetGame(){
        UserDefaults.standard.set(0, forKey: "highscore")
        highscore = 0
        coins = 100
        chooseBet10()
        playSound(sound: "ring-up", type: "mp3")
    }
    
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            // MARK: - BACKGROUND
            LinearGradient(
                colors: [
                    ColorConstants.froly,
                    ColorConstants.ceriseRed
                ],
                startPoint: .top,
                endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            
            // MARK: - GAME UI
            VStack {
                // MARK: - LOGO HEADER
                LogoView(logoFileName: "slot-machine")
                Spacer()
                
                // MARK: - SCORE
                HStack{
                    HStack{
                        Text("Your\nMoney".uppercased())
                            .modifier(scoreLabelStyle())
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .modifier(scoreNumberStyle())
                    }
                    .modifier(scoreCapsuleStyle()
                    
                    )
                    Spacer()
                    HStack{
                        Text("\(highscore)")
                            .modifier(scoreNumberStyle())
                            .multilineTextAlignment(.leading)
                        Text("High\nScore".uppercased())
                            .modifier(scoreLabelStyle())
                        
                    }
                    .modifier(scoreCapsuleStyle()
                    )
                }
                
                // MARK: - SLOT MACHINE
                VStack{
                    HStack{
                        // MARK: - FIRST REEL
                        ZStack{
                            ReelView()
                            Image(icons[reels[0]])
                                .resizable()
                                .modifier(IconImageModifier())
                                .opacity(animatingIcon ? 1 : 0)
                                .offset(y: animatingIcon ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.5...0.7)), value: animatingIcon)
                                .onAppear(perform: {
                                    self.animatingIcon.toggle()
                                    playSound(sound: "blink", type: "mp3")
                                })
                    
                        }
                                                
                        // MARK: - SECOND REEL
                        ZStack{
                            ReelView()
                            Image(icons[reels[1]])
                                .resizable()
                                .modifier(IconImageModifier())
                                .opacity(animatingIcon ? 1 : 0)
                                .offset(y: animatingIcon ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)), value: animatingIcon)
                                .onAppear(perform: {
                                    self.animatingIcon.toggle()
                                    playSound(sound: "blink", type: "mp3")
                                })
                        }
                    }
                    
                    HStack{
                        // MARK: - THIRD REEL
                        ZStack{
                            ReelView()
                            Image(icons[reels[2]])
                                .resizable()
                                .modifier(IconImageModifier())
                                .opacity(animatingIcon ? 1 : 0)
                                .offset(y: animatingIcon ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animatingIcon)
                                .onAppear(perform: {
                                    self.animatingIcon.toggle()
                                    playSound(sound: "blink", type: "mp3")
                                })
                        }
                        
                        // MARK: - FOURTH REEL
                        ZStack{
                            ReelView()
                            Image(icons[reels[3]])
                                .resizable()
                                .modifier(IconImageModifier())
                                .opacity(animatingIcon ? 1 : 0)
                                .offset(y: animatingIcon ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animatingIcon)
                                .onAppear(perform: {
                                    self.animatingIcon.toggle()
                                    playSound(sound: "blink", type: "mp3")
                                })
                        }
                    }
                    
                    HStack{
                        // MARK: - FIFTH REEL
                        ZStack{
                            ReelView()
                            Image(icons[reels[4]])
                                .resizable()
                                .modifier(IconImageModifier())
                                .opacity(animatingIcon ? 1 : 0)
                                .offset(y: animatingIcon ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animatingIcon)
                                .onAppear(perform: {
                                    self.animatingIcon.toggle()
                                    playSound(sound: "blink", type: "mp3")
                                })
                        }
                                                
                        // MARK: - SIXTH REEL
                        ZStack{
                            ReelView()
                            Image(icons[reels[5]])
                                .resizable()
                                .modifier(IconImageModifier())
                                .opacity(animatingIcon ? 1 : 0)
                                .offset(y: animatingIcon ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animatingIcon)
                                .onAppear(perform: {
                                    self.animatingIcon.toggle()
                                    playSound(sound: "blink", type: "mp3")
                                })
                        }
                    }
                    
                    // MARK: - SPIN BUTTON
                    Button {
                        // NO ANIMATION
                        withAnimation{
                            self.animatingIcon = false
                        }
                        
                        // SPIN THE REELS
                        self.spinReels()
                        
                        // TRIGGER ANIMATION
                        withAnimation{
                            self.animatingIcon = true
                        }
                        
                        // CHECK WINNING
                        self.checkWinning()
                        
                        // GAME OVER
                        self.isGameOver()
                    } label: {
                        Image("spin")
                            .resizable()
                            .modifier(ReelImageModifier())
                    }
                    
                }
                
                
                // MARK: - FOOTER
                
                Spacer()
                
                HStack{
                    
                    HStack{
                        // MARK: - BET 50 BUTTON
                        Button {
                            self.chooseBet50()
                        } label: {
                            HStack(spacing: 30){
                                Text("50")
                                    .foregroundColor(isChooseBet50 ? ColorConstants.ceriseRed : Color.white)
                                    .modifier(BetCapsuleModifier())
                               Image("money-bag")
                                    .resizable()
                                    .offset(x: isChooseBet50 ? 0 : 20)
                                    .opacity(isChooseBet50 ? 1 : 0 )
                                    .modifier(CasinoChipModifier())
                                    .animation(.default, value: isChooseBet50)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer()
                        
                        // MARK: - BET 10 BUTTON
                        Button {
                            self.chooseBet10()
                        } label: {
                            HStack(spacing: 30){
                                Image("money-bag")
                                     .resizable()
                                     .offset(x: isChooseBet10 ? 0 : -20)
                                     .opacity(isChooseBet10 ? 1 : 0 )
                                     .modifier(CasinoChipModifier())
                                     .animation(.default, value: isChooseBet50)
                                Text("10")
                                    .foregroundColor(isChooseBet10 ? ColorConstants.ceriseRed : Color.white)
                                    .modifier(BetCapsuleModifier())
                               
                            }
                            .padding(.horizontal, 20)
                        }
                        
                    }
                    
                }

            }
            .overlay(
                
                // MARK: - RESET GAME BUTTON
                
                Button(action: {
                    self.resetGame()
                }) {
                  Image(systemName: "arrow.2.circlepath.circle")
                    .foregroundColor(.white)
                }
                .modifier(ButtonModifier()),
                alignment: .topLeading
              )
              .overlay(
                
                // MARK: - INFO GAME BUTTON
                
                Button(action: {
                    self.showingInfoView = true
                }) {
                  Image(systemName: "info.circle")
                    .foregroundColor(.white)
                }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
              )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius:  showGameOverModal ? 5 : 0 , opaque: false)
            
            
            
            // MARK: - GAMEOVER MODAL
            if showGameOverModal{
                ZStack{
                    ColorConstants.morningGlory
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(minWidth: 280, idealWidth: 280, maxWidth: 320)
                            .background(ColorConstants.ceriseRed)
                        
                        Spacer()
                        
                        VStack {
                            Image("slot-machine")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 150)
                            Text("You lost all money!\nYou are not the god of gambler!\n Good luck next time!")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                            Button {
                                self.showGameOverModal = false
                                self.coins = 100
                            } label: {
                                Text("New Game".uppercased())
                            }
                            .padding(.vertical,10)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule()
                                    .strokeBorder(lineWidth: 2)
                                    .foregroundColor(ColorConstants.ceriseRed)
                            )

                        }
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 280, idealHeight: 300, maxHeight: 350, alignment: .center)
                    .background(ColorConstants.easternBlue)
                    .cornerRadius(20)
                }.onAppear(perform: {
                    playSound(sound: "drum-music", type: "mp3")
                  })
            }//ZStack
        }.sheet(isPresented: $showingInfoView) {
            InfoView()
          }
    }
}

// MARK: - PREVIEW
struct Game_Previews: PreviewProvider {
    static var previews: some View {
        Game()
    }
}

