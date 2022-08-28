//
//  InfoView.swift
//  2D-Game-iOS
//
//  Created by Kim Yoko on 28/08/2022.
//

import SwiftUI

struct InfoView: View {
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
      ZStack{
          ColorConstants.easternBlue
          VStack(alignment: .center, spacing: 10) {
            LogoView(logoFileName: "slot-machine")
            
            Spacer()
            
            Form {
              Section(header: Text("How To Play")) {
                  Text("Click spin to spin the reels.")
                  Text("Match the most icons to the first reel.")
                  Text("The winning amount will be based on number of matches.")
                  Text("You can reset the money and highscore by clicking on the button Reset.")
              }
                Section(header: Text("Application Information")) {
                    HStack {
                      Text("App Name")
                      Spacer()
                      Text("Matching Casino")
                    }
                    HStack {
                      Text("Course")
                      Spacer()
                      Text("COSC2659")
                    }
                    HStack {
                      Text("Year Published")
                      Spacer()
                      Text("2022")
                    }
                    HStack {
                      Text("Location")
                      Spacer()
                      Text("Saigon South Campus")
                    }
              }
            }
            .font(.system(.body, design: .rounded))
          }
          .padding(.top, 40)
          .overlay(
            Button(action: {
              audioPlayer?.stop()
              dismiss()
            }) {
              Image(systemName: "xmark.circle")
                .font(.title)
            }
            .foregroundColor(.white)
            .padding(.top, 30)
            .padding(.trailing, 20),
            alignment: .topTrailing
            )
            .onAppear(perform: {
              playSound(sound: "drum-music", type: "mp3")
            })
      }
    
  }
}


struct InfoView_Previews: PreviewProvider {
  static var previews: some View {
    InfoView()
  }
}
