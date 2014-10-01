angular.module "dateMenuDirective", []
  .directive "dateMenu", ($document, xmlGetter, pollSorter) ->
    restrict: "E"
    scope:
      showMenu: "="
      polls: "="
    templateUrl: "/upload/tcarlsen/political-majority/partials/date-menu.html"
    link: (scope, element, attr) ->
      currentYear = new Date().getFullYear()
      activeYear = currentYear
      startTop = 0
      startLeft = 0
      top = 0
      left = 0

      drag = (event) ->
        event.preventDefault()

        startTop = event.pageY - top
        startLeft = event.pageX - left

        $document.on "mousemove", mousemove
        $document.on "touchmove", mousemove
        $document.on "mouseup", mouseup
        $document.on "touchend", mouseup

      mousemove = (event) ->
        top = event.pageY - startTop
        left = event.pageX - startLeft

        element.css
          marginLeft: 0
          opacity: 0.7
          MsTransform: "translate3d(#{left}px, #{top}px, 0)"
          MozTransform: "translate3d(#{left}px, #{top}px, 0)"
          WebkitTransform: "translate3d(#{left}px, #{top}px, 0)"
          transform: "translate3d(#{left}px, #{top}px, 0)"

      mouseup = ->
        element.css "opacity", "1"

        $document.off "mousemove", mousemove
        $document.off "touchmove", mousemove
        $document.off "mouseup", mouseup
        $document.off "touchend", mouseup

      getPollDates = ->
        xmlGetter.get("#{activeYear}/10.xml").then (data) ->
          scope.pollList = data.result.polls.poll

      scope.years = [currentYear..2010]

      scope.yearScroll = (direction) ->
        carouselEle = element.find "year-carousel"
        yearEles = carouselEle.find "year"
        currentPosition = carouselEle[0].scrollLeft
        yearWidth = yearEles[0].offsetWidth

        if direction is "left"
          newPosition = currentPosition - yearWidth
          return if newPosition < 0
        else
          newPosition = currentPosition + yearWidth
          return if newPosition > (yearEles.length - 1) * yearWidth

        index = newPosition / yearWidth
        activeYear = carouselEle.find("year")[index].innerHTML

        carouselEle[0].scrollLeft = newPosition
        getPollDates()

      scope.setNewPoll = (index) ->
        scope.polls[scope.showMenu] = pollSorter.sort scope.pollList[index]

      element.find("menu-helper").on "mousedown", drag
      element.find("menu-helper").on "touchstart", drag

      getPollDates()
