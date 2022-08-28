//
//  ReelView.swift
//  2D-Game-iOS
//
//  Created by Hung Le on 28/08/2022.
//

import SwiftUI

struct ReelView: View {
    var body: some View {
        Image("reel")
            .resizable()
            .modifier(ReelImageModifier())
    }
}

struct ReelView_Previews: PreviewProvider {
    static var previews: some View {
        ReelView()
            .previewLayout(.sizeThatFits)
    }
}
