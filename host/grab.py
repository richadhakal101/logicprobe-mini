import serial, struct
from write_vcd import write_vcd

PORT = "/dev/ttyUSB0"   #on Windows: "COM4"
BAUD = 115200
SAMPLE_HZ = 120000      #match DIV in clock_div (12MHz / 100)

ser = serial.Serial(PORT, BAUD, timeout=1)

def read_exact(n):
    b = bytearray()
    while len(b) < n:
        chunk = ser.read(n - len(b))
        if not chunk:
            raise RuntimeError("Serial timeout")
        b.extend(chunk)
    return bytes(b)

#here ifind header
while True:
    b = ser.read(1)
    if not b: continue
    if b == b'\xA5' and ser.read(1) == b'\x5A':
        break

hdr = read_exact(3)             #version(1), count(1) is simplified here
version = hdr[0]
count   = hdr[2]                #if you extend header, parse accordingly

samples = list(read_exact(count))
print(f"Got {count} samples (version={version})")

write_vcd(samples, SAMPLE_HZ, "capture.vcd")
print("wroote capture.vcd (open with GTKWave)")
