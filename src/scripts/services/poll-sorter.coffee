angular.module "pollSorterService", []
  .service "pollSorter", ($filter) ->
    sort: (data) ->
      partyColors =
        "Ø": "#731525"
        F: "#9C1D2A"
        A: "#E32F3B"
        B: "#E52B91"
        C: "#0F854B"
        V: "#0F84BB"
        O: "#005078"
        I: "#EF8535"
        K: "#F0AC55"
      poll =
        datetime: new Date data.datetime.replace(" ", "T")
        entries: $filter('orderBy')(data.entries.entry, 'party.letter')

      for entry in poll.entries
        entry.color = partyColors[entry.party.letter]

      return poll
