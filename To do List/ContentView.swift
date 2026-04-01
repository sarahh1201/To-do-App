import SwiftUI

struct ContentView: View {
    
    @State private var lists: [TodoList] = []
    @State private var selectedListIndex: Int = 0
    @State private var todo: String = ""
    @State private var newListName: String = ""
    
    var body: some View {
        ZStack {
            Image("background-pink")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                
                // Title
                HStack {
                    
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
                
                // List selector
                if !lists.isEmpty {
                    Picker("Select List", selection: $selectedListIndex) {
                        ForEach(lists.indices, id: \.self) { index in
                            Text(lists[index].name).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // Create new list
                HStack {
                    TextField("New list name", text: $newListName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                    
                    Button("Add List") {
                        addList()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .foregroundColor(Color("PrimaryPink"))
                }
                
                // Add task
                HStack {
                    TextField("Add a task", text: $todo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 225)
                    
                    Button {
                        addTask()
                    } label: {
                        Text("Add Task")
                            .frame(width: 90, height: 40)
                            .foregroundColor(Color("PrimaryPink"))
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                }
                
                // Stats
                HStack {
                    Text("Tasks: \(currentTasks.count)")
                        .foregroundColor(Color("PrimaryPink"))
                    
                    Button {
                        clearTasks()
                    } label: {
                        Text("Clear List")
                            .frame(width: 90, height: 40)
                            .foregroundColor(Color("PrimaryPink"))
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                }
                
                HStack {
                    Text("Completed: \(currentTasks.filter { $0.isCompleted }.count)")
                    Text("Incomplete: \(currentTasks.filter { !$0.isCompleted }.count)")
                }
                
                // Task list
                VStack {
                    Spacer()
                    
                    if currentTasks.isEmpty {
                        Text("No tasks yet")
                            .foregroundColor(Color("PrimaryPink"))
                            .font(.headline)
                    } else {
                        List {
                            ForEach(currentTasks) { task in
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
            }
            .padding()
            .preferredColorScheme(.light)
            .onAppear {
                loadLists()
            }
        }
    }
    
    // MARK: - Computed current tasks
    var currentTasks: [Task] {
        guard !lists.isEmpty else { return [] }
        return lists[selectedListIndex].tasks
    }
    
    // MARK: - Functions
    
    func addList() {
        guard !newListName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newList = TodoList(name: newListName, tasks: [])
        lists.append(newList)
        selectedListIndex = lists.count - 1
        newListName = ""
        saveLists()
    }
    
    func addTask() {
        guard !todo.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard !lists.isEmpty else { return }
        
        let newTask = Task(title: todo, isCompleted: false)
        lists[selectedListIndex].tasks.append(newTask)
        todo = ""
        saveLists()
    }
    
    func deleteTask(at offsets: IndexSet) {
        lists[selectedListIndex].tasks.remove(atOffsets: offsets)
        saveLists()
    }
    
    func toggleTask(_ task: Task) {
        if let index = lists[selectedListIndex].tasks.firstIndex(where: { $0.id == task.id }) {
            lists[selectedListIndex].tasks[index].isCompleted.toggle()
            saveLists()
        }
    }
    
    func clearTasks() {
        lists[selectedListIndex].tasks.removeAll()
        saveLists()
    }
    
    // MARK: - Persistence
    
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

// MARK: - Models

struct TodoList: Identifiable, Codable {
    var id = UUID()
    var name: String
    var tasks: [Task]
}

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
}

#Preview {
    ContentView()
}
