
watch .  {|typ, path|
	if $typ == "Write" {
		let path = $path | path basename

		if $path == "main.html" {
			cat $path
			return
		}

	}
}
