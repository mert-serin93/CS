//
//  DashboardDetailInteractor.swift
//  ClearScore
//
//  Created by Mert Serin on 2021-05-24.
//

import Combine

protocol DashboardDetailInteractorOutput: InteractorOutput {}

class DashboardDetailInteractor {

    private weak var output: DashboardDetailInteractorOutput?
    var storage = Set<AnyCancellable>()

    init(output: DashboardDetailInteractorOutput) {
        self.output = output
    }
}
