
import SwiftUI

struct ContentView: View {
   @State var manager = CPScheduleManager()
    @State private var currentYearPlanIndex: Int = 0
    @State private var isPresentingAddClassSheet = false
    @State private var isPresentingThemeColorSheet = false
    @State private var isInEditMode = false

    private var sortedYearPlans: [CPYearPlan] {
      return manager.yearPlans.sorted{$0.year < $1.year}
    }
    
    private var currentYearString: String {
        String(sortedYearPlans[currentYearPlanIndex].year)
    }
    
    private var currentYear: Int {
        sortedYearPlans[currentYearPlanIndex].year
    }



    var body: some View {
        NavigationStack {
            VStack {
                yearTimelineView


                TabView(selection: $currentYearPlanIndex,
                        content:  {
                    ForEach(Array(sortedYearPlans.enumerated()), id: \.offset) { index, yearPlan in
                        SemesterListView(yearPlan: yearPlan, isInEditMode: isInEditMode)
                            .tag(index)
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                })
                .padding()
                .tabViewStyle(.page)
            }
            .navigationTitle("My Plan")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresentingAddClassSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                            .bold()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isInEditMode.toggle()
                          manager.allClasses[currentYearPlanIndex].alreadyTaken = isInEditMode
                          if isInEditMode {
                          //  manager.allClasses.remove(at: currentYearPlanIndex)
                          }
                        }
                    }) {
                        Text(isInEditMode ? "Done" : "Edit")
                            .bold()
                    }
                   // .disabled(manager.allClasses[currentYearPlanIndex].alreadyTaken)
                    Button(action: {
                        isPresentingThemeColorSheet.toggle()
                    }) {
                        Circle()
                        .fill(manager.themeColor.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                  .fill(manager.themeColor)
                                    .frame(width: 30, height: 30)
                            )
                    }
                }
            }
            .fullScreenCover(isPresented: $isPresentingThemeColorSheet) {
              ThemeColorPaletteView(themeColor: $manager.themeColor)
            }
            .sheet(isPresented: $isPresentingAddClassSheet) {
                AddClassView(yearPlans: sortedYearPlans)
            }
            .tint(manager.themeColor)
        }

    }
    
    private var yearTimelineView: some View {
        HStack {
            yearTimelineLeftButton
            
            Spacer()
            Text(currentYearString)
                .font(.system(size: 35))
                .fontWeight(.heavy)
                .contentTransition(.numericText(value: Double(currentYearString)!))
            Spacer()
            
            yearTimelineRightButton
        }
        .padding()
    }
    
    private var yearTimelineLeftButton: some View {
        Button(action: {
            withAnimation {
                if currentYearPlanIndex - 1 < 0 {
                    let newYearPlan = CPYearPlan(year: currentYear - 1, semesters: [
                        CPSemester(type: .fall, classes: []),
                        CPSemester(type: .spring, classes: [])
                    ])
                  manager.yearPlans.append(newYearPlan)
                } else {
                    currentYearPlanIndex -= 1
                }
            }
        }) {
            if currentYearPlanIndex - 1 < 0 {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(Color.green)
            } else {
                Image(systemName: "chevron.left.circle.fill")
            }
        }
        .font(.system(size: 30))
    }
    
    private var yearTimelineRightButton: some View {
        Button(action: {
            withAnimation {
              if currentYearPlanIndex + 1 >= manager.yearPlans.count {
                    let newYearPlan = CPYearPlan(year: currentYear + 1, semesters: [
                        CPSemester(type: .fall, classes: []),
                        CPSemester(type: .spring, classes: [])
                    ])
                  manager.yearPlans.append(newYearPlan)
                }
                currentYearPlanIndex += 1
            }
        }) {
          if currentYearPlanIndex + 1 >= manager.yearPlans.count {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(Color.green)
  
            } else {
                Image(systemName: "chevron.right.circle.fill")
            }
            
        }
        .font(.system(size: 30))
    }
}


#Preview {
  ContentView()
}
