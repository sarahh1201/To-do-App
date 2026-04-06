import SwiftUI

struct ListView: View {
    
    @Binding var list: TodoList
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
                    
                    Text(list.name)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color("PrimaryPink"))
                    
                    Image("checklist-icon")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
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
            }
        }
    }

    
    // MARK: - Computed current tasks
    var currentTasks: [Task] {
        list.tasks
    }
    
    // MARK: - Functions
    func addTask() {
        guard !todo.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let newTask = Task(title: todo, isCompleted: false)
        list.tasks.append(newTask)
        todo = ""
    }
    
    func deleteTask(at offsets: IndexSet) {
        list.tasks.remove(atOffsets: offsets)
    }
    
    func toggleTask(_ task: Task) {
        if let index = list.tasks.firstIndex(where: { $0.id == task.id }) {
            list.tasks[index].isCompleted.toggle()
        }
    }
    
    func clearTasks() {
        list.tasks.removeAll()
    }

}

#Preview {
    DashboardView()
}
