angular.module "majorityGrafDirective", []
  .directive "majorityGraf", ($timeout, $window) ->
    restrict: "E"
    scope:
      poll: "="
      chartId: "@"
      view: "="
    link: (scope, element, attr) ->
      firstRun = true
      animationSpeed = 1000
      svg = d3.select(element[0]).append "svg"
      svgDom = element.find("svg")[0]
      pie = d3.layout.pie()
        .sort (a, b) ->
          a = scope.view[a.party.letter] || 2
          b = scope.view[b.party.letter] || 2

          return d3.ascending(a, b)
        .value (d) -> return d.mandates

      $window.onresize = -> scope.$apply()

      scope.$watch (->
        angular.element($window)[0].innerWidth
      ), ->
        return if firstRun

        firstRun = true

        svg.selectAll("*").remove()
        render scope.poll

      scope.$watch "data", ((newData, oldData) ->
        return if angular.equals(newData, oldData)

        render newData
      ), true

      scope.$watch "poll", ((newData, oldData) ->
        return if angular.equals(newData, oldData)

        render newData
      ), true

      scope.$watch "view", ((newData, oldData) ->
        return if angular.equals(newData, oldData)

        render scope.poll
      ), true

      render = (poll) ->
        if element[0].offsetParent is 0 or element[0].offsetParent is null
          firstRun = false
          return

        height = element[0].offsetHeight
        width = element[0].offsetWidth
        radius = Math.min(width, height) / 2 - 10
        innerRadius = 70
        arcWidth = radius - innerRadius
        arc = d3.svg.arc().outerRadius(radius).innerRadius(innerRadius)

        if firstRun
          chart = svg.append("g").data [poll.entries]

          chart
            .attr "class", "chart #{scope.chartId}"
            .attr "transform", "translate(#{width / 2}, #{height / 2})"

          layout = svg.append("g")

          layout
            .attr "class", "layout #{scope.chartId}"
            .attr "transform", "translate(#{width / 2}, #{height / 2})"

          layout
            .append "circle"
              .attr "r", radius
              .attr "class", "empty"

          layout
            .append "circle"
              .attr "r", radius - arcWidth
              .attr "class", "empty"

          layout
            .append "circle"
              .attr "r", radius - arcWidth - 10
              .attr "class", "filled"
        else
          chart = d3.select(".chart.#{scope.chartId}").data [poll.entries]
          layout = d3.select ".layout.#{scope.chartId}"

        mandateCount = 0

        for entry in poll.entries
          mandateCount += parseInt(entry.mandates) if scope.view[entry.party.letter] is 1

        $timeout ->
          if mandateCount > 90
            layout.select(".filled").classed "goal", true
          else
            layout.select(".filled").classed "goal", false
        , animationSpeed

        counter = layout.selectAll(".counter").data [poll]

        counter
          .enter()
            .append "text"
              .attr "class", "counter"
              .attr "text-anchor", "middle"
              .attr "dy", 15

        counter
          .transition().delay(animationSpeed)
            .text mandateCount

        slices = chart.selectAll(".slice").data pie

        slices
          .enter()
            .append "path"
              .attr "class", "slice"
              .attr "fill", (d) -> d.data.color

        slices
          .transition().duration(animationSpeed)
            .attr "d", (d) ->
              return arc(d) if scope.view[d.data.party.letter] is 1
              return arc({startAngle: 0, endAngle: 0, value: 0})

        values = chart.selectAll(".value").data pie

        values
          .enter()
            .append "text"
              .attr "class", "value"
              .attr "text-anchor", "middle"
              .attr "fill", "#fff"

        values
          .text (d, i) -> d.data.mandates if scope.view[d.data.party.letter] is 1
          .transition().duration(animationSpeed)
            .attr "transform", (d) -> "translate(#{arc.centroid(d)})"

        firstRun = false
