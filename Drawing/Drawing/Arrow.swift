//
//  Arrow.swift
//  Drawing
//
//  Created by Arin Asawa on 11/15/20.
//

import SwiftUI


struct ArrowShape:InsettableShape{
    var insetAmount:CGFloat = 0.0
    var animatableData: CGFloat{
        get{insetAmount}
        set{self.insetAmount = newValue}
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX - 20, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + 20, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + 20, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX + 60, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX - 60, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - 20, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - 20, y: rect.maxY))
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arrowShape = self
        arrowShape.insetAmount += amount
        return arrowShape
    }
}


struct Arrow: View {
    @State private var insetAmount:CGFloat = 5
    var body: some View {
        ArrowShape()
            .strokeBorder(Color.blue,style: StrokeStyle(lineWidth: CGFloat(insetAmount), lineCap: .round, lineJoin: .round))
            .frame(width: 300, height: 300)
            .onTapGesture {
                withAnimation{
                self.insetAmount = insetAmount == 5 ? 15 : 5
                }
            }
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrow()
    }
}
