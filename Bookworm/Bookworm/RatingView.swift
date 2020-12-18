//
//  RatingView.swift
//  Bookworm
//
//  Created by Arin Asawa on 11/21/20.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating:Int
    var label = ""
    var maximumRating = 5
    var offImage = Image(systemName: "star")
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    var body: some View {
            HStack(spacing:10){
                    ForEach(0..<maximumRating){i in
                        if i<rating{
                            onImage
                                .foregroundColor(onColor)
                                .font(.title)
                                .onTapGesture {
                                    rating = i + 1
                                }
                        }else{
                            offImage
                                .foregroundColor(offColor)
                                .font(.title)
                                .onTapGesture {
                                    rating = i + 1
                                }
                        }
                    }
            }
        
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(1) )
    }
}
