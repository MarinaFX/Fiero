//
//  ChallengesListScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 21/07/22.
//

import SwiftUI

struct ChallengesListScreenView: View {
    
    @Environment(\.rootPresentationMode) var rootPresentationMode
    @StateObject var quickChallengeViewModel: QuickChallengeViewModel = QuickChallengeViewModel()
    @State var quickChallenges: [QuickChallenge] = []
    @State var isPresentingQuickChallengeCreation: Bool = false
    @State var isPresentingChallengeDetails: Bool = false
    @State var serverResponse: ServerResponse = .unknown
    @State var presentModalIndex: QuickChallenge? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
                VStack {
                    if self.quickChallenges.count > 0 {
                        if #available(iOS 15.0, *) {
                            ListWithoutSeparator(0..<self.quickChallenges.count, id: \.self) { index in
                                ZStack {
                                    CustomTitleImageListRow(title: quickChallenges[index].name)
                                }
                                .listRowBackground(Color.clear)
                                .onTapGesture {
                                    self.presentModalIndex = quickChallenges[index]
                                }
                            }
                            .fullScreenCover(item: $presentModalIndex) { item in
                                ChallengeDetailsView(quickChallengeViewModel: QuickChallengeViewModel(), quickChallenge: item)
                            }
                            .navigationBarHidden(false)
                            .navigationTitle("Seus desafios")
                            .refreshable {
                                self.quickChallengeViewModel.getUserChallenges()
                            }
                            .ignoresSafeArea(.all, edges: .bottom)
                            .listStyle(.plain)
                        } else {
                            //TODO: Refreshable list for iOS 14
                            ListWithoutSeparator(0..<self.quickChallenges.count, id: \.self) { index in
                                NavigationLink(destination: ChallengeDetailsView(quickChallengeViewModel: QuickChallengeViewModel(), quickChallenge: self.quickChallenges[index]), label: {
                                    CustomTitleImageListRow(title: quickChallenges[index].name)
                                })
                                .buttonStyle(PlainButtonStyle())
                            }
                            .ignoresSafeArea(.all, edges: .bottom)
                            .listStyle(.plain)
                        }
                    }
                    else {
                        EmptyChallengesView()
                    }
                }
                .fullScreenCover(isPresented: $isPresentingQuickChallengeCreation) {
                    QCCategorySelectionView()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isPresentingQuickChallengeCreation = true
                        }, label: {
                            Image(systemName: "plus")
                                .font(Tokens.FontStyle.title2.font(weigth: .bold))
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        })
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .onAppear(perform: {
                    UITableView.appearance().refreshControl = UIRefreshControl()
                    self.quickChallengeViewModel.getUserChallenges()
                })
                .onChange(of: self.quickChallengeViewModel.challengesList, perform: { quickChallenges in
                    self.quickChallenges = []
                    self.quickChallenges = quickChallenges
                })
                .onChange(of: self.quickChallengeViewModel.serverResponse, perform: { serverResponse in
                    self.serverResponse = serverResponse
                    
                    if self.serverResponse.statusCode != 200 &&
                        self.serverResponse.statusCode != 201 {
                        //toggle alert
                    }
                })
                .environment(\.rootPresentationMode, self.$isPresentingQuickChallengeCreation)
            }
        }.environment(\.colorScheme, .dark)
    }
}

struct ChallengesListScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesListScreenView()
    }
}
