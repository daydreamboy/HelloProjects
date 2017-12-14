

# raise 'Failed to create socket'
# 22_raise.rb:2:in `<main>': Failed to create socket (RuntimeError)

# raise ArgumentError, 'No parameters', caller
# 22_raise.rb: No parameters (ArgumentError)

extname = 'txt'
raise Informative, "Unsupported specification format `#{extname}`."
# 22_raise.rb:6:in `<main>': uninitialized constant Informative (NameError)
