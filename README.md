# ZX0 6502 Decompressor

This is a BeebAsm 6502 port of https://xxl.atari.pl/zx0-decompressor/

* [ZX0](https://github.com/einar-saukas/ZX0) - The official **ZX0** repository.

**ZX0** is an optimal data compressor for a custom
[LZ77/LZSS](https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Storer%E2%80%93Szymanski)
based compression format, that provides a tradeoff between high compression
ratio, and extremely simple fast decompression. Therefore it's especially
appropriate for low-end platforms, including 8-bit computers like the ZX
Spectrum.

## File Format

The **ZX0** compressed format is very simple. There are only 3 types of blocks:

* Literal (copy next N bytes from compressed file)
```
    0  Elias(length)  byte[1]  byte[2]  ...  byte[N]
```

* Copy from last offset (repeat N bytes from last offset)
```
    0  Elias(length)
```

* Copy from new offset (repeat N bytes from new offset)
```
    1  Elias(MSB(offset)+1)  LSB(offset)  Elias(length-1)
```

**ZX0** needs only 1 bit to distinguish between these blocks, because literal
blocks cannot be consecutive, and reusing last offset can only happen after a
literal block. The first block is always a literal, so the first bit is omitted.

The offset MSB and all lengths are stored using interlaced
[Elias Gamma Coding](https://en.wikipedia.org/wiki/Elias_gamma_coding). When
offset MSB equals 256 it means EOF. The offset LSB is stored using 7 bits 
instead of 8, because it produces better results in most practical cases.

## License

The **ZX0** data compression format and algorithm was designed and implemented
by **Einar Saukas**. Special thanks to **introspec/spke** for several
suggestions and improvements, and together with **uniabis** for providing the
"Fast" decompressor. Also special thanks to **Urusergi** for additional ideas
and improvements.

The optimal C compressor is available under the "BSD-3" license. In practice,
this is relevant only if you want to modify its source code and/or incorporate
the compressor within your own products. Otherwise, if you just execute it to
compress files, you can simply ignore these conditions.

The decompressors can be used freely within your own programs (either for the
ZX Spectrum or any other platform), even for commercial releases. The only
condition is that you must indicate somehow in your documentation that you have
used **ZX0**.

