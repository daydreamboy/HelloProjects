require_relative '../02 - Ruby Helper/rubyscript_helper'

now = Time.now
dump_object(now)

t1 = Time.now.to_i
dump_object(t1)

t2 = Time.now.to_s
dump_object(t2)

RUN_SCRIPT_COMMENT = "#!/usr/bin/env bash\n# Auto-generated by pod_tweaker on %s\n\nblah..." % Time.now.to_s

puts RUN_SCRIPT_COMMENT