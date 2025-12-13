//
//  ProfileView.swift
//  FinalProject
//
//  Created by Neel Joshi on 4/23/25.
//

import Security
import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            if let profile = profileVM.profile {
                VStack(spacing: 20) {
                    if let avatarPath = profile.avatar.tmdb.avatarPath,
                       let url = URL(string: "https://image.tmdb.org/t/p/w200\(avatarPath)")
                    {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.accentColor, lineWidth: 3))
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    }
                                
                    Text("Welcome, \(profile.name)!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                                
                    Text("@\(profile.username)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                                
                    Button(action: {
                        Task {
                            if profileVM.session != nil {
                                username = ""
                                password = ""
                                await profileVM.logout()
                            }
                        }
                    }) {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.top, 10)
                                
                    Spacer()
                }
                .padding()
            } else {
                Form {
                    Section(header: Text("TMDB Login")) {
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    Button("Log In") {
                        Task {
                            await profileVM.createRequestToken()
                            
                            if let token = profileVM.token {
                                await profileVM.validateRequestToken(username: username, password: password, requestToken: token)
                            }
                            
                            if let validatedToken = profileVM.validatedToken {
                                await profileVM.createSession(requestToken: validatedToken)
                            }
                            
                            if let sessionId = profileVM.session {
                                await profileVM.getProfile(sessionId: sessionId)
                            }
                            
                            if let sessionId = profileVM.session, profileVM.profile != nil {
                                profileVM.saveSession(username: username, sessionId: sessionId)
                                username = ""
                                password = ""
                            }
                        }
                    }
                }
            }
        }
    }
}

// #Preview {
//    ProfileView()
// }
