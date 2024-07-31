watch .  {|typ, path|
  print $typ $path
	if $typ == "Write" {
		let file = $path | path basename

		if $file == "main.html" {
			cat $path | xs append ./page main.html
			return
		}

		if $file == "style.css" {
			cat $path | xs append ./page sse/styles
		}
	}
}
