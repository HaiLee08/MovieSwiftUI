//
//  SearchBar.swift
//  Mobile App
//
//  Created by Hai Le on 3/16/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var placeholderText: String
    @State private var searching: Bool = false
    
    var onCommit: (() -> ())? = nil
    var cancelSearch: (() -> ())? = nil
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.secondary)
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField(placeholderText, text: $searchText)
                    { startedEditing in
                        if startedEditing {
                            withAnimation {
                                searching = true
                            }
                        }
                    } onCommit: {
                        withAnimation {
                            searching = false
                            onCommit?()
                        }
                    }
#if os(iOS)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
#endif
                    if searching {
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").foregroundColor(.secondary).opacity(searchText == "" ? 0 : 1)
                        }
                    }
                }
                .padding(.leading, 13)
            }
             .frame(height: 40)
             .cornerRadius(13)
             .padding()
            if searching {
                Button(action: {
                    self.searching = false
                    // Dismiss the keyboard
#if os(iOS)
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
                    self.cancelSearch?()
                }) {
                    Text("Cancel")
                        .foregroundColor(.secondary)
                }.padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
    }
 }
