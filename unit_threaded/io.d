/**
 * IO related functions
 */

module unit_threaded.io;


private bool _debugOutput = false; ///whether or not to print debug messages


package void enableDebugOutput() nothrow {
    _debugOutput = true;
}

package bool isDebugOutputEnabled() nothrow {
    return _debugOutput;
}

void addToOutput(ref string output, in string msg) {
    if(_debugOutput) {
        writeln(msg);
    } else {
        output ~= msg;
    }
}

/**
 * Write if debug output was enabled. Not thread-safe in the sense that it
 * will get printed out immediately and may overlap with other output.
 * To be used by test functions (not TestCases).
 */
void writelnUt(T...)(T args) {
    if(_debugOutput) writeln(args);
}

/**
 * Generates coloured output on POSIX systems
 */
version(Posix) {
    import std.stdio;

    private bool _useEscCodes;
    private string[string] _escCodes;
    static this() {
        import core.sys.posix.unistd;
        _useEscCodes = isatty(stdout.fileno()) != 0;
        _escCodes = [ "red": "\033[31;1m",
                      "green": "\033[32;1m",
                      "cancel": "\033[0;;m" ];
    }

    string green(in string msg) {
        return _escCodes["green"] ~ msg ~ _escCodes["cancel"];
    }

    string red(in string msg) {
        return _escCodes["red"] ~ msg ~ _escCodes["cancel"];
    }

} else {
    string green(in string msg) { return msg; }
    string red(in string msg) { return msg; }
}
