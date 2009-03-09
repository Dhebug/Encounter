
/*
 *	6502_opcodes.c - 6502 Opcodes and symbols decoder
 *	(c) 2007 Jean-Yves Lamoureux
 *
 *  This program is free software; you can redistribute it and/or modify it under
 *  the terms of version 2 of the GNU General Public License as published by the
 *  Free Software Foundation.
 *
 *  This program is distributed in the hope that it will be useful, but WITHOUT
 *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 *  FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along with
 *  this program; if not, write to the Free Software Foundation, Inc., 59 Temple
 *  Place, Suite 330, Boston, MA 02111-1307, USA.
 *
 */


#define IMPLIED    0
#define IMMEDIATE  1
#define ABSOLUTE   2
#define ZEROPAGE   3
#define RELATIVE   4
#define ABSOLUTE_X 5
#define ABSOLUTE_Y 6
#define ZEROPAGE_X 7
#define ZEROPAGE_Y 8
#define INDIRECT_X 9
#define INDIRECT_Y 10
#define INDIRECT   11

typedef struct sSym_
{
    char     name[256];
}sSym;

typedef struct opcode_
{
    uint8_t size;
    uint8_t op[10];
    uint8_t mode;
}opcode;

opcode opcodes[0xFF];
sSym symbolTable[0xFFFF]; // Should be enough :)


uint32_t decode_implied(uint8_t *ptr, char *str, uint16_t pc)
{
    sprintf(str, "%s", opcodes[ptr[0]].op);
    return 1;
}
uint32_t decode_immediate(uint8_t *ptr, char *str, uint16_t pc)
{
    sprintf(str, "%s $%02X", opcodes[ptr[0]].op, ptr[1]);
    return 2;
}
uint32_t decode_absolute(uint8_t *ptr, char *str, uint16_t pc)
{
    uint16_t a = ptr[2]<<8 | ptr[1];

    if(symbolTable[a].name[0] == 0)
        sprintf(str, "%s $%04X", opcodes[ptr[0]].op, a);
    else
        sprintf(str, "%s %s", opcodes[ptr[0]].op, symbolTable[a].name);

    return 3;
}
uint32_t decode_zeropage(uint8_t *ptr, char *str, uint16_t pc)
{
    uint16_t a = ptr[1];

    if(symbolTable[a].name[0] == 0)
        sprintf(str, "%s $%02X", opcodes[ptr[0]].op, a);
    else
        sprintf(str, "%s %s", opcodes[ptr[0]].op, symbolTable[a].name);

    return 3;
}
uint32_t decode_relative(uint8_t *ptr, char *str, uint16_t pc)
{
    uint16_t a = (((int8_t)ptr[1])+(pc));

    if(symbolTable[a].name[0] == 0)
        sprintf(str, "%s $%04X", opcodes[ptr[0]].op, a);
    else
        sprintf(str, "%s %s", opcodes[ptr[0]].op, symbolTable[a].name);

    return 2;
}
uint32_t decode_absolute_x(uint8_t *ptr, char *str, uint16_t pc)
{
    uint16_t a = ptr[2]<<8 | ptr[1];

    if(symbolTable[a].name[0] == 0)
        sprintf(str, "%s $%04X[X]", opcodes[ptr[0]].op, a);
    else
        sprintf(str, "%s %s[X]", opcodes[ptr[0]].op, symbolTable[a].name);

    return 3;
}
uint32_t decode_absolute_y(uint8_t *ptr, char *str, uint16_t pc)
{
    uint16_t a = ptr[2]<<8 | ptr[1];

    if(symbolTable[a].name[0] == 0)
        sprintf(str, "%s $%04X[Y]", opcodes[ptr[0]].op, a);
    else
        sprintf(str, "%s %s[Y]", opcodes[ptr[0]].op, symbolTable[a].name);


    return 3;
}
uint32_t decode_zeropage_x(uint8_t *ptr, char *str, uint16_t pc)
{
    uint16_t a = ptr[1];

    if(symbolTable[a].name[0] == 0)
        sprintf(str, "%s $%02X[X]", opcodes[ptr[0]].op, a);
    else
        sprintf(str, "%s %s[X]", opcodes[ptr[0]].op, symbolTable[a].name);

    return 2;
}
uint32_t decode_zeropage_y(uint8_t *ptr, char *str, uint16_t pc)
{
    uint16_t a = ptr[1];

    if(symbolTable[a].name[0] == 0)
        sprintf(str, "%s $%02X[Y]", opcodes[ptr[0]].op, a);
    else
        sprintf(str, "%s %s[Y]", opcodes[ptr[0]].op, symbolTable[a].name);

    return 2;
}
uint32_t decode_indirect_x(uint8_t *ptr, char *str, uint16_t pc)
{
    uint16_t a = ptr[2]<<8 | ptr[1];

    if(symbolTable[a].name[0] == 0)
        sprintf(str, "%s $%04X[X]", opcodes[ptr[0]].op, a);
    else
        sprintf(str, "%s %s[Y]", opcodes[ptr[0]].op, symbolTable[a].name);

    return 3;
}
uint32_t decode_indirect_y(uint8_t *ptr, char *str, uint16_t pc)
{

    uint16_t a = ptr[2]<<8 | ptr[1];

    if(symbolTable[a].name[0] == 0)
        sprintf(str, "%s $%04X[Y]", opcodes[ptr[0]].op, a);
    else
        sprintf(str, "%s %s[y]", opcodes[ptr[0]].op, symbolTable[a].name);

    return 3;
}
uint32_t decode_indirect(uint8_t *ptr, char *str, uint16_t pc)
{
    uint16_t a = ptr[2]<<8 | ptr[1];

    if(symbolTable[a].name[0] == 0)
        sprintf(str, "%s [$%04X]", opcodes[ptr[0]].op, a);
    else
        sprintf(str, "%s [%s]", opcodes[ptr[0]].op, symbolTable[a].name);

    return 3;
}

typedef uint32_t (*decodeF)(uint8_t *ptr, char *str, uint16_t pc);

decodeF decode[12];



void gen_opcodes(void)
{
    decode[IMPLIED] = decode_implied;
    decode[IMMEDIATE] = decode_immediate;
    decode[ABSOLUTE] = decode_absolute;
    decode[ZEROPAGE] = decode_zeropage;
    decode[RELATIVE] = decode_relative;
    decode[ABSOLUTE_X] = decode_absolute_x;
    decode[ABSOLUTE_Y] = decode_absolute_y;
    decode[ZEROPAGE_X] = decode_zeropage_x;
    decode[ZEROPAGE_Y] = decode_zeropage_y;
    decode[INDIRECT_X] = decode_indirect_x;
    decode[INDIRECT_Y] = decode_indirect_y;
    decode[INDIRECT] =   decode_indirect;


    opcodes[0x00].size = 1; memcpy(opcodes[0x00].op, "BRK", 4);    opcodes[0x00].mode = IMPLIED;
    opcodes[0x01].size = 2; memcpy(opcodes[0x01].op, "ORA", 4);    opcodes[0x01].mode = INDIRECT_X;
    opcodes[0x02].size = 1; memcpy(opcodes[0x02].op, "", 4);       opcodes[0x02].mode = IMPLIED;
    opcodes[0x03].size = 1; memcpy(opcodes[0x03].op, "", 4);       opcodes[0x03].mode = IMPLIED;
    opcodes[0x04].size = 1; memcpy(opcodes[0x04].op, "", 4);       opcodes[0x04].mode = IMPLIED;
    opcodes[0x05].size = 2; memcpy(opcodes[0x05].op, "ORA", 4);    opcodes[0x05].mode = ZEROPAGE;
    opcodes[0x06].size = 2; memcpy(opcodes[0x06].op, "ASL", 4);    opcodes[0x06].mode = ZEROPAGE;
    opcodes[0x07].size = 1; memcpy(opcodes[0x07].op, "", 4);       opcodes[0x07].mode = IMPLIED;
    opcodes[0x08].size = 1; memcpy(opcodes[0x08].op, "PHP", 4);    opcodes[0x08].mode = IMPLIED;
    opcodes[0x09].size = 2; memcpy(opcodes[0x09].op, "ORA", 4);    opcodes[0x09].mode = IMMEDIATE;
    opcodes[0x0A].size = 1; memcpy(opcodes[0x0A].op, "ASL", 4);    opcodes[0x0A].mode = IMPLIED;
    opcodes[0x0B].size = 1; memcpy(opcodes[0x0B].op, "", 4);       opcodes[0x0B].mode = IMPLIED;
    opcodes[0x0C].size = 1; memcpy(opcodes[0x0C].op, "", 4);       opcodes[0x0C].mode = IMPLIED;
    opcodes[0x0D].size = 3; memcpy(opcodes[0x0D].op, "ORA", 4);    opcodes[0x0D].mode = ABSOLUTE;
    opcodes[0x0E].size = 3; memcpy(opcodes[0x0E].op, "ASL", 4);    opcodes[0x0E].mode = ABSOLUTE;
    opcodes[0x0F].size = 1; memcpy(opcodes[0x0F].op, "", 4);       opcodes[0x0F].mode = IMPLIED;
    opcodes[0x10].size = 2; memcpy(opcodes[0x10].op, "BPL", 4);    opcodes[0x10].mode = RELATIVE;
    opcodes[0x11].size = 2; memcpy(opcodes[0x11].op, "ORA", 4);    opcodes[0x11].mode = INDIRECT_Y;
    opcodes[0x12].size = 1; memcpy(opcodes[0x12].op, "", 4);       opcodes[0x12].mode = IMPLIED;
    opcodes[0x13].size = 1; memcpy(opcodes[0x13].op, "", 4);       opcodes[0x13].mode  =IMPLIED;
    opcodes[0x14].size = 1; memcpy(opcodes[0x14].op, "", 4);       opcodes[0x14].mode = IMPLIED;
    opcodes[0x15].size = 2; memcpy(opcodes[0x15].op, "ORA", 4);    opcodes[0x15].mode = ZEROPAGE_X;
    opcodes[0x16].size = 2; memcpy(opcodes[0x16].op, "ASL", 4);    opcodes[0x16].mode = ZEROPAGE_X;
    opcodes[0x17].size = 1; memcpy(opcodes[0x17].op, "", 4);       opcodes[0x17].mode = IMPLIED;
    opcodes[0x18].size = 1; memcpy(opcodes[0x18].op, "CLC", 4);    opcodes[0x18].mode = IMPLIED;
    opcodes[0x19].size = 3; memcpy(opcodes[0x19].op, "ORA", 4);    opcodes[0x19].mode = ABSOLUTE_Y;
    opcodes[0x1A].size = 1; memcpy(opcodes[0x1A].op, "", 4);       opcodes[0x1A].mode = IMPLIED;
    opcodes[0x1B].size = 1; memcpy(opcodes[0x1B].op, "", 4);       opcodes[0x1B].mode = IMPLIED;
    opcodes[0x1C].size = 1; memcpy(opcodes[0x1C].op, "", 4);       opcodes[0x1C].mode = IMPLIED;
    opcodes[0x1D].size = 3; memcpy(opcodes[0x1D].op, "ORA", 4);    opcodes[0x1D].mode = ABSOLUTE_X;
    opcodes[0x1E].size = 3; memcpy(opcodes[0x1E].op, "ASL", 4);    opcodes[0x1E].mode = ABSOLUTE_X;
    opcodes[0x1F].size = 1; memcpy(opcodes[0x1F].op, "", 4);       opcodes[0x1F].mode = IMPLIED;
    opcodes[0x20].size = 3; memcpy(opcodes[0x20].op, "JSR", 4);    opcodes[0x20].mode = ABSOLUTE;
    opcodes[0x21].size = 2; memcpy(opcodes[0x21].op, "AND", 4);    opcodes[0x21].mode = INDIRECT_X;
    opcodes[0x22].size = 1; memcpy(opcodes[0x22].op, "", 4);       opcodes[0x22].mode = IMPLIED;
    opcodes[0x23].size = 1; memcpy(opcodes[0x23].op, "", 4);       opcodes[0x23].mode = IMPLIED;
    opcodes[0x24].size = 2; memcpy(opcodes[0x24].op, "BIT", 4);    opcodes[0x24].mode = ZEROPAGE;
    opcodes[0x25].size = 2; memcpy(opcodes[0x25].op, "AND", 4);    opcodes[0x25].mode = ZEROPAGE;
    opcodes[0x26].size = 2; memcpy(opcodes[0x26].op, "ROL", 4);    opcodes[0x26].mode = ZEROPAGE;
    opcodes[0x27].size = 1; memcpy(opcodes[0x27].op, "", 4);       opcodes[0x27].mode = IMPLIED;
    opcodes[0x28].size = 1; memcpy(opcodes[0x28].op, "PLP", 4);    opcodes[0x28].mode = IMPLIED;
    opcodes[0x29].size = 2; memcpy(opcodes[0x29].op, "AND", 4);    opcodes[0x29].mode = IMMEDIATE;
    opcodes[0x2A].size = 1; memcpy(opcodes[0x2A].op, "ROL", 4);    opcodes[0x2A].mode = IMPLIED;
    opcodes[0x2B].size = 1; memcpy(opcodes[0x2B].op, "", 4);       opcodes[0x2B].mode = IMPLIED;
    opcodes[0x2C].size = 3; memcpy(opcodes[0x2C].op, "BIT", 4);    opcodes[0x2C].mode = ABSOLUTE;
    opcodes[0x2D].size = 3; memcpy(opcodes[0x2D].op, "AND", 4);    opcodes[0x2D].mode = ABSOLUTE;
    opcodes[0x2E].size = 3; memcpy(opcodes[0x2E].op, "ROL", 4);    opcodes[0x2E].mode = ABSOLUTE;
    opcodes[0x2F].size = 1; memcpy(opcodes[0x2F].op, "", 4);       opcodes[0x2F].mode = IMPLIED;
    opcodes[0x30].size = 2; memcpy(opcodes[0x30].op, "BMI", 4);    opcodes[0x30].mode = RELATIVE;
    opcodes[0x31].size = 2; memcpy(opcodes[0x31].op, "AND", 4);    opcodes[0x31].mode = INDIRECT_Y;
    opcodes[0x32].size = 1; memcpy(opcodes[0x32].op, "", 4);       opcodes[0x32].mode = IMPLIED;
    opcodes[0x33].size = 1; memcpy(opcodes[0x33].op, "", 4);       opcodes[0x33].mode = IMPLIED;
    opcodes[0x34].size = 1; memcpy(opcodes[0x34].op, "", 4);       opcodes[0x34].mode = IMPLIED;
    opcodes[0x35].size = 2; memcpy(opcodes[0x35].op, "AND", 4);    opcodes[0x35].mode = ZEROPAGE_X;
    opcodes[0x36].size = 2; memcpy(opcodes[0x36].op, "ROL", 4);    opcodes[0x36].mode = ZEROPAGE_X;
    opcodes[0x37].size = 1; memcpy(opcodes[0x37].op, "", 4);       opcodes[0x37].mode = IMPLIED;
    opcodes[0x38].size = 1; memcpy(opcodes[0x38].op, "SEC", 4);    opcodes[0x38].mode = IMPLIED;
    opcodes[0x39].size = 3; memcpy(opcodes[0x39].op, "AND", 4);    opcodes[0x39].mode = ABSOLUTE_Y;
    opcodes[0x3A].size = 1; memcpy(opcodes[0x3A].op, "", 4);       opcodes[0x3A].mode = IMPLIED;
    opcodes[0x3B].size = 1; memcpy(opcodes[0x3B].op, "", 4);       opcodes[0x3B].mode = IMPLIED;
    opcodes[0x3C].size = 1; memcpy(opcodes[0x3C].op, "", 4);       opcodes[0x3C].mode = IMPLIED;
    opcodes[0x3D].size = 3; memcpy(opcodes[0x3D].op, "AND", 4);    opcodes[0x3D].mode = ABSOLUTE_X;
    opcodes[0x3E].size = 3; memcpy(opcodes[0x3E].op, "ROL", 4);    opcodes[0x3E].mode = ABSOLUTE_X;
    opcodes[0x3F].size = 1; memcpy(opcodes[0x3F].op, "", 4);       opcodes[0x3F].mode = IMPLIED;
    opcodes[0x40].size = 1; memcpy(opcodes[0x40].op, "RTI", 4);    opcodes[0x40].mode = IMPLIED;
    opcodes[0x41].size = 2; memcpy(opcodes[0x41].op, "EOR", 4);    opcodes[0x41].mode = INDIRECT_X;
    opcodes[0x42].size = 1; memcpy(opcodes[0x42].op, "", 4);       opcodes[0x42].mode = IMPLIED;
    opcodes[0x43].size = 1; memcpy(opcodes[0x43].op, "", 4);       opcodes[0x43].mode = IMPLIED;
    opcodes[0x44].size = 1; memcpy(opcodes[0x44].op, "", 4);       opcodes[0x44].mode = IMPLIED;
    opcodes[0x45].size = 2; memcpy(opcodes[0x45].op, "EOR", 4);    opcodes[0x45].mode = ZEROPAGE;
    opcodes[0x46].size = 2; memcpy(opcodes[0x46].op, "LSR", 4);    opcodes[0x46].mode = ZEROPAGE;
    opcodes[0x47].size = 1; memcpy(opcodes[0x47].op, "", 4);       opcodes[0x47].mode = IMPLIED;
    opcodes[0x48].size = 1; memcpy(opcodes[0x48].op, "PHA", 4);    opcodes[0x48].mode = IMPLIED;
    opcodes[0x49].size = 2; memcpy(opcodes[0x49].op, "EOR", 4);    opcodes[0x49].mode = IMMEDIATE;
    opcodes[0x4A].size = 1; memcpy(opcodes[0x4A].op, "LSR", 4);    opcodes[0x4A].mode = IMPLIED;
    opcodes[0x4B].size = 1; memcpy(opcodes[0x4B].op, "", 4);       opcodes[0x4B].mode = IMPLIED;
    opcodes[0x4C].size = 3; memcpy(opcodes[0x4C].op, "JMP", 4);    opcodes[0x4C].mode = ABSOLUTE;
    opcodes[0x4D].size = 3; memcpy(opcodes[0x4D].op, "EOR", 4);    opcodes[0x4D].mode = ABSOLUTE;
    opcodes[0x4E].size = 3; memcpy(opcodes[0x4E].op, "LSR", 4);    opcodes[0x4E].mode = ABSOLUTE;
    opcodes[0x4F].size = 1; memcpy(opcodes[0x4F].op, "", 4);       opcodes[0x4F].mode = IMPLIED;
    opcodes[0x50].size = 2; memcpy(opcodes[0x50].op, "BVC", 4);    opcodes[0x50].mode = RELATIVE;
    opcodes[0x51].size = 2; memcpy(opcodes[0x51].op, "EOR", 4);    opcodes[0x51].mode = INDIRECT_Y;
    opcodes[0x52].size = 1; memcpy(opcodes[0x52].op, "", 4);       opcodes[0x52].mode = IMPLIED;
    opcodes[0x53].size = 1; memcpy(opcodes[0x53].op, "", 4);       opcodes[0x53].mode = IMPLIED;
    opcodes[0x54].size = 1; memcpy(opcodes[0x54].op, "", 4);       opcodes[0x54].mode = IMPLIED;
    opcodes[0x55].size = 2; memcpy(opcodes[0x55].op, "EOR", 4);    opcodes[0x55].mode = ZEROPAGE_X;
    opcodes[0x56].size = 2; memcpy(opcodes[0x56].op, "LSR", 4);    opcodes[0x56].mode = ZEROPAGE_X;
    opcodes[0x57].size = 1; memcpy(opcodes[0x57].op, "", 4);       opcodes[0x57].mode = IMPLIED;
    opcodes[0x58].size = 1; memcpy(opcodes[0x58].op, "CLI", 4);    opcodes[0x58].mode = IMPLIED;
    opcodes[0x59].size = 3; memcpy(opcodes[0x59].op, "EOR", 4);    opcodes[0x59].mode = ABSOLUTE_Y;
    opcodes[0x5A].size = 1; memcpy(opcodes[0x5A].op, "", 4);       opcodes[0x5A].mode = IMPLIED;
    opcodes[0x5B].size = 1; memcpy(opcodes[0x5B].op, "", 4);       opcodes[0x5B].mode = IMPLIED;
    opcodes[0x5C].size = 1; memcpy(opcodes[0x5C].op, "", 4);       opcodes[0x5C].mode = IMPLIED;
    opcodes[0x5D].size = 3; memcpy(opcodes[0x5D].op, "EOR", 4);    opcodes[0x5D].mode = ABSOLUTE_X;
    opcodes[0x5E].size = 3; memcpy(opcodes[0x5E].op, "LSR", 4);    opcodes[0x5E].mode = ABSOLUTE_X;
    opcodes[0x5F].size = 1; memcpy(opcodes[0x5F].op, "", 4);       opcodes[0x5F].mode = IMPLIED;
    opcodes[0x60].size = 1; memcpy(opcodes[0x60].op, "RTS", 4);    opcodes[0x60].mode = IMPLIED;
    opcodes[0x61].size = 2; memcpy(opcodes[0x61].op, "ADC", 4);    opcodes[0x61].mode = INDIRECT_X;
    opcodes[0x62].size = 1; memcpy(opcodes[0x62].op, "", 4);       opcodes[0x62].mode = IMPLIED;
    opcodes[0x63].size = 1; memcpy(opcodes[0x63].op, "", 4);       opcodes[0x63].mode = IMPLIED;
    opcodes[0x64].size = 1; memcpy(opcodes[0x64].op, "", 4);       opcodes[0x64].mode = IMPLIED;
    opcodes[0x65].size = 2; memcpy(opcodes[0x65].op, "ADC", 4);    opcodes[0x65].mode = ZEROPAGE;
    opcodes[0x66].size = 2; memcpy(opcodes[0x66].op, "ROR", 4);    opcodes[0x66].mode = ZEROPAGE;
    opcodes[0x67].size = 1; memcpy(opcodes[0x67].op, "", 4);       opcodes[0x67].mode = IMPLIED;
    opcodes[0x68].size = 1; memcpy(opcodes[0x68].op, "PLA", 4);    opcodes[0x68].mode = IMPLIED;
    opcodes[0x69].size = 2; memcpy(opcodes[0x69].op, "ADC", 4);    opcodes[0x69].mode = IMMEDIATE;
    opcodes[0x6A].size = 1; memcpy(opcodes[0x6A].op, "ROR", 4);    opcodes[0x6A].mode = IMPLIED;
    opcodes[0x6B].size = 1; memcpy(opcodes[0x6B].op, "", 4);       opcodes[0x6B].mode = IMPLIED;
    opcodes[0x6C].size = 3; memcpy(opcodes[0x6C].op, "JMP", 4);    opcodes[0x6C].mode = INDIRECT;
    opcodes[0x6D].size = 3; memcpy(opcodes[0x6D].op, "ADC", 4);    opcodes[0x6D].mode = ABSOLUTE;
    opcodes[0x6E].size = 3; memcpy(opcodes[0x6E].op, "ROR", 4);    opcodes[0x6E].mode = ABSOLUTE;
    opcodes[0x6F].size = 1; memcpy(opcodes[0x6F].op, "", 4);       opcodes[0x6F].mode = IMPLIED;
    opcodes[0x70].size = 2; memcpy(opcodes[0x70].op, "BVS", 4);    opcodes[0x70].mode = RELATIVE;
    opcodes[0x71].size = 2; memcpy(opcodes[0x71].op, "ADC", 4);    opcodes[0x71].mode = INDIRECT_Y;
    opcodes[0x72].size = 1; memcpy(opcodes[0x72].op, "", 4);       opcodes[0x72].mode = IMPLIED;
    opcodes[0x73].size = 1; memcpy(opcodes[0x73].op, "", 4);       opcodes[0x73].mode = IMPLIED;
    opcodes[0x74].size = 1; memcpy(opcodes[0x74].op, "", 4);       opcodes[0x74].mode = IMPLIED;
    opcodes[0x75].size = 2; memcpy(opcodes[0x75].op, "ADC", 4);    opcodes[0x75].mode = ZEROPAGE_X;
    opcodes[0x76].size = 2; memcpy(opcodes[0x76].op, "ROR", 4);    opcodes[0x76].mode = ZEROPAGE_X;
    opcodes[0x77].size = 1; memcpy(opcodes[0x77].op, "", 4);       opcodes[0x77].mode = IMPLIED;
    opcodes[0x78].size = 1; memcpy(opcodes[0x78].op, "SEI", 4);    opcodes[0x78].mode = IMPLIED;
    opcodes[0x79].size = 3; memcpy(opcodes[0x79].op, "ADC", 4);    opcodes[0x79].mode = ABSOLUTE_Y;
    opcodes[0x7A].size = 1; memcpy(opcodes[0x7A].op, "", 4);       opcodes[0x7A].mode = IMPLIED;
    opcodes[0x7B].size = 1; memcpy(opcodes[0x7B].op, "", 4);       opcodes[0x7B].mode = IMPLIED;
    opcodes[0x7C].size = 1; memcpy(opcodes[0x7C].op, "", 4);       opcodes[0x7C].mode = IMPLIED;
    opcodes[0x7D].size = 3; memcpy(opcodes[0x7D].op, "ADC", 4);    opcodes[0x7D].mode = ABSOLUTE_X;
    opcodes[0x7E].size = 3; memcpy(opcodes[0x7E].op, "ROR", 4);    opcodes[0x7E].mode = ABSOLUTE_X;
    opcodes[0x7F].size = 1; memcpy(opcodes[0x7F].op, "", 4);       opcodes[0x7F].mode = IMPLIED;
    opcodes[0x80].size = 1; memcpy(opcodes[0x80].op, "", 4);       opcodes[0x80].mode = IMPLIED;
    opcodes[0x81].size = 2; memcpy(opcodes[0x81].op, "STA", 4);    opcodes[0x81].mode = INDIRECT_X;
    opcodes[0x82].size = 1; memcpy(opcodes[0x82].op, "", 4);       opcodes[0x82].mode = IMPLIED;
    opcodes[0x83].size = 1; memcpy(opcodes[0x83].op, "", 4);       opcodes[0x83].mode = IMPLIED;
    opcodes[0x84].size = 2; memcpy(opcodes[0x84].op, "STY", 4);    opcodes[0x84].mode = ZEROPAGE;
    opcodes[0x85].size = 2; memcpy(opcodes[0x85].op, "STA", 4);    opcodes[0x85].mode = ZEROPAGE;
    opcodes[0x86].size = 2; memcpy(opcodes[0x86].op, "STX", 4);    opcodes[0x86].mode = ZEROPAGE;
    opcodes[0x87].size = 1; memcpy(opcodes[0x87].op, "", 4);       opcodes[0x87].mode = IMPLIED;
    opcodes[0x88].size = 1; memcpy(opcodes[0x88].op, "DEY", 4);    opcodes[0x88].mode = IMPLIED;
    opcodes[0x89].size = 1; memcpy(opcodes[0x89].op, "", 4);       opcodes[0x89].mode = IMPLIED;
    opcodes[0x8A].size = 1; memcpy(opcodes[0x8A].op, "TXA", 4);    opcodes[0x8A].mode = IMPLIED;
    opcodes[0x8B].size = 1; memcpy(opcodes[0x8B].op, "", 4);       opcodes[0x8B].mode = IMPLIED;
    opcodes[0x8C].size = 3; memcpy(opcodes[0x8C].op, "STY", 4);    opcodes[0x8C].mode = ABSOLUTE;
    opcodes[0x8D].size = 3; memcpy(opcodes[0x8D].op, "STA", 4);    opcodes[0x8D].mode = ABSOLUTE;
    opcodes[0x8E].size = 3; memcpy(opcodes[0x8E].op, "STX", 4);    opcodes[0x8E].mode = ABSOLUTE;
    opcodes[0x8F].size = 1; memcpy(opcodes[0x8F].op, "", 4);       opcodes[0x8F].mode = IMPLIED;
    opcodes[0x90].size = 2; memcpy(opcodes[0x90].op, "BCC", 4);    opcodes[0x90].mode = RELATIVE;
    opcodes[0x91].size = 2; memcpy(opcodes[0x91].op, "STA", 4);    opcodes[0x91].mode = INDIRECT_Y;
    opcodes[0x92].size = 1; memcpy(opcodes[0x92].op, "", 4);       opcodes[0x92].mode = IMPLIED;
    opcodes[0x93].size = 1; memcpy(opcodes[0x93].op, "", 4);       opcodes[0x93].mode = IMPLIED;
    opcodes[0x94].size = 2; memcpy(opcodes[0x94].op, "STY", 4);    opcodes[0x94].mode = ZEROPAGE_X;
    opcodes[0x95].size = 2; memcpy(opcodes[0x95].op, "STA", 4);    opcodes[0x95].mode = ZEROPAGE_X;
    opcodes[0x96].size = 2; memcpy(opcodes[0x96].op, "STX", 4);    opcodes[0x96].mode = ZEROPAGE_Y;
    opcodes[0x97].size = 1; memcpy(opcodes[0x97].op, "", 4);       opcodes[0x97].mode = IMPLIED;
    opcodes[0x98].size = 1; memcpy(opcodes[0x98].op, "TYA", 4);    opcodes[0x98].mode = IMPLIED;
    opcodes[0x99].size = 3; memcpy(opcodes[0x99].op, "STA", 4);    opcodes[0x99].mode = ABSOLUTE_Y;
    opcodes[0x9A].size = 1; memcpy(opcodes[0x9A].op, "TXS", 4);    opcodes[0x9A].mode = IMPLIED;
    opcodes[0x9B].size = 1; memcpy(opcodes[0x9B].op, "", 4);       opcodes[0x9B].mode = IMPLIED;
    opcodes[0x9C].size = 1; memcpy(opcodes[0x9C].op, "", 4);       opcodes[0x9C].mode = IMPLIED;
    opcodes[0x9D].size = 3; memcpy(opcodes[0x9D].op, "STA", 4);    opcodes[0x9D].mode = ABSOLUTE_X;
    opcodes[0x9E].size = 1; memcpy(opcodes[0x9E].op, "", 4);       opcodes[0x9E].mode = IMPLIED;
    opcodes[0x9F].size = 1; memcpy(opcodes[0x9F].op, "", 4);       opcodes[0x9F].mode = IMPLIED;
    opcodes[0xA0].size = 2; memcpy(opcodes[0xA0].op, "LDY", 4);    opcodes[0xA0].mode = IMMEDIATE;
    opcodes[0xA1].size = 2; memcpy(opcodes[0xA1].op, "LDA", 4);    opcodes[0xA1].mode = INDIRECT_X;
    opcodes[0xA2].size = 2; memcpy(opcodes[0xA2].op, "LDX", 4);    opcodes[0xA2].mode = IMMEDIATE;
    opcodes[0xA3].size = 1; memcpy(opcodes[0xA3].op, "", 4);       opcodes[0xA3].mode = IMPLIED;
    opcodes[0xA4].size = 2; memcpy(opcodes[0xA4].op, "LDY", 4);    opcodes[0xA4].mode = ZEROPAGE;
    opcodes[0xA5].size = 2; memcpy(opcodes[0xA5].op, "LDA", 4);    opcodes[0xA5].mode = ZEROPAGE;
    opcodes[0xA6].size = 2; memcpy(opcodes[0xA6].op, "LDX", 4);    opcodes[0xA6].mode = ZEROPAGE;
    opcodes[0xA7].size = 1; memcpy(opcodes[0xA7].op, "", 4);       opcodes[0xA7].mode = IMPLIED;
    opcodes[0xA8].size = 1; memcpy(opcodes[0xA8].op, "TAY", 4);    opcodes[0xA8].mode = IMPLIED;
    opcodes[0xA9].size = 2; memcpy(opcodes[0xA9].op, "LDA", 4);    opcodes[0xA9].mode = IMMEDIATE;
    opcodes[0xAA].size = 1; memcpy(opcodes[0xAA].op, "TAX", 4);    opcodes[0xAA].mode = IMPLIED;
    opcodes[0xAB].size = 1; memcpy(opcodes[0xAB].op, "", 4);       opcodes[0xAB].mode = IMPLIED;
    opcodes[0xAC].size = 3; memcpy(opcodes[0xAC].op, "LDY", 4);    opcodes[0xAC].mode = ABSOLUTE;
    opcodes[0xAD].size = 3; memcpy(opcodes[0xAD].op, "LDA", 4);    opcodes[0xAD].mode = ABSOLUTE;
    opcodes[0xAE].size = 3; memcpy(opcodes[0xAE].op, "LDX", 4);    opcodes[0xAE].mode = ABSOLUTE;
    opcodes[0xAF].size = 1; memcpy(opcodes[0xAF].op, "", 4);       opcodes[0xAF].mode = IMPLIED;
    opcodes[0xB0].size = 2; memcpy(opcodes[0xB0].op, "BCS", 4);    opcodes[0xB0].mode = RELATIVE;
    opcodes[0xB1].size = 2; memcpy(opcodes[0xB1].op, "LDA", 4);    opcodes[0xB1].mode = INDIRECT_Y;
    opcodes[0xB2].size = 1; memcpy(opcodes[0xB2].op, "", 4);       opcodes[0xB2].mode = IMPLIED;
    opcodes[0xB3].size = 1; memcpy(opcodes[0xB3].op, "", 4);       opcodes[0xB3].mode = IMPLIED;
    opcodes[0xB4].size = 2; memcpy(opcodes[0xB4].op, "LDY", 4);    opcodes[0xB4].mode = ZEROPAGE_X;
    opcodes[0xB5].size = 2; memcpy(opcodes[0xB5].op, "LDA", 4);    opcodes[0xB5].mode = ZEROPAGE_X;
    opcodes[0xB6].size = 2; memcpy(opcodes[0xB6].op, "LDX", 4);    opcodes[0xB6].mode = ZEROPAGE_Y;
    opcodes[0xB7].size = 1; memcpy(opcodes[0xB7].op, "", 4);       opcodes[0xB7].mode = IMPLIED;
    opcodes[0xB8].size = 1; memcpy(opcodes[0xB8].op, "CLV", 4);    opcodes[0xB8].mode = IMPLIED;
    opcodes[0xB9].size = 3; memcpy(opcodes[0xB9].op, "LDA", 4);    opcodes[0xB9].mode = ABSOLUTE_Y;
    opcodes[0xBA].size = 1; memcpy(opcodes[0xBA].op, "TSX", 4);    opcodes[0xBA].mode = IMPLIED;
    opcodes[0xBB].size = 1; memcpy(opcodes[0xBB].op, "", 4);       opcodes[0xBB].mode = IMPLIED;
    opcodes[0xBC].size = 3; memcpy(opcodes[0xBC].op, "LDY", 4);    opcodes[0xBC].mode = ABSOLUTE_X;
    opcodes[0xBD].size = 3; memcpy(opcodes[0xBD].op, "LDA", 4);    opcodes[0xBD].mode = ABSOLUTE_X;
    opcodes[0xBE].size = 3; memcpy(opcodes[0xBE].op, "LDX", 4);    opcodes[0xBE].mode = ABSOLUTE_Y;
    opcodes[0xBF].size = 1; memcpy(opcodes[0xBF].op, "", 4);       opcodes[0xBF].mode = IMPLIED;
    opcodes[0xC0].size = 2; memcpy(opcodes[0xC0].op, "CPY", 4);    opcodes[0xC0].mode = IMMEDIATE;
    opcodes[0xC1].size = 2; memcpy(opcodes[0xC1].op, "CMP", 4);    opcodes[0xC1].mode = INDIRECT_X;
    opcodes[0xC2].size = 1; memcpy(opcodes[0xC2].op, "", 4);       opcodes[0xC2].mode = IMPLIED;
    opcodes[0xC3].size = 1; memcpy(opcodes[0xC3].op, "", 4);       opcodes[0xC3].mode = IMPLIED;
    opcodes[0xC4].size = 2; memcpy(opcodes[0xC4].op, "CPY", 4);    opcodes[0xC4].mode = ZEROPAGE;
    opcodes[0xC5].size = 2; memcpy(opcodes[0xC5].op, "CMP", 4);    opcodes[0xC5].mode = ZEROPAGE;
    opcodes[0xC6].size = 2; memcpy(opcodes[0xC6].op, "DEC", 4);    opcodes[0xC6].mode = ZEROPAGE;
    opcodes[0xC7].size = 1; memcpy(opcodes[0xC7].op, "", 4);       opcodes[0xC7].mode = IMPLIED;
    opcodes[0xC8].size = 1; memcpy(opcodes[0xC8].op, "INY", 4);    opcodes[0xC8].mode = IMPLIED;
    opcodes[0xC9].size = 2; memcpy(opcodes[0xC9].op, "CMP", 4);    opcodes[0xC9].mode = IMMEDIATE;
    opcodes[0xCA].size = 1; memcpy(opcodes[0xCA].op, "DEX", 4);    opcodes[0xCA].mode = IMPLIED;
    opcodes[0xCB].size = 1; memcpy(opcodes[0xCB].op, "", 4);       opcodes[0xCB].mode = IMPLIED;
    opcodes[0xCC].size = 3; memcpy(opcodes[0xCC].op, "CPY", 4);    opcodes[0xCC].mode = ABSOLUTE;
    opcodes[0xCD].size = 3; memcpy(opcodes[0xCD].op, "CMP", 4);    opcodes[0xCD].mode = ABSOLUTE;
    opcodes[0xCE].size = 3; memcpy(opcodes[0xCE].op, "DEC", 4);    opcodes[0xCE].mode = ABSOLUTE;
    opcodes[0xCF].size = 1; memcpy(opcodes[0xCF].op, "", 4);       opcodes[0xCF].mode = IMPLIED;
    opcodes[0xD0].size = 2; memcpy(opcodes[0xD0].op, "BNE", 4);    opcodes[0xD0].mode = RELATIVE;
    opcodes[0xD1].size = 2; memcpy(opcodes[0xD1].op, "CMP", 4);    opcodes[0xD1].mode = INDIRECT_Y;
    opcodes[0xD2].size = 1; memcpy(opcodes[0xD2].op, "", 4);       opcodes[0xD2].mode = IMPLIED;
    opcodes[0xD3].size = 1; memcpy(opcodes[0xD3].op, "", 4);       opcodes[0xD3].mode = IMPLIED;
    opcodes[0xD4].size = 1; memcpy(opcodes[0xD4].op, "", 4);       opcodes[0xD4].mode = IMPLIED;
    opcodes[0xD5].size = 2; memcpy(opcodes[0xD5].op, "CMP", 4);    opcodes[0xD5].mode = ZEROPAGE_X;
    opcodes[0xD6].size = 2; memcpy(opcodes[0xD6].op, "DEC", 4);    opcodes[0xD6].mode = ZEROPAGE_X;
    opcodes[0xD7].size = 1; memcpy(opcodes[0xD7].op, "", 4);       opcodes[0xD7].mode = IMPLIED;
    opcodes[0xD8].size = 1; memcpy(opcodes[0xD8].op, "CLD", 4);    opcodes[0xD8].mode = IMPLIED;
    opcodes[0xD9].size = 3; memcpy(opcodes[0xD9].op, "CMP", 4);    opcodes[0xD9].mode = ABSOLUTE_Y;
    opcodes[0xDA].size = 1; memcpy(opcodes[0xDA].op, "", 4);       opcodes[0xDA].mode = IMPLIED;
    opcodes[0xDB].size = 1; memcpy(opcodes[0xDB].op, "", 4);       opcodes[0xDB].mode = IMPLIED;
    opcodes[0xDC].size = 1; memcpy(opcodes[0xDC].op, "", 4);       opcodes[0xDC].mode = IMPLIED;
    opcodes[0xDD].size = 3; memcpy(opcodes[0xDD].op, "CMP", 4);    opcodes[0xDD].mode = ABSOLUTE_X;
    opcodes[0xDE].size = 3; memcpy(opcodes[0xDE].op, "DEC", 4);    opcodes[0xDE].mode = ABSOLUTE_X;
    opcodes[0xDF].size = 1; memcpy(opcodes[0xDF].op, "", 4);       opcodes[0xDF].mode = IMPLIED;
    opcodes[0xE0].size = 2; memcpy(opcodes[0xE0].op, "CPX", 4);    opcodes[0xE0].mode = IMMEDIATE;
    opcodes[0xE1].size = 2; memcpy(opcodes[0xE1].op, "SBC", 4);    opcodes[0xE1].mode = INDIRECT_X;
    opcodes[0xE2].size = 1; memcpy(opcodes[0xE2].op, "", 4);       opcodes[0xE2].mode = IMPLIED;
    opcodes[0xE3].size = 1; memcpy(opcodes[0xE3].op, "", 4);       opcodes[0xE3].mode = IMPLIED;
    opcodes[0xE4].size = 2; memcpy(opcodes[0xE4].op, "CPX", 4);    opcodes[0xE4].mode = ZEROPAGE;
    opcodes[0xE5].size = 2; memcpy(opcodes[0xE5].op, "SBC", 4);    opcodes[0xE5].mode = ZEROPAGE;
    opcodes[0xE6].size = 2; memcpy(opcodes[0xE6].op, "INC", 4);    opcodes[0xE6].mode = ZEROPAGE;
    opcodes[0xE7].size = 1; memcpy(opcodes[0xE7].op, "", 4);       opcodes[0xE7].mode = IMPLIED;
    opcodes[0xE8].size = 1; memcpy(opcodes[0xE8].op, "INX", 4);    opcodes[0xE8].mode = IMPLIED;
    opcodes[0xE9].size = 2; memcpy(opcodes[0xE9].op, "SBC", 4);    opcodes[0xE9].mode = IMMEDIATE;
    opcodes[0xEA].size = 1; memcpy(opcodes[0xEA].op, "NOP", 4);    opcodes[0xEA].mode = IMPLIED;
    opcodes[0xEB].size = 1; memcpy(opcodes[0xEB].op, "", 4);       opcodes[0xEB].mode = IMPLIED;
    opcodes[0xEC].size = 3; memcpy(opcodes[0xEC].op, "CPX", 4);    opcodes[0xEC].mode = ABSOLUTE;
    opcodes[0xED].size = 3; memcpy(opcodes[0xED].op, "SBC", 4);    opcodes[0xED].mode = ABSOLUTE;
    opcodes[0xEE].size = 3; memcpy(opcodes[0xEE].op, "INC", 4);    opcodes[0xEE].mode = ABSOLUTE;
    opcodes[0xEF].size = 1; memcpy(opcodes[0xEF].op, "", 4);       opcodes[0xEF].mode = IMPLIED;
    opcodes[0xF0].size = 2; memcpy(opcodes[0xF0].op, "BEQ", 4);    opcodes[0xF0].mode = RELATIVE;
    opcodes[0xF1].size = 2; memcpy(opcodes[0xF1].op, "SBC", 4);    opcodes[0xF1].mode = INDIRECT_Y;
    opcodes[0xF2].size = 1; memcpy(opcodes[0xF2].op, "", 4);       opcodes[0xF2].mode = IMPLIED;
    opcodes[0xF3].size = 1; memcpy(opcodes[0xF3].op, "", 4);       opcodes[0xF3].mode = IMPLIED;
    opcodes[0xF4].size = 1; memcpy(opcodes[0xF4].op, "", 4);       opcodes[0xF4].mode = IMPLIED;
    opcodes[0xF5].size = 2; memcpy(opcodes[0xF5].op, "SBC", 4);    opcodes[0xF5].mode = ZEROPAGE_X;
    opcodes[0xF6].size = 2; memcpy(opcodes[0xF6].op, "INC", 4);    opcodes[0xF6].mode = ZEROPAGE_X;
    opcodes[0xF7].size = 1; memcpy(opcodes[0xF7].op, "", 4);       opcodes[0xF7].mode = IMPLIED;
    opcodes[0xF8].size = 1; memcpy(opcodes[0xF8].op, "SED", 4);    opcodes[0xF8].mode = IMPLIED;
    opcodes[0xF9].size = 3; memcpy(opcodes[0xF9].op, "SBC", 4);    opcodes[0xF9].mode = ABSOLUTE_Y;
    opcodes[0xFA].size = 1; memcpy(opcodes[0xFA].op, "", 4);       opcodes[0xFA].mode = IMPLIED;
    opcodes[0xFB].size = 1; memcpy(opcodes[0xFB].op, "", 4);       opcodes[0xFB].mode = IMPLIED;
    opcodes[0xFC].size = 1; memcpy(opcodes[0xFC].op, "", 4);       opcodes[0xFC].mode = IMPLIED;
    opcodes[0xFD].size = 3; memcpy(opcodes[0xFD].op, "SBC", 4);    opcodes[0xFD].mode = ABSOLUTE_X;
    opcodes[0xFE].size = 3; memcpy(opcodes[0xFE].op, "INC", 4);    opcodes[0xFE].mode = ABSOLUTE_X;
    opcodes[0xFF].size = 1; memcpy(opcodes[0xFF].op, "", 4);       opcodes[0xFF].mode = IMPLIED;
}
