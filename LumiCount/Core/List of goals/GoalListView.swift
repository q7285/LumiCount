//
//  GoalListView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 01.06.2023.
//

import FirebaseFirestoreSwift
import SwiftUI
struct GoalListView: View {
    
    @StateObject var viewModel = GoalListViewViewModel()
    
    @State private var size = CGSize(width: 0, height: 0)
    @State var selectedColor: Color = .customRed
    
    //    @State private var path = NavigationPath()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ZStack {
            LinearGradient (
                gradient: Gradient(colors: [Color.backgroundTop, Color.backgroundBottom]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            if viewModel.items.isEmpty {
                VStack(alignment: .center) {
                    Spacer()
                    Image("empty_folder")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .scaledToFit()
                        .padding()
                    Text("List of goals is empty")
                        .blackExtraLight(size: 40)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                    Spacer()
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.items) { item in
                            NavigationLink(destination: SettingsView(goal: item)) {
                                GoalItemView(goal: item)
                                    .onDrag {
                                        viewModel.draggingGoal = item
                                        // Sending ID for sample
                                        return NSItemProvider(contentsOf: URL(string: "\(item.id)")!)!
                                    }
                                    .onDrop(of: [.url], delegate: DropViewDelegete(goal: item,
                                                                                   goalData: viewModel))
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Goals", displayMode: .inline)
        //            23/07
        
        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                NavigationLink(destination: ProfileView()) {
//                    Image(systemName: "info.circle")
//                }
//            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: NewGoalView(uid: viewModel.uid)) {
                    Image(systemName: "plus")
                }
            }
        }.accentColor(Color.black)
        
    }
}

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        GoalListView()
    }
}
