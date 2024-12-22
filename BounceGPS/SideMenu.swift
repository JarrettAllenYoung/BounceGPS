//
//  SideMenu.swift
//  BounceGPS
//
//  Created by Jarrett Young on 12/21/24.
//

import SwiftUI

struct SideMenu: View {
    @Binding var isMenuOpen: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "person.fill")
                    Text("Hi, Martin")
                        .fontWeight(.bold)
                }
                .padding(.top)

                Button(action: {}) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                        Text("MY ACCOUNT")
                    }
                }
                .foregroundColor(.blue)

                Button(action: {}) {
                    HStack {
                        Image(systemName: "questionmark.circle")
                        Text("HELP/SUPPORT")
                    }
                }
                .foregroundColor(.green)

                Button(action: {}) {
                    HStack {
                        Image(systemName: "lock.shield")
                        Text("PRIVACY POLICY")
                    }
                }
                .foregroundColor(.brown)

                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise.circle")
                        Text("RESET LOCATION")
                    }
                }
                .foregroundColor(.red)

                Spacer()

                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.left")
                        Text("LOGOUT")
                    }
                }
                .foregroundColor(.black)
                .padding(.bottom)
            }
            .padding()
            .frame(width: 250)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)

            Spacer()
        }
        .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
        .onTapGesture {
            isMenuOpen = false
        }
    }
}
