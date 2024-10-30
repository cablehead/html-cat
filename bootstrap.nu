glob bootstrap/handlers/* | each { |name|
  open -r $name | .append ($name | path parse | $"($in.stem).register") }

glob bootstrap/pages/* | each { |name|
  open -r $name | .append ($name | path basename) }
