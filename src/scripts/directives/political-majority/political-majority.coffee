angular.module "politicalMajorityDirective", []
  .directive "politicalMajority", (xmlGetter, pollSorter) ->
    restrict: "E"
    templateUrl: "/upload/tcarlsen/political-majority/partials/political-majority.html"
    link: (scope, element, attr) ->
      currentYear = new Date().getFullYear()
      scope.polls = {}
      scope.view =
        one: {}
        two: {}

      getLatestPoll = (year) ->
        xmlGetter.get("#{year}/10.xml").then (data) ->
          if data.error
            getLatestPoll currentYear - 1
          else
            scope.polls.one = pollSorter.sort data.result.polls.poll[0]
            scope.polls.one.datetime = "Seneste Berlingske gns."

      xmlGetter.get("valgresultater.xml").then (data) ->
        scope.polls.two = pollSorter.sort data.result.poll[0]
        scope.polls.two.datetime = "Seneste Valg"

      getLatestPoll currentYear
