

let urls =  stacks 03B4W6L3GH1CLZBMFNHP35DA2 --meta |
	from json  | get clip.children | each {|x| stacks $x}

{ urls: $urls } | to json -r | minijinja-cli -f json ./main.html - | tee {
	xs append ../xs/store kv-value 
}
