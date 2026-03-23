//
//  ContentView.swift
//  To do List
//
//  Created by Sarah Hill on 2026-03-22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tasks: [Task] = []
    @State private var todo: String = ""
    
    var body: some View {
        ZStack{
            Image("background-pink")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                
                // Title
                HStack{
                    Text("To-do List")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color("PrimaryPink"))
                    Image("checklist-icon")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                }
               
                HStack{
                    TextField("Enter something...", text: $todo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 225)
                    .padding(.horizontal,15)
                    .shadow(radius: 25)
                    .foregroundColor(Color("PrimaryPink"))
                    
                    // Add Task Button
                    Button{
                        print("adding task")
                        addTask()
                    }label: {
                        Text("Add Task")
                            .font(.subheadline)
                            .frame(width: 90, height: 40)
                            .foregroundColor(Color("PrimaryPink"))
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 25)
                        
                    }
                    .padding()
                    
                }
                
                VStack {
                    Spacer()
                    List {
                        ForEach(tasks) { task in
                            HStack {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .onTapGesture {
                                        toggleTask(task)
                                    }

                                Text(task.title)
                                    .strikethrough(task.isCompleted)
                            }
                        }
                        .onDelete(perform: deleteTask)
                    }
                    .scrollContentBackground(.hidden)
                }
                
            }
            .padding()
            .preferredColorScheme(.light)
            .onAppear {
                loadTasks()
            }
        }
    }

    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }

    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
    
    func addTask() {
        guard !todo.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let newTask = Task(title: todo, isCompleted: false)
        tasks.append(newTask)
        todo = ""
        saveTasks()
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }

    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
}

struct Task: Identifiable, Codable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
}

#Preview {
    ContentView()
}
