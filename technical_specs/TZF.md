# TZF Wrapper Start of File
 - 0x4 bytes
 - little endian
 - size of uncompressed file in hex
 
example:
F7 48 00 00

indicates a filesize of 48F7h, or 18679 bytes

----

# TZF Header Magic Bytes
 - 0x2 bytes
 - constant
 
example:
78 5E

this lets the game engine or other programs know what file format is being used

----

# Compressed Data Object
 - raw DEFLATE compression used
 - seemingly uneffected by zlib version / deflate algorithm used
 
example:
too large and im not providing a save file for the game

# IMPORTANT
For later steps, you will need to calculate the CRC32 of the file with the Start of File, magic bytes, and compressed data as a single array of bytes or solid file.

----

# TZF Marker Bytes
 - 0x16 bytes
 - little endian
 - stupid
 - constant
 
example:
EF BE AD DE AF DE ED FE

it is always FEEDDEAF and DEADBEEF

----

# Integrity Checksum Hash
 - 0x4 bytes
 - little endian
 - bitwise NOT of CRC32
 
example: 
8A 85 17 27

CRC32 value of D8E87A75 gets bitwise NOT'd (2717858A), then formatted to little endian for the final byte values

----

# End of File Termination Sequence
 - 0x4 bytes
 - little endian
 - constant
 
example:
02 00 00 00

is always these bytes. can also be written as a uint32 with a value of 2 in little endian

----

# Additional Notes

If you manage to find a file with different values than what i have listed as contant, please notify me