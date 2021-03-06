struct AnalyticsProvider: AnalyticsProviding {

    private let keyValueStoring: KeyValueStoring

    init(
        keyValueStoring: KeyValueStoring
    ) {
        self.keyValueStoring = keyValueStoring
    }

    func makeTypeAnalyticsParameters() -> (authType: AnalyticsEvent.AuthType,
                                           tokenType: AnalyticsEvent.AuthTokenType?) {

        let authType: AnalyticsEvent.AuthType
        let tokenType: AnalyticsEvent.AuthTokenType?

        let hasReusableWalletToken = keyValueStoring.getString(
            for: KeyValueStoringKeys.walletToken
        ) != nil
        && keyValueStoring.getBool(
            for: KeyValueStoringKeys.isReusableWalletToken
        ) == true

        if hasReusableWalletToken {
            authType = .paymentAuth
            tokenType = .multiple
        } else if keyValueStoring.getString(
            for: KeyValueStoringKeys.moneyCenterAuthToken
        ) != nil {
            authType = .moneyAuth
            tokenType = .single
        } else {
            authType = .withoutAuth
            tokenType = nil
        }
        return (authType, tokenType)
    }
}
