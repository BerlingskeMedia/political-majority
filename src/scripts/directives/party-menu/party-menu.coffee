angular.module "partyMenuDirective", []
  .directive "partyMenu", ->
    restrict: "E"
    scope:
      poll: "="
      view: "="
    templateUrl: "/upload/tcarlsen/political-majority/partials/party-menu.html"
    link: (scope, element, attr) ->
      scope.partyColors =
        "Ø": "#731525"
        "Å": "#5AFF5A"
        F: "#9C1D2A"
        A: "#E32F3B"
        B: "#E52B91"
        C: "#0F854B"
        V: "#0F84BB"
        O: "#005078"
        I: "#EF8535"
        K: "#F0AC55"

      scope.toogleParty = (index) ->
        return if parseInt(scope.poll.entries[index].mandates) is 0

        letter = scope.poll.entries[index].party.letter

        if scope.view[letter] is 2 || !scope.view[letter]
          scope.view[letter] = 1
        else
          scope.view[letter] = 2
