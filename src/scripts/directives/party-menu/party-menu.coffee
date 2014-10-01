angular.module "partyMenuDirective", []
  .directive "partyMenu", ->
    restrict: "E"
    scope:
      poll: "="
      view: "="
    templateUrl: "/upload/tcarlsen/political-majority/partials/party-menu.html"
    link: (scope, element, attr) ->
      scope.toogleParty = (index) ->
        return if parseInt(scope.poll.entries[index].mandates) is 0

        letter = scope.poll.entries[index].party.letter

        if scope.view[letter] is 2 || !scope.view[letter]
          scope.view[letter] = 1
        else
          scope.view[letter] = 2
