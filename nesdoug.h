//Written by Doug Fraker 2018
// v 1.01

// Why am I doing so much with a vram_buffer? This is an automated system, which
// works when the screen is on. You can write to the buffer at any time. 
// During NMI / v-blank, it automatically writes to the PPU. 
// You don't have to worry about timing those writes. And, more importantly, 
// you shouldn't have to turn the screen off...
// allowing us to make smooth scrolling games.


void set_vram_buffer(void);
// sets the vram update to point to the vram_buffer. VRAM_BUF defined in crt0.s
// this can be undone by set_vram_update(NULL)


void __fastcall__ one_vram_buffer(unsigned char data, int ppu_address);
// to push a single byte write to the vram_buffer


void __fastcall__ multi_vram_buffer_horz(const char * data, unsigned char len, int ppu_address);
// to push multiple writes as one sequential horizontal write to the vram_buffer


void __fastcall__ multi_vram_buffer_vert(const char * data, unsigned char len, int ppu_address);
// to push multiple writes as one sequential vertical write to the vram_buffer

void clear_vram_buffer(void);
// just sets the index into the vram buffer to zero
// this should be done at the beginning of each frame, if using the vram_buffer

void gray_line(void);
// For debugging. Insert at the end of the game loop, to see how much frame is left.
// Will print a gray line on the screen. Distance to the bottom = how much is left.
// No line, possibly means that you are in v-blank.


#define high_byte(a) *((unsigned char*)&a+1)
#define low_byte(a) *((unsigned char*)&a)
// for getting or modifying just 1 byte of an int

#define POKE(addr,val)     (*(unsigned char*) (addr) = (val))
#define PEEK(addr)         (*(unsigned char*) (addr))
// examples
// POKE(0xD800, 0x12); // stores 0x12 at address 0xd800, useful for hardware registers
// B = PEEK(0xD800); // read a value from address 0xd800, into B, which should be a char


void seed_rng(void);
// get from the frame count. You can use a button (start on title screen) to trigger
