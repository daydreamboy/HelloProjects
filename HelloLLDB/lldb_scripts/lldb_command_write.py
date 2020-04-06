
"""
a script for providing `write` command in lldb session

Usage:
1. place this script at ~/lldb
2. add command script import ~/lldb/lldb_command_write.py to ~/.lldbinit
3. write -h to see help info

@see https://github.com/4iar/lldb-write
"""


from __future__ import print_function
import lldb
import argparse
import time
import os


def log_debug(args, message):
    if args.debug:
        print('[Debug]', message)


def parse_args(raw_args):
    """Parse the arguments given to write command"""
    parser = argparse.ArgumentParser(
        prog='write',
        description='Write the output of a lldb command to file'
    )

    parser.add_argument('-f', '--filename', help='The file name to write. If not given, use lldb_output_<timestamp>.txt instead')
    parser.add_argument('command', nargs='+', help='The LLDB commands')
    parser.add_argument('-d', '--debug', action='store_true', help='Turn on debug mode')

    args = parser.parse_args(raw_args.split(' '))

    args.command = ' '.join(args.command)

    if args.filename is None:
        args.filename = 'lldb_output_%s.txt' % str(time.time())

    return args


def write_to_file(filename, command, output):
    """Write the output to the given file, headed by the command"""
    file_path = os.path.expanduser('~/' + filename)
    f = open(file_path, 'w')

    f.write('(lldb) ' + command + '\n\n')
    f.write(output)
    f.close()

    print('write successfully to %s' % file_path)


def handle_call(debugger, raw_args, result, internal_dict):
    """Receives and handles the call to write from lldb"""
    args = parse_args(raw_args)

    log_debug(args, args)

    res = lldb.SBCommandReturnObject()
    interpreter = lldb.debugger.GetCommandInterpreter()
    interpreter.HandleCommand(args.command, res)

    output = res.GetOutput() or res.GetError()
    print(output, end='')
    write_to_file(args.filename, args.command, output)


def __lldb_init_module(debugger, internal_dict):
    """Initialize the write command within lldb"""
    debugger.HandleCommand('command script add -f %s.handle_call write' % os.path.splitext(os.path.basename(__file__))[0])

    print('The "write" command has been loaded and is ready for use.')
