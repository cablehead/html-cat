{||
	let frame = $in
	if $frame.topic not-in ["url" "main.j2.html"] {
		return
	}

	minijinja-cli -t (.head main.j2.html | .cas $in.hash) -D $"urls:=(
			.cat |
			where topic == "url" |
			each { .cas $in.hash } |
			to json -r)" | .append main.html
}