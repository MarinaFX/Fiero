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
      List(data, id: id) { item in
        content(item)
          .listRowSeparator(.hidden)
      }
  }
}
