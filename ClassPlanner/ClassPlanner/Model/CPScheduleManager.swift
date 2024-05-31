

import SwiftUI

@Observable class CPScheduleManager {

  var yearPlans: [CPYearPlan] = CPSampleData.yearPlans

  var themeColor: Color = .green

  var allClasses: [CPClass] {
    return yearPlans.flatMap {
      $0.semesters.flatMap {
        $0.classes
      }
    }
  }

  var sortedYearPlans: [CPYearPlan] {
    return yearPlans.sorted { $0.year < $1.year }
  }

}
