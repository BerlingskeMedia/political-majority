angular.module "pollSorterService", []
  .service "pollSorter", ($filter) ->
    sort: (data) ->
      partyColors =
        V: "hsl(199, 96%, 38%)"
        A: "hsl(356, 74%, 50%)"
        B: "hsl(326, 92%, 47%)"
        F: "hsl(355, 69%, 36%)"
        K: "hsl(36, 85%, 62%)"
        O: "hsl(203, 93%, 24%)"
        I: "hsl(7, 84%, 54%)"
        "Ø": "hsl(357, 62%, 29%)"
        C: "hsl(150, 94%, 26%)"
      poll =
        datetime: new Date data.datetime.replace(" ", "T")
        entries: $filter('orderBy')(data.entries.entry, 'party.letter')

      for entry in poll.entries
        entry.color = partyColors[entry.party.letter]

      return poll
