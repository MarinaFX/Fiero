//
//  ListWithoutSeparator.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 04/08/22.
//

import SwiftUI

struct ListWithoutSeparator<Data, ID, Content>: View where Data: RandomAccessCollection, ID: Hashable, Content: View {
  let data: Data
  let id: KeyPath<Data.Element, ID>
  let content: (Data.Element) -> Content

  public init(_ data: Data,
              id: KeyPath<Data.Element, ID>,
              @ViewBuilder content: @escaping (Data.Element) -> Content) {
    self.data = data
    self.id = id
    self.content = content
  }

  var body: some View {
    if #available(iOS 15.0, *) {
      List(data, id: id) { item in
        content(item)
          .listRowSeparator(.hidden)
      }
    } else if #available(iOS 14.0, *) {
      ScrollView {
        LazyVStack {
          ForEach(data, id: id, content: content)
        }
      }
    } else {
      List(data, id: id, rowContent: content)
        .onAppear {
          UITableView.appearance().separatorStyle = .none
        }.onDisappear {
          UITableView.appearance().separatorStyle = .singleLine
        }
    }
  }
}
