app.directive 'accounts', ->
  return {
    restrict: 'E'
    templateUrl: '/templates/funds/accounts.html'
    scope: { localValue: '=accounts' }
    controller: ($scope, $state) ->
      ctrl = @
      @state = $state
      @defaultCurrency = if gon.current_user.document_auth
                          Account.first().currency
                        else
                          Account.first(2)[1].currency
      if window.location.hash == ""
        @state.transitionTo("deposits.currency", {currency: Account.first().currency})

      $scope.accounts = Account.all()

      # Might have a better way
      # #/deposits/eur
      @selectedCurrency = window.location.hash.split('/')[2] || @defaultCurrency
      @currentAction = window.location.hash.split('/')[1] || 'deposits'
      $scope.currency = @selectedCurrency

      @isSelected = (currency) ->
        @selectedCurrency == currency

      @isDeposit = ->
        @currentAction == 'deposits'

      @isWithdraw = ->
        @currentAction == 'withdraws'

      @deposit = (account) ->
        if(!gon.current_user.document_auth && gon.fiat_currency == account.currency)
          window.location.href = "id_document/edit"
        ctrl.state.transitionTo("deposits.currency", {currency: account.currency})
        ctrl.selectedCurrency = account.currency
        ctrl.currentAction = "deposits"

      @withdraw = (account) ->
        if(!gon.current_user.document_auth)
          window.location.href = "id_document/edit"
        ctrl.state.transitionTo("withdraws.currency", {currency: account.currency})
        ctrl.selectedCurrency = account.currency
        ctrl.currentAction = "withdraws"

      do @event = ->
        Account.bind "create update destroy", ->
          $scope.$apply()

    controllerAs: 'accountsCtrl'
  }

