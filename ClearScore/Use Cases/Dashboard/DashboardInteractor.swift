//
//  DashboardInteractor.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import Combine

protocol DashboardInteractorOutput: InteractorOutput {
    func creditScoreFetched(response: CreditScoreResponseModel)
}

class DashboardInteractor {

    private weak var output: DashboardInteractorOutput?
    var storage = Set<AnyCancellable>()

    init(output: DashboardInteractorOutput) {
        self.output = output
    }

    func fetchCreditScore() {
        Router.getCreditScore().sink {[weak self] result in
            switch result{
            case .failure(let error):
                self?.output?.errorResponse(error: error, endpoint: .getCreditScore)
            case .finished:
                break
            }
        } receiveValue: {[weak self] response in
            self?.output?.creditScoreFetched(response: response)
        }.store(in: &storage)
    }
}
