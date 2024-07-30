def to-sse [] {
    str replace --all "\n" "\ndata: " | $"data: ($in)\n"
}

def go [] {
    h. request get ../xs/store/sock//?follow |
        lines | each { from json } | stateful filter {found: false} { |state, x| 
          if $state.found {
                return { out: $x }
            }

          if $x.topic == "stream.cross.threshold" {
                return { state: {found: true}, out: ($state | get last?) }
            }
           { state: {found: false, last: $x} }
        } | each {|x|
            print (h. request get $"../xs/store/sock//cas/($x.hash)" | to-sse)
        }
}

go
