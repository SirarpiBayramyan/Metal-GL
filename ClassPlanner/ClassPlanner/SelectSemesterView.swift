
import SwiftUI

struct SelectSemesterView: View {
    @Environment(\.dismiss) private var dismiss
    
    var newClass: CPClass
    var dismissParentView: () -> Void
    @State private var selectedSemester: CPSemester?
    @State var manager = CPScheduleManager()

    var body: some View {
        NavigationStack {
          List(manager.yearPlans) { yearPlan in
                VStack(spacing: 20) {
                    HStack {
                        Text(String(yearPlan.year))
                                .fontWeight(.heavy)
                                .font(.title)
                        Spacer()
                    }
                   
                    HStack {
                        if yearPlan.hasSemester(for: .fall) {
                          SelectSemesterButton(
                            selectedSemester: $selectedSemester,
                            manager: $manager,
                            yearPlan: yearPlan,
                            semesterType: .fall
                          )
                        }
                        
                        Spacer()
                        
                        if yearPlan.hasSemester(for: .spring) {
                          SelectSemesterButton(
                            selectedSemester: $selectedSemester,
                            manager: $manager,
                            yearPlan: yearPlan,
                            semesterType: .spring
                          )
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Select Semester")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
                
                if selectedSemester != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            dismiss()
                            dismissParentView()
                            selectedSemester?.classes.append(newClass)
                        }) {
                            Text("Add")
                                .foregroundStyle(.green)
                                .bold()
                        }
                    }
                }
            }
        }
    }
}

//MARK: - SelectSemesterButton 
struct SelectSemesterButton: View {
  @Binding var selectedSemester: CPSemester?
  @Binding var manager: CPScheduleManager
  var yearPlan: CPYearPlan
  var semesterType: CPSemester.CPSemesterType

  init(
    selectedSemester: Binding<CPSemester?>,
    manager: Binding<CPScheduleManager>,
    yearPlan: CPYearPlan,
    semesterType: CPSemester.CPSemesterType
  ) {
    self._selectedSemester = selectedSemester
    self._manager = manager
    self.yearPlan = yearPlan
    self.semesterType = semesterType
  }

    private var currentSemester: CPSemester? {
        yearPlan.getSemester(for: semesterType)
    }
    
    var body: some View {
        Button(action: {
            selectedSemester = currentSemester
        }) {
            Text("\(semesterType == .fall ? "FALL" : "SPRING")")
                .padding()
                .background(currentSemester == selectedSemester ? manager.themeColor.opacity(0.2) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

#Preview {
  SelectSemesterView(
    newClass: CPClass(
      name: "CS61A",
      instructors: ["John Denro"],
      domain: "Computer Science",
      alreadyTaken: true
    ),
    dismissParentView: {}
  )
}
