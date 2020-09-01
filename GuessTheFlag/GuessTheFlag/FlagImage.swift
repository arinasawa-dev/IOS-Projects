//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Arin Asawa on 9/1/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import SwiftUI

struct FlagImage: View {
    var name:String
    var body: some View {
         Image(name)
             .renderingMode(.original)
           .clipShape(Capsule())
           .overlay(Capsule().stroke(Color.black,lineWidth: 1))
           .shadow(color: Color.black, radius: 2)
        
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage(name: "US")
    }
}
