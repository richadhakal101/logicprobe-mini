logicprobe mini
hi :) this is a little side project i’ve been building in my free time for the past twoish months. i got interested in fpga’s after my ece class, and then i started digging more into digital systems using the mit 6.111 lecture notes (https://web.mit.edu/6.111/volume2/www/f2019/index.html).

i thought of making a mini logic analyser because i kept running into moments where i wanted to quickly peek at some digital signals without using a full oscilloscope. i figured this could be helpful for students / hobbyists since cheap usb analysers are limited, and i thought it would be useful (and fun) to develop my own version on an fpga.

right now this project is still beginner-stage. i’m learning a ton, debugging, and making tweaks. hopefully by the end of next month it’ll be stable and polished enough to easily capture traces.

materials
- upduino v3.1 (lattice ice40up5k)
- dupont jumper wires + breadboard
- optional 5v → 3.3v level shifter if probing 5v signals
- python 3 + pyserial on my laptop
- gtkwave to lookat captures


how it works (eventually LOL)
1. connect up to 8 digital signals (3.3v logic) into the fpga header
2. the fpga samples them into bram, triggers on a rising edge (ch0 by default), and then streams the capture over uart.
3. a small python script on my laptop grabs the data and saves it as a .vcd file.
4. i open it in gtkwave or pulseview to see waveforms.


the goal is that anyone with an upduino can plug in this code, probe some signals, and instantly get a proper logic analyser trace.

usage
1. install the toolchain
 grab the oss cad suite (https://github.com/YosysHQ/oss-cad-suite-build/releases).
 if you’re on an m1/m2/m3 mac, download the darwin-arm64 version.
 unpack into /Documents/oss-cad-suite.
 add it to your path:
 export PATH=/Documents/oss-cad-suite/bin:$PATH


2. build + flash
 from inside the project folder:
 make
 make flash


3. connect signals
 ch0..ch7 → inputs (3.3v logic only)
 gnd → common ground
 uart tx → onboard usb-serial goes back to your laptop


4. grab a capture
 install pyserial:
 pip3 install pyserial


find your serial port:
 ls /dev/tty.usbserial* /dev/tty.usbmodem* 2>/dev/null

edit host/grab.py and set the PORT to match.
 then run:
 python3 host/grab.py

it will save capture.vcd.

5. view waveforms
 install gtkwave (brew makes it easy):
 brew install gtkwave
 gtkwave capture.vcd


now you should see your signals.

pinout (upduino v3.1 headers i’m using)
 clk (12mhz) → pin 35 (onboard osc)
 uart tx → pin 6
 ch0 → pin 2
 ch1 → pin 3
 ch2 → pin 4
 ch3 → pin 5
 ch4 → pin 9
 ch5 → pin 10
 ch6 → pin 11
 ch7 → pin 12
 gnd → gnd header pin

notes
 this project is just for fun and learning. i’m not an expert, just trying things out.
 lots of debugging still in progress so pls expect messy commits 
 target is to finish the first working version by the end of next month.

license
mit license: do whatever, but if you build something cool with this let me know :)

