//
//  ContentView.swift
//  Parametric1
//
//  Created by Robert Walker on 2/8/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ParametricView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
