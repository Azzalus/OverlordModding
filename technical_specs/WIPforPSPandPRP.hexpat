#include <std/mem.pat>
#include <std/io.pat>
#include <std/string.pat>

//Define globally used variables
u32 container_format @ 0x04;
u32 rootObjectUID @ 0x08;
u32 dataSize @ 0x0C;
u32 bodyEnd = 0xB0 + dataSize;

// Define the custom structure of your file
struct RPKHeader {
    char magic[0x04];
    u16 containerFormat;   // format id; non-zero means it is a container format, 0x00 means standard RPK?
    u16 engineId;          // this is just a guess
    u32 rootObjectUID;     // also just a guess, but a VERY strong guess as its been tested in-game and works
    u32 bodyEnd;
    char FileName[];
    u8 fileNameSize = sizeof(FileName);
    padding[0xB0 - $];
    };
    
struct RPKKeyPair {
    u8 id [[color("FF0000")]];
    u8 value [[color("0000FF")]];
};

// One body record. `offset` is an absolute file offset that always lands inside
// the metadata region of the same file (verified 176/176).
struct RPKRecord {
    u32 slotId [[color("85E3FF")]];
    u32 offset [[color("6EB5FF")]];
};
    
struct BodyInner {
    u8 keypairSize [[color("FFABAB")]];
    if (keypairSize >= 0x80) {
        u32 arraySize [[color("F6A6FF")]];
            u16 keyPairs = (keypairSize & 0x7F);
        RPKKeyPair pairs[keyPairs];
        RPKRecord records[arraySize];
        u32 objectUID; //incorrect at 24A, is actually num of u16 then terminated by null and back to beginning of bodyInner. structure depends on something else?
        u32 stringSize;
        char objectName[stringSize];
    }
    else {
    // leaf frame - everything up to the end of the body is payload.
        if ($ < bodyEnd) {
            padding[bodyEnd - $];
        }
    }

};

struct RPKBody {
    BodyInner BodyInner;//[while($ < bodyEnd)];  // commented out until structures are completely defined so loop wont crash
    BodyInner BodyInner2;//[while($ < bodyEnd)];  // commented out until structures are completely defined so loop wont crash

};

struct Container {
    u64 DEADBEEF @ bodyEnd;
    u32 crcCheck @ bodyEnd+0x08;
    u32 eofSequence @ bodyEnd+0x0C; 

};


RPKHeader Header @ 0x00;
RPKBody Body @ 0xB0;
if (container_format != 0) {
    Container Container;
};