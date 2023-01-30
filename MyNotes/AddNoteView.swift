//
//  AddNoteView.swift
//  MyNotes
//
//  Created by suraj kumar on 22/01/23.
//
import SwiftUI
struct AddNoteView: View {
    @State var text: String = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        List {
            Text("Enter Your Notes:")
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
            ZStack {
                HStack(alignment: .top) {
                    TextEditor(text: $text)
                        .background(text.isEmpty ? Text("Write somethig....") : Text(""))
                        .border(Color.gray, width: 0.5)
                }
                .foregroundColor(Color.primary.opacity(0.25))
            }
            
            .shadow(radius: 2)
        }
        Button() {
            if !text.isEmpty {
                postNote()
            }
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("CREATE")
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
    func postNote() {
        let param = ["note": text] as [String: Any]
        let url = "http://localhost:3000/notes"
        guard let baseURL = URL(string: url) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        do {
            request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        }
        catch {
            print(error)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
                         
        let task = session.dataTask(with: request) { data, res, error in
            guard  error == nil else { return }
            
            guard let data = data else {return}
            do {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                    print(json)
                }
            }catch {
                print(error)
            }
            
        }
        task.resume()
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
