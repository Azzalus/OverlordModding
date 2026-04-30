# RPK Header Magic Bytes
 - 0x4 bytes
 - constant
 
example:

52 50 4B 00

Is always the same RPK\0 

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

this ID might be a global reference (not verified) ID so any files that require the character succubus will use this id to refer to it. (possibly)
this ID can also be 00 00 00 00 to default/reference the first object encountered. replacing 00 00 00 00 with the ID of the first object is functionally equivalent from my very limited testing

# IMPORTANT

RPK's are somewhat documented by the AoW3 modding guides. RPK's supposedly build off eachother, but references are ONE WAY ONLY. any RPK that is referenced inside another RPK is a DEPENDENCY, and the engine will walk through every dependency and crash if it finds an infinite loop of two files depending on eachother

it remains to be seen if this is also true for Overlord or not

----

# Filesize Excluding Header and Integrity Check
 - 0x4 bytes
 - little endian

example:

D8 13 59 00

the total rpk file would be 591488, and B0 of that would be header. 591488-B0 = 5913D8

----

# Internal File Name
 - ASCII string
 - can have whitespace
 - can be surprisingly large
 
example:

Character Red Cloak

note: this string is immediately followed by null padding. it is unknown if some of these terminate this specific string or not

----

# Null Padding
 - is literally just 00
 - always fills up to B0

example:

im not giving an example. if you want one, open any prp file in a hex editor

----

# Object Index Identifier
0x1 byte internal engine structure type  //example 0x81. 
//each one is structured slightly differently with different data and i dont have access to the engine itself or debugging data to list all the types or figure out structures.
0x4 bytes size - amount of entries that are 8 bytes long
0x2 bytes repeated - unknown numbers of some sort counting upwards, possibly id's or something. once a 00 00 is encountered, the previous 2 bytes is the start of the 8 byte entries
0x8 bytes of unknown data, repeating (entries\*) amount as dictated earlier
dependency ID and load order?
{4 bytes entry number? (always ascending), 4 bytes entry offset? (always ascending) }

//indeterminate data

0x4 identifier
0x4 string char count
0x?? ascii string determined by previous bytes




----

# RPK Ending Sequence

the actual RPK format just ends after listing some strings. there is no terminator, no integrity check, nothing. it just ends. anything that comes after this is part of the container file formats like prp, psp, etc.

example:
MAPEDITOR.CLB....SYSTEM_CORE_ENTITIES.RPK....GLOBAL_SCRIPTS.RPK(file ends abruptly)

----

# IF ITS A CONTAINER FORMAT THESE WILL BE INCLUDED

# Integrity Check Marker Bytes
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

CRC32 value of the file (with header) D8E87A75 gets bitwise NOT'd (2717858A), then formatted to little endian for the final byte values

----

# End of File Termination Sequence
 - 0x4 bytes
 - little endian
 - constant based on load order? requires more info
 
example:
02 00 00 00

can also be written as a uint32 with a value of 2 in little endian

----

# Additional Notes

If you manage to find a file with different values than what i have listed as contant, please notify me




B0 bytes = header
0x4 bytes RPK\0 = magic bytes
0x4 bytes ! possible internal filename size
06 00 46 00 = prp
07 00 46 00 = psp
0x4 bytes UID?
0x4 bytes total on disk filesize
internal filename
00 padding buffer
B1 = raw datastream




//------------------------------------------------
//--- 010 Editor v14.0.1 Binary Template
//
//      File: RPK
//   Authors: OLM
//   Version: 0.01
//   Purpose: figuring this shit out
//  Category: 
// File Mask: RPK
//  ID Bytes: 52 50 4B 00
//   History: 
//------------------------------------------------
LittleEndian();

typedef uint32 RPK_UID <format=hex>;         // Object unique identifier
typedef uint32 RPK_EntryNumber <format=hex>; // Local to current array/index, are reused in subsequent arrays/indexes
typedef uint32 StringLength <format=hex>;    // Generic string length size


typedef struct RPK_Header {
    local int headersize=176;
    char magic[4] <bgcolor=cBlack>;
    uint16 filetype_id;
    uint16 engine_id;
    RPK_UID root_uid <bgcolor=cRed>;
    uint32 data_size <format=hex>;
    char filename[] <bgcolor=cBlue>;
    local int paddingsize = headersize-sizeof(filename)-16;
    char padding[paddingsize];
} headerInfo <bgcolor=cLtBlue>;

typedef struct RPK_IndexEntry {
    uint32        offset <format=hex>;
    RPK_EntryNumber entry_num;     // actually unsure if this is an offset, however im not sure what else it could be
} RPK_IndexEntry;

typedef struct RPK_IndexTable {
    ubyte      arrayObjectType;
    uint32     array_size <format=hex>;
    uint16     required;
    local int i;
    local short bytevalue;
    for( i=0; i<5; i++)
    {
       bytevalue = ReadUShort(FTell());
       if (bytevalue != (bytevalue & 0x00FF)) // After 13 00 as soon as the low byte is 00 again, it is part of the array and not the vector
       {
           uint16 required2;
       }
       else
       {
           break;
       }
     }
    RPK_IndexEntry indexentry[array_size];
} IndexTable <bgcolor=cLtGreen>;

typedef struct RPK_String {
    StringLength length <bgcolor=cLtBlue>;
    ubyte  data[length] <bgcolor=cBlue>;
} RPK_String;

typedef struct RPK_ObjectHeader {
    RPK_UID    object_uid;
    RPK_String object_string;
} RPK_ObjectHeader;

struct RPK {
    RPK_Header header <bgcolor=cLtBlue>;
    local int filesize;
    filesize = (FileSize()-sizeof(header));
    local int bytevalue;
    local int position;
    local int bytebuffer;
    while (!FEof())
    {
        bytevalue = ReadByte();
        if (bytevalue != (bytevalue | 0x80))
        {
            break;
        }
        position = (FTell()+1);
        bytebuffer = ReadInt(position);
        if (bytebuffer != bytebuffer & 0x0000FFFF) 
        {
            break;
        }
        RPK_IndexTable indexTable <bgcolor=cLtGreen>;
        RPK_ObjectHeader indexObject <bgcolor=cRed>;
    }
    local int debugvar;
    debugvar = FEof();
    Printf("value is %d", debugvar);
} RPK_file;
