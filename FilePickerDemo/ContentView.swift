//
//  ContentView.swift
//  FilePickerDemo
//
//  Created by Choluj Jedrzej (BL) on 20/10/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      FilePicker(
        store: .init(
          initialState: .init(
            selectionLimit: 5,
            maximumSize: 10 * 1_024 * 1_024,
            allowedContentTypes: [.pdf, .jpeg, .heic, .png, .html]
          ), 
          reducer: FilePickerReducer.init
        )
      )
      .background(Color.background.ignoresSafeArea())
    }
}

#Preview {
    ContentView()
}
