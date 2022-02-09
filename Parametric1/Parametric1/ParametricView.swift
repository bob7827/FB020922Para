//
//  ParametricView.swift
//  Parametric1
//
//  Created by Robert Walker on 2/8/22.
//

import SwiftUI

struct ParametricView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var s = ParametricViewModel()
    @State var f = 0.0
    @State var cntFact = 1.0
    
    let timer = Timer.publish(every: 0.0025, on:.main, in:.common).autoconnect()
    
    var body: some View {
        
        GeometryReader{ geometry in
            
            ZStack{
                XYView(s: s, f: $f, geometry: geometry)
//                XYView(s: s, f: $f, geometry: geometry)
//                    .rotationEffect(Angle(degrees: 90))
                XYView(s: s, f: $f, geometry: geometry)
                    .rotationEffect(Angle(degrees: 180))
//                XYView(s: s, f: $f, geometry: geometry)
//                    .rotationEffect(Angle(degrees: -90))


            }
            .onAppear(perform: {
                s.calcXY(f)
            })
            .onReceive(timer) {input in
                if f>0.158{
                    cntFact = -1.0
                }
                if f < -0.158{
                    cntFact = 1.0
                }
                f += cntFact*0.00075  // .00045
            }
            
            .background(Color.black)
            Spacer()
            Slider(value: $f, in: -0.16...0.16)
                .onChange(of: f, perform: {xi in
                    s.calcXY(f)
                })
            Text("\(f)")
                .foregroundColor(.white)
            
            }
        
        
    }
}


extension ParametricView{
    
    class ParametricViewModel: ObservableObject{

        
        @Published var XYArray = [XY]()
        
        var x: Double=1.0
        
        func calcXY(_ f: Double)->Bool{
            print("calcXY")
            XYArray=[]
            for t in stride(from: -5.0, through: 5.0, by: 0.002) {
                
//                let x = 16.0*pow(sin(t*f),3.0)
//                let y = (13.0*cos(t*f*f) - 5.0*cos(2.0*f*t) - 2.0*cos(3.0*f*t) - cos(4.0*f*f*t))
                
                
//                // nice pattern
//                let sin5t = sin(-5.0*t*f)
//                let x=2.5*sin5t*sin5t * pow(2.0,cos(cos(4.28*2.3*t)))
//                let y=2.5*sin(sin5t) * cos(4.28*2.3*t)*cos(4.28*2.3*t)
                
                // nice pattern
                
//                let x=2.0*cos(t)+sin(2.0*t*f)*cos(60.0*t)*1.5
//                let y=sin(4.0*t)+sin(60.0*t)*3.0
                
                // FB 2/9/2022
                let x=2.0*cos(t*f)+sin(4.0*t*f)*cos(64.0*t)*3.3
                let y=sin(4.0*t*f)*(f/0.11)+sin(32.0*t)*2.8
                
                
//                print("\(x), \(y)")
                XYArray.append(XY(x: x, y: y))
                
            }
            return true
        }
    }
    
    struct XYView: View {
        var s: ParametricViewModel
        @Binding var f: Double
        var geometry: GeometryProxy
        @State var counter = 0.0
        var body: some View {
            
            Path(){ path in
                
                var atFirstPoint = true
                
                print("\(s.XYArray.count)")
                if s.XYArray.count>0 {
                    for p in s.XYArray{
                        let x = transformV(xp: p.x, minXp:-5.0, maxXp:5.0, vSpan: geometry.size.width/1.0)
                        let y = -transformV(xp: p.y, minXp:-5.0, maxXp:5.0, vSpan: geometry.size.height/1.0) + geometry.size.height
                        
                        if atFirstPoint{
                            path.move(to: CGPoint(x: x, y: y))
                            atFirstPoint = false
                            print("***")
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                        //print("->>>  \(x), \(y)")
                    }
                }
            }
            
//            .stroke(Color.green, style: StrokeStyle(lineWidth: 1.0, lineCap: .round, lineJoin: .bevel, miterLimit: 50.0))

            .stroke(Color(red: 0.5-f/0.36, green: 0.5+f/0.36, blue: 0.25), style: StrokeStyle(lineWidth: 0.75))

        }
    }
    
    
    struct XY: Equatable{
        var x=0.0
        var y=0.0
    }
    
    
}


// xp = x prime = speed or sink in physical units
// converts xp to screen coordinates x
func transformV(xp: Double, minXp: Double, maxXp: Double, vSpan: Double)->Double {
    let x0 = vSpan*0.05
    let x1 = vSpan*0.95
    //print("\(x0), \(x1)")
    let x = (xp-minXp)/(maxXp-minXp)*(x1-x0)+x0
    return x
}
