def write_vcd(samples, sample_hz, path):
    tstep_ns = int(1e9 / sample_hz)
    with open(path, "w") as f:
        f.write("$date\n now\n$end\n$version\n logicprobe-mini\n$end\n")
        f.write("$timescale 1ns $end\n")
        for i in range(8):
            f.write(f"$var wire 1 {chr(33+i)} ch{i} $end\n")
        f.write("$enddefinitions $end\n")
        last = [None]*8
        t = 0
        for s in samples:
            f.write(f"#{t}\n")
            for i in range(8):
                v = (s>>i)&1
                if last[i] != v:
                    f.write(("1" if v else "0") + chr(33+i) + "\n")
                    last[i] = v
            t += tstep_ns
