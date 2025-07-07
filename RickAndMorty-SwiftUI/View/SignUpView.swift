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
            TabBar()
        } else {
            OnboardingView()
                .animation(.easeInOut, value: currentUserSignedIn)
        }
    }
}

struct OnboardingView: View {
    
    /*OnBoarding States:
     State 0 = Signup Screen
     State 1 = UserName Screen
     State 2 = Age Screen
     State 3 = Email Screen
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
    
    //For Alert
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    
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
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") {
                return
            }
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
            Spacer()
            Image(systemName: "person")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
            Text("Sign up to get started and interact with the app!")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(50)
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
                .foregroundStyle(.white)
            Spacer()
            TextField("Username", text: $userName)
                .foregroundStyle(.white)
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
                .foregroundStyle(.white)
            Spacer()
            Picker("age", selection: $userAge) {
                ForEach(18..<100) { age in
                    Text("\(age)").tag(age)
                }
                .foregroundStyle(.white)
            }
            .pickerStyle(.inline)
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
                .foregroundStyle(.white)
            Spacer()
            TextField("Email", text: $userEmail)
                .foregroundStyle(.white)
                .padding(50)
            Spacer()
            Spacer()
        }
    }
}

//MARK: Functions
extension OnboardingView {
    func handleButtonTap() {
        
        //Check inputs
        switch stateCount {
        case 1:
            guard userName.count >= 2 else {
                showAlert(text: "Please enter a valid name.")
                return
            }
        case 3:
            guard userEmail.contains("@") else {
                showAlert(text: "Please enter a valid email.")
                return
            }
        default:
            break
        }
        
        //Got to next section
        if stateCount == 3 {
            // Save user data to AppStorage
            currentUserName = userName
            currentUserAge = userAge
            currentUserEmail = userEmail
            currentUserSignedIn = true
            
            //             Navigate to ProfileView
            withAnimation(.spring) {
                stateCount = 0 // Reset stateCount for potential future signups
            }
        } else {
            withAnimation(.spring) {
                stateCount += 1
            }
        }
    }
    func showAlert(text: String) {
        showAlert.toggle()
        alertTitle = text
    }
}

#Preview {
    OnboardingView()
}
