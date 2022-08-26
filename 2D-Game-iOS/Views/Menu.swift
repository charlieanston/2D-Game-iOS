//
//  Menu.swift
//  2D-Game-iOS
//
//  Created by Hung Le Tran Trong on 26/08/2022.
//

import SwiftUI

struct Menu: View {
    var flag: Int = 0
    var body: some View {
        ZStack{
            VStack(spacing: 20){
                
                Spacer()


                Button(action: {
                    flag = 1
                }, label: {
                    Capsule()
                      .fill(Color.white.opacity(0.2))
                      .padding(8)
                      .frame(height:80)
                      .overlay(Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white))
                })
            }
        }
        .background(
            LinearGradient(
                colors: [
                    ColorConstants.froly,
                    ColorConstants.ceriseRed
                ],
                startPoint: .top,
                endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}
