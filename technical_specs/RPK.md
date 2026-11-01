# RPK Header Magic Bytes
 - 0x4 bytes
 - constant
 
example:

52 50 4B 00

Is always the same "RPK\0"

----

# RPK Internal File type ID
 - 0x4 bytes
 - constant

example:

00 06 00 46 = prp

00 07 00 46 = psp

1A 00 00 04 = AoW3 rpk

this lets the game engine know how to load the file. they are all technically rpk's, but prp and psp and others are containers that add integrity checks

----

# Root Object UID
 - 0x4 bytes
 - little endian
 - Different for every single file and must be globally unique

example:

5F 00 00 00 in Character Succubus.prp

this ID can also be 00 00 00 00 to default/reference the first object encountered. replacing 00 00 00 00 with the ID of the first object is functionally equivalent and verified in-game
this ID might be a global reference ID so any files that require the character succubus will use this id to refer to it. (needs verified)

# IMPORTANT

RPK's are somewhat documented by the AoW3 modding guides. RPK's supposedly build off eachother, but references are ONE WAY ONLY. any RPK that is referenced inside another RPK is a DEPENDENCY, and the engine will walk through every dependency and crash if it finds an infinite loop of two files depending on eachother

it remains to be seen if this is also true for Overlord or not

----

# RPK Body Size
 - 0x4 bytes
 - little endian

example:

D8 13 59 00

the total rpk file would be 591488, and B0 of that would be header. 591488-B0 = 5913D8. add an extra 0x10 of trailer if container format.

----

# Internal File Name
 - variable length ASCII string, null terminated
 - can have whitespace
 - can be surprisingly large, usually matches filename but can be different (reference aow3 system.rpk calling itself "NONAME.RPK" internally)
 
example:

Character Red Cloak

note: this string is immediately followed by null padding. it is unknown if the null actually terminates the string, or if it just reads all bytes until 0xB0 and discards all null bytes. needs manually checked

----

# Null Padding
 - is literally just 0x00 repeating
 - always fills up to B0 which is the end of the header

example:

im not giving an example. if you want one, open any prp or rpk file in a hex editor

----

# Frame Descriptor
 - 0x1 byte
 - highest bit determines if the current frame structure contains a record array
 - 0x80 | n, where n = number of id/offset pairs that follow
 - below 0x80 = leaf frame: still n pairs, but no record array

example:

83    //0x80|3 = three pairs follow - system.psp offset 0xB0

----

# Record Count
 - 0x4 bytes
 - u32 integer
 - multiply by 8 bytes to calculate full size of record array

example:

2E 00 00 00    //46 records total. 2Eh\*8h=170h

----

# ID and Offset Pairs    //the mapping
 - n x 2 bytes
 - byte 1 = field id, byte 2 = relative and cumulative end offset inside the current frame blob
 - first id always ends at 0 offset. unsure what this means for the first id yet.

example:

13 00    //id 0x13 ends at 0 -> zero-length slot
16 04    //id 0x16 ends at 4 -> id 16 owns bytes 0..4
17 0E    //id 0x17 ends at 0x0E -> id 17 owns bytes 4..0x0E

note: each id means something specific to the engine, 16 seems to consistently be the uid and 17 is consistently the strlen and ascii string as two examples. there will be a table with ids and best guess as to what they mean at the bottom of this file.
also note: im unsure if this meaning is always constant or if it changes depending on environment / earlier file data and the consistency is mere coincidence. it could just be load order for predefined engine functions. really no way to know without heavy testing.

----

# Record Array
 - size is earlier count x 8 bytes
 - 0x4 bytes u32 id followed by 0x4 bytes u32 absolute file offset, repeating
 - these ids continue the ascending run started by the pairs
 - these offsets are absolute file offsets, but they do NOT point at frame starts, and they also seem to be in ascending order

example:

18 00 00 00 4E A3 26 00    //id 0x18 -> file offset 0x26A34E - system.psp 0xBB
5B 00 00 00 47 12 59 00    //id 0x5B -> 0x591247, last of 46 - system.psp 0x223

----

# Variable Data
 - entirely determined by the previous ids and offsets, and what the id's represent
 - if id's are not always constant, then determined by an engine loading function. more data needed to be definitive

note: i have seen what i assume is padding between frames of 0x01 0x01 0x00 0x00 0x01 0x01 0x00 0x00 infinitely repeating. this is usually used for alignment purposes from what i can tell. if you come across bytes like "01 00 00" outside frames with no other explanation and in seemingly random byte amounts, it might be alignment padding.

----

# Following Frames
 - all frames should follow the same basic structure
 - frames should continue until the end of the RPK body  //educated guess. either this or unless something else defines the structure like an engine loading function. need more/better info before looking into this

example:

82 
01 00 00 00 
14 00 15 06 
1E 00 00 00 0B A1 26 00 
02 00 00 00 31 35

//0x82 (2 pairs), 1 record, {0x1E -> 0x26A10B}, 6 byte blob "15" - system.psp 0x239
    
----

# RPK Body Ending Sequence
- there is no terminator, no integrity check, nothing. it just ends. anything that comes after this is part of a container file format like prp, psp, etc.

example:
MAPEDITOR.CLB....SYSTEM_CORE_ENTITIES.RPK....GLOBAL_SCRIPTS.RPK(file ends abruptly, no termination sequence)


note: it ends exactly where the header says so. RPK Body Size + B0 (Header Size) = total file length

----

# IF ITS A CONTAINER FORMAT THESE TRAILINGS WILL BE INCLUDED

# Integrity Check Marker Bytes
 - 0x8 bytes
 - stupid
 - constant
 
example:
EF BE AD DE AF DE ED FE

it is always FEEDDEAF and DEADBEEF

----

# Integrity Checksum Hash
 - 0x4 bytes
 - bitwise NOT of CRC32
 
example: 
8A 85 17 27

CRC32 value of the rpk file (including header, excluding container format trailings) D8E87A75 gets bitwise NOT'd (2717858A). this is confirmed and verified

----

# End of File Termination Sequence
 - 0x4 bytes
 - little endian
 - constant based on load order? requires more info
 
example:
02 00 00 00

i havent seen any values other than 2. if you see any others let me know so i can look at it

----

# Additional Notes

best guesses at what the id's in the id/offset pair means:

| 0x12 | empty | 1 file only |
| 0x13 | empty | the usual first slot |
| 0x14 | u32 | small ints; empty in about 45% of appearances |
| 0x15 | len + ASCII | numeric id or tagged path |
| 0x16 | u32 | uid, = header uid |
| 0x17 | len + ASCII | name |
| 0x18-0x1A | unknown | |
| 0x1B | u32 | only 0x00000101 seen |
| 0x1C | u32 or path string | ambiguous |
| 0x1D | byte | payload only |
| 0x1E | 1 byte / 4 bytes | differs by frame kind |
| 0x1F-0x22 | unknown | |
| 0x23, 0x24 | unknown | one file each |
| 0x25-0x28 | record slots only | never seen in a pair list |
| 0x3C-0x5B | record slots only | system.psp only |

big chance that these are very wrong, but having any kind of basis is still helpful until i learn more about the exact definitive structure