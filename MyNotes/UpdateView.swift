//
//  UpdateView.swift
//  MyNotes
//
//  Created by suraj kumar on 25/01/23.
//

import SwiftUI
struct UpdateView: View {
    @Binding var updateText: String
    @Binding var notesId: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List {
            Text("Enter Your Notes:")
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
            ZStack {
                HStack(alignment: .top) {
                    TextEditor(text: $updateText)
                        .background(updateText.isEmpty ? Text("Write somethig....") : Text(""))
                        .border(Color.gray, width: 0.5)
                }
                .foregroundColor(Color.primary.opacity(0.25))
            }
            
            .shadow(radius: 2)
        }
        Button() {
            if !updateText.isEmpty {
                udpateNotes()
            }
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("UPDATE")
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .frame(width: 200, height: 44)
                .background(
                    Color.blue
                        .cornerRadius(20.0)
                )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .padding()
    }
    func udpateNotes() {
       
        let param = ["note": updateText] as [String: Any]
        guard let url = URL(string: "http://localhost:3000/notes\(notesId)") else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        do {
            request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        }catch let error{
            print(error)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("applicatio/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let error = error else { return }
            guard let data = data else { return }
            do {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                }
            }
            catch let error{
                print(error)
            }
        }
        task.resume()
    }
}

