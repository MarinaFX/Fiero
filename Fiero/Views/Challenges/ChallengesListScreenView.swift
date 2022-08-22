//
//  ChallengesListScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 21/07/22.
//

import SwiftUI

struct ChallengesListScreenView: View {
    @Environment(\.rootPresentationMode) var rootPresentationMode
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var quickChallenges: [QuickChallenge] = []
    @State var isPresentingQuickChallengeCreation: Bool = false
    @State var isPresentingChallengeDetails: Bool = false
    @State var presentModalIndex: QuickChallenge? = nil
    
    private var sortedList: [QuickChallenge] {
        return quickChallenges.sorted(by: { $0.updatedAt > $1.updatedAt })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
                VStack {
                    if self.quickChallenges.count > 0 {
                        if #available(iOS 15.0, *) {
                            ListWithoutSeparator(self.sortedList, id: \.self) { challenge in
                                ZStack {
                                    CustomTitleImageListRow(title: challenge.name)
                                }
                                .listRowBackground(Color.clear)
                                .onTapGesture {
                                    self.presentModalIndex = challenge
                                }
                            }
                            .fullScreenCover(item: $presentModalIndex) { item in
                                ChallengeDetailsView(quickChallenge: item)
                                    .environmentObject(self.quickChallengeViewModel)
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
                            ListWithoutSeparator(0..<self.sortedList.count, id: \.self) { index in
                                NavigationLink(
                                    destination: ChallengeDetailsView(quickChallenge: self.sortedList[index])
                                    .environmentObject(self.quickChallengeViewModel),
                                    label: {
                                    CustomTitleImageListRow(title: sortedList[index].name)
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
                    self.quickChallenges = quickChallenges
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
