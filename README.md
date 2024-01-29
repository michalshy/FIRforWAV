# FIRforWAV
FIR low pass filter for wav files. Written in x86 asm and C++, while Interface is being handled by C# WPF

Planned:

- Improve asm algorithm, right now there is small lose in coeffs
- Add option to personalize coeffs
- Add option to play audio in the program
- Refactor C# code, it's ugly as hell
- Add option to play result audio before exporting
- Customize output, right now there is always file named output.wav in the release catalog


It's early version of the app, so the functionality is not finished yet.
To compile you need VS, I'm using 2019, you need to recompile solution so the dll files will create, but I'm working on exporting dlls somewhere else to control them.
