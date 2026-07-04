//
//  BankrollView.swift
//  RZCrapsApp
//
//  Created by Dan Zabinski on 7/2/26.
//
import SwiftUI

struct BankrollView: View {
    let bankroll: Int

    var body: some View {
        VStack {
            Text("Bankroll")
                .font(.headline)
            Text("\(bankroll) units")
                .font(.title)
                .bold()
        }
        .padding()
    }
}

