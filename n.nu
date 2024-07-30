def to-sse [event: string] {
		print $"event: ($event)"
	  let data = $in
    $data | str replace --all "\n" "\ndata: " | $"data: ($in)\n"
}

h. request get ./page/sock//?follow |
	lines |
	each { from json } |
	stateful filter {found:false seen: {}} {|state, x|
		if $x.topic == "stream.cross.threshold" {
				return { state: {found: true}, out: ($state | get seen | values) }
		}

		if not ($x.topic | str starts-with "sse/") {
			return {}
		}

		if $state.found {
			return { out: $x }
		}

		mut state = $state 
		$state.seen = ($state.seen | upsert $x.topic $x) 
	  {state: $state}

	} | flatten | each {|x| 
    print (h. request get $"./page/sock//cas/($x.hash)" | to-sse ($x.topic | path basename))
	}
