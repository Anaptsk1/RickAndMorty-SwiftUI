//
//  SignUpView.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 05.07.25.
//

import SwiftUI

struct SignUpView: View {
    
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false
    
    var body: some View {
        
        if currentUserSignedIn {
            ProfileView()
        } else {
                OnboardingView()
            }
        }
    }


struct OnboardingView: View {
   
    /*OnBoarding States:
     State 1 = Signup Screen
     State 2 = UserName Screen
     State 3 = Age Screen
     State 4 = Email Screen
    */
    @State var stateCount: Int = 0
    
    //User Data Variables
    @State var userName: String = ""
    @State var userAge: Int = 0
    @State var userEmail: String = ""
    
    //For App Storage
    @AppStorage("userName") var currentUserName: String = ""
    @AppStorage("userAge") var currentUserAge: Int = 0
    @AppStorage("userEmail") var currentUserEmail: String = ""
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false
    
    var body: some View {

        ZStack {
            RadialGradient(colors: [Color.blue, Color.red], center: .topLeading, startRadius: 5, endRadius: 1000)
                .ignoresSafeArea()
            
            ZStack {
               
                switch stateCount {
                case 0:
                    signUpScreen
                        .transition(.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
                case 1:
                    userNameScreen
                        .transition(.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
                case 2:
                    ageScreen
                        .transition(.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
                case 3:
                    emailScreen
                        .transition(.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
                default:
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.green)
                }
               Spacer()
            }
        
            VStack {
                Spacer()
                button
                    .onTapGesture {
                        handleButtonTap()
                    }
            }
            .padding(50)
        }
    }
}
//MARK: State Screens
extension OnboardingView {
    
    private var button: some View {
        Text(stateCount == 0 ? "SIGN UP" : stateCount == 3 ? "FINISH" : "NEXT")
            .foregroundStyle(.purple)
            .font(.title3)
            .bold()
            .frame(height: 60)
            .frame(maxWidth: 350)
            .background(.white)
            .cornerRadius(10)
    }
    
    private var signUpScreen: some View {
        VStack {
            Spacer()
            Image("")
                .resizable()
                .frame(width: 200, height: 200)
                .padding()
            Spacer()
            Spacer()
        }
    }
    
    private var userNameScreen: some View {
        VStack {
            Spacer()
            Text("Enter your username")
                .font(.headline)
                .bold()
            Spacer()
            TextField("Username", text: .constant(""))
                .padding(50)
            Spacer()
            Spacer()
        }
    }
    
    private var ageScreen: some View {
        VStack {
            Spacer()
            Text("Enter your age")
                .font(.headline)
                .bold()
            Spacer()
            TextField("Age", text: .constant(""))
                .padding(50)
            Spacer()
            Spacer()
        }
    }
    
    private var emailScreen: some View {
        VStack {
            Spacer()
            Text("Enter your email")
                .font(.headline)
                .bold()
            Spacer()
            TextField("Email", text: .constant(""))
                .padding(50)
            Spacer()
            Spacer()
        }
    }
}

//MARK: Functions
extension OnboardingView {
   
    func handleButtonTap() {
        if stateCount == 3 {
            currentUserName = userName
            currentUserAge = userAge
            currentUserEmail = userEmail
            currentUserSignedIn = true
            
        } else {
            withAnimation(.spring) {
                stateCount += 1
            }
        }
    }
}

#Preview {
    OnboardingView()
}
