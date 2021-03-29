//
//  OTPView.swift
//  Tarea07
//
//  Created by Cristian Zuniga on 28/3/21.
//

import SwiftUI

struct OTPView: View {
    
    @State var rnd = Int.random(in: 1..<999999)
    var randomNumber: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none

        let number = rnd
        return formatter.string(from: NSNumber(value: number)) ?? "000000"
    }
    
    
    @State var timeRemaining = 60
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
           
    var body: some View {
        VStack{
        Text("\(randomNumber)").bold().font(.title).padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
        Text("Copiar código").foregroundColor(Color.blue).padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
            Text("\(timeRemaining)").bold().font(.title).padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                       .onReceive(timer) { _ in
                           if timeRemaining > 0 {
                               timeRemaining -= 1
                           }else{
                            timeRemaining = 60
                            rnd = Int.random(in: 1..<999999)
                           }
                       }
        Text("Este código BAC Credomatic tiene una duración de 60 segundos").padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
        }
    }
                
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView()
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation (_ value: Int){
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        if let result = formatter.string(from: value as NSNumber){
            appendLiteral(result)
        }
    }
}
