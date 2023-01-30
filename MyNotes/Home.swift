//
//  ContentView.swift
//  MyNotes
//
//  Created by suraj kumar on 21/01/23.
//
import SwiftUI
struct Home: View {
    @State private var isShowing = false
    @State var notes = [Note]()
    @State var showAlert = false
    @State var deleteItem: Note?
    @State var updateNotes = ""
    @State var UpdateNoteId = ""
    @State var isEditMode: EditMode = .inactive
    var alert: Alert {
        Alert(title: Text("Delete"), message: Text("Are you sure want to delete this note"), primaryButton: .destructive(Text("Delete"), action: delteNotes), secondaryButton: .cancel())
    }
    var body: some View {
        NavigationStack {
            VStack {
                List(notes.reversed()) { notes in
                    
                    if(self.isEditMode == .inactive) {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("\(notes.note)".capitalized)
                                .foregroundColor(Color.blue)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding()
                        }
                        .onLongPressGesture {
                            self.showAlert.toggle()
                            deleteItem = notes
                        }
                        .swipeActions {
                            Button("Delete") {
                                deleteItem = notes
                                delteNotes()
                            }
                            .tint(.red)
                        }
                    }else {
                        HStack {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(Color.yellow)
                            Text("\(notes.note)".capitalized)
                                .foregroundColor(Color.blue)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding()
                            
                        }
                        .onTapGesture {
                            UpdateNoteId = notes._id
                            updateNotes = notes.note
                            self.isShowing.toggle()
                        }
                    }
                }
                .refreshable {
                    fetchNote()
                }
                .onAppear() {
                    fetchNote()
                }
                .navigationTitle("Notes📝")
                .navigationBarItems(leading: Button(action: {
                    if self.isEditMode == .inactive {
                        
                        self.isEditMode = .active
                    }else {
                        self.isEditMode = .inactive
                    }
                }, label: {
                    if self.isEditMode == .inactive {
                        Text("Edit")
                    }else {
                        Text("Done")
                    }
                }))
                .toolbar {
                    Button {
                        isShowing.toggle()
                    } label: {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 44, height: 44)
                            .shadow(radius: 25.0)
                            .cornerRadius(10)
                            .overlay {
                                Image(systemName: "plus.app.fill")
                                    .foregroundColor(Color.white)
                            }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert, content: {
            alert
        })
        .sheet(isPresented: $isShowing,onDismiss: fetchNote, content: {
            
            if(self.isEditMode == .inactive) {
                AddNoteView()
            }else {
                UpdateView(updateText: $updateNotes, notesId: $UpdateNoteId)
            }
            
        })
    }
    //MARK: Fetch Notes:
    func fetchNote() {
        let url = "http://localhost:3000/notes"
        guard let baseURL = URL(string: url) else { return  }
        
        let task = URLSession.shared.dataTask(with: baseURL) { data, response, error in
            guard let data = data else {return}
            
            do {
                let notes = try? JSONDecoder().decode([Note].self, from: data)
                
                self.notes = notes ?? []
                
            }
            catch {
                print(error)
            }
        }
        task.resume()
        
        if(self.isEditMode == .active) {
            self.isEditMode = .inactive
        }
    }
    func delteNotes() {
        guard let id = deleteItem?._id else {return}
        guard let url = URL(string: "http://localhost:3000/notes/\(id)") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else { return }
            guard let data = data else {return}
            do {
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            }catch {
                print(error)
            }
        }
        task.resume()
        fetchNote()
    }
}
struct Note: Identifiable, Codable {
    var id: String { _id }
    var _id: String
    var note: String
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
