
h. request get ./page/sock |
    lines |
    stateful filter {found: false urls: []} {|state, x|
        if $x == null {
          return {out : $state}
        }

        let x = ($x | from json)

        if $x.topic == "url" {
            mut state = $state
            $state.urls = ($state.urls | append (xs cas ./page $x.hash))
            return {state: $state}
        }

        if $x.topic == "main.html" {
            print $x
            mut state = $state
            $state.template = (xs cas ./page $x.hash)
            return {state: $state}
        }

        {}
    }
