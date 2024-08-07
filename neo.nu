#!/Users/andy/.s/sessions/03B73LNTW7UJJP1EWGDQMZNH3/nushell/target/debug/nu

def to-sse [event: string] {
    print $"event: ($event)"
    let data = $in
    $data | str replace --all "\n" "\ndata: " | $"data: ($in)\n"
}

def respond [request_id: string meta: record] {
    h. request post ./page/sock//http.response -H {
        "xs-meta": ($meta | upsert request_id $request_id | to json -r)}
}

def process_request [request_id: string, meta: record] {
    match $meta.path {
        "/" => {
            "home" | respond $request_id {status: 200}
        }
        _ => {
            "not found" | respond $request_id {status: 404}
        }
    }
}

def main [] {
    h. request get './page/sock//?follow&tail' | lines | each { from json } | where topic == 'http.request' |
        each { |x| process_request $x.id $x.meta }
}

def goo [] {
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
}
