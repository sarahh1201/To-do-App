//
//  DashboardView.swift
//  To do List
//
//  Created by Sarah Hill on 2026-04-01.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var lists: [TodoList] = [
        TodoList(name: "Default", tasks: []),
        TodoList(name: "Personal", tasks: [])
    ]
    
    @State private var listName: String = ""
    @State private var showingAddList = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background-pink")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
         
                    List {
                        ForEach(lists.indices, id: \.self) { index in
                            NavigationLink(destination: ListView(list: $lists[index])) {
                                VStack(alignment: .leading) {
                                    Text(lists[index].name)
                                        .font(.headline)
                                    
                                    Text("\(lists[index].tasks.count) tasks")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete(perform: deleteList)
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.top, 100)
                
                
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                
                                Button {
                                    showingAddList = true
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color("PrimaryPink"))
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }
                                .padding(.bottom, 20)
                                .padding(.trailing, 20)
                            }
                        }
                    )
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack{
                    Text("My Lists")
                        .font(.largeTitle)
                        .foregroundColor(Color("PrimaryPink"))
                        .bold()
                    
                    Image("checklist-icon")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 150)
                }
                    
            }
            .font(.largeTitle)
            .bold()
            .foregroundStyle(Color("PrimaryPink"))
            .onAppear {
                loadLists()
            }
            .onChange(of: lists) {
                saveLists()
            }
            .alert("New List", isPresented: $showingAddList) {
                
                TextField("List name", text: $listName)
                
                Button("Cancel", role: .cancel) {
                    listName = ""
                }
                
                Button("Add") {
                    addList()
                    listName = ""
                }
            }
        }
    }
    
    func addList(){
        let name = listName.trimmingCharacters(in: .whitespaces)
        
        let newList = TodoList(
            name: name.isEmpty ? "New List" : name,
            tasks:[]
        )
        lists.append(newList)
    }
    
    func deleteList(offsets: IndexSet){
        lists.remove(atOffsets: offsets)
    }
    
    func saveLists() {
        if let encoded = try? JSONEncoder().encode(lists) {
            UserDefaults.standard.set(encoded, forKey: "lists")
        }
    }

    func loadLists() {
        if let data = UserDefaults.standard.data(forKey: "lists"),
           let decoded = try? JSONDecoder().decode([TodoList].self, from: data) {
            lists = decoded
        } else {
            lists = [TodoList(name: "Default", tasks: [])]
        }
    }
}

#Preview {
    DashboardView()
}
