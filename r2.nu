
def render [$template $data] {
    let path = mktemp -t 
    $template | save -f $path
    let output = ($data | to json -r | minijinja-cli -f json $path -)
    rm $path
    return $output
}


h. request get ./page/sock//?follow |
    lines |
    each { from json } |
    stateful filter {found: false data: {urls: []}} {|state, x|
        mut state = $state
        mut trigger = false

        if $x == null or $x.topic == "stream.cross.threshold" {
            $state.found = true
            $trigger = true

        } else if $x.topic == "url" {
            $state.data.urls = ($state.data.urls | append (xs cas ./page $x.hash))
            $trigger = true

        } else if $x.topic == "main.html" {
            $state.template = (xs cas ./page $x.hash)
            $trigger = true
        }

        if $state.found and $trigger {
            return {
                state: $state
                out: (render $state.template $state.data)
            }
        }

        {state: $state}
    } | each { xs append ./page sse/main }
