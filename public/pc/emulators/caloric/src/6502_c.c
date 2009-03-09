/*
 *	6502_c.c - Caloric GTK debugger
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

/*
http://www.gtk.org/download-windows.html
*/
#include "config.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>

#if HAVE_DEBUGGER
#include "caloric.h"
#include "6502_opcodes.h"

#include <gtk/gtk.h>
#include <glade/glade.h>

// http://sourceforge.net/project/showfiles.php?group_id=98754

static GladeXML *xml;
GtkWidget *aboutWindow;
GtkWidget *regWindow, *stackWindow, *codeWindow, *soundWindow;
GtkWidget *entryA, *entryX, *entryY, *entryPC;
GtkWidget *entryCarry, *entryOverflow, *entryFlags;

GtkWidget *stackLabel, *codeLabel, *soundLabel;
GtkWidget *zoomSpin;

GtkWidget *checkscanline;

GtkWidget *pitchAEntry, *pitchBEntry, *pitchCEntry, *NoiseEntry, *Status1Entry, *Status2Entry, *VolumeAEntry, *volumeBEntry, *volumeCEntry, *EGPeriodEntry, *EGCyleEntry, *keyColumnEntry;


uint8_t regWinVisible, stackWinVisible, codeWinVisible, soundWinVisible;

gboolean  update_registers_values(gpointer data);
gboolean  update_stack_values(gpointer data);
gboolean  update_code_values(gpointer data);
gboolean  update_sound_values(gpointer data);
gboolean  update_zoom_values(gpointer data);

extern uint16_t Sys_Request;
extern uint8_t S;
extern uint8_t Flags;
extern uint8_t Carry;
extern uint8_t Overflow;

extern uint8_t telestrat;
extern uint8_t jasmin;
extern uint8_t disk;
extern int zoomChange;
extern int sound;

extern uint8_t setfullScreen, fullScreen;



/* Effects*/
extern uint8_t scanlineEmulation;


/* Step */
uint8_t progStep = 0;
uint8_t progPause = 0;


typedef struct sState_
{
    uint8_t a;
    uint8_t x;
    uint8_t y;
    uint8_t nz;
    uint32_t pc;

    uint8_t pad[80-5];
}sState;

extern sState Registers;



void showState(void)
{
    int i;

    fprintf(stderr, "A=%02x  X=%02x  Y=%02x  PC=%08x  NZ=%02x   Flags %02X Carry %02X Overflow %02X  \n",
            Registers.a, Registers.x, Registers.y, Registers.pc, Registers.nz,
            Flags, Carry, Overflow);

    fprintf(stderr, "%p\n", Oric_Mem);


    for(i = 0; i < 0x100; i++) {
        fprintf(stderr, "%02x ", Oric_Mem[i]);
    }
    fprintf(stderr, "\n");

}

void debugStep(void)
{
    while(progPause) {
        if(progStep) {
            progStep = 0;
            break;
        }
        display_frame();
    }
}



#define GLADE_FILE "gui/gtk/euphoricgui.glade"
void *watch(void *arg)
{
    int i;
    gen_opcodes();
    for(i=0; i<0xFFFF; i++) {
        symbolTable[i].name[0] = 0;
    }

    gtk_init(0, NULL);

    xml = glade_xml_new(GLADE_FILE, NULL, NULL);


    glade_xml_signal_autoconnect(xml);

    aboutWindow = glade_xml_get_widget(xml, "window2");

    regWindow = glade_xml_get_widget(xml, "registersWindow");
    stackWindow = glade_xml_get_widget(xml, "stackWindow");
    codeWindow = glade_xml_get_widget(xml, "codeWindow");
    soundWindow = glade_xml_get_widget(xml, "soundWindow");

    entryA = glade_xml_get_widget(xml, "entryA");
    entryX  = glade_xml_get_widget(xml, "entryX");
    entryY  = glade_xml_get_widget(xml, "entryY");
    entryPC = glade_xml_get_widget(xml, "entryPC");
    entryCarry = glade_xml_get_widget(xml, "entryCarry");
    entryOverflow = glade_xml_get_widget(xml, "entryOverflow");
    entryFlags = glade_xml_get_widget(xml, "entryFlags");
    stackLabel = glade_xml_get_widget(xml, "stackLabel");
    codeLabel = glade_xml_get_widget(xml, "codeLabel");

    zoomSpin= glade_xml_get_widget(xml, "spinbutton1");

    checkscanline = glade_xml_get_widget(xml, "checkscanline");
    pitchAEntry = glade_xml_get_widget(xml, "pitchAEntry");
    pitchBEntry = glade_xml_get_widget(xml, "pitchBEntry");
    pitchCEntry = glade_xml_get_widget(xml, "pitchCEntry");
    NoiseEntry = glade_xml_get_widget(xml, "NoiseEntry");
    Status1Entry = glade_xml_get_widget(xml, "Status1Entry");
    Status2Entry = glade_xml_get_widget(xml, "Status2Entry");
    VolumeAEntry = glade_xml_get_widget(xml, "VolumeAEntry");
    volumeBEntry = glade_xml_get_widget(xml, "volumeBEntry");
    volumeCEntry = glade_xml_get_widget(xml, "volumeCEntry");
    EGPeriodEntry = glade_xml_get_widget(xml, "EGPeriodEntry");
    EGCyleEntry = glade_xml_get_widget(xml, "EGCyleEntry");
    keyColumnEntry = glade_xml_get_widget(xml, "keyColumnEntry");


    gtk_toggle_button_set_active((GtkToggleButton*)checkscanline, scanlineEmulation);


    gtk_spin_button_set_value ((GtkSpinButton*)zoomSpin, zoom);

    regWinVisible = 0;
    stackWinVisible = 0;
    soundWinVisible = 0;

    g_timeout_add (50,
                   update_registers_values,
                   NULL);
    g_timeout_add (50,
                   update_stack_values,
                   NULL);
    g_timeout_add (50,
                   update_code_values,
                   NULL);
    g_timeout_add (50,
                   update_sound_values,
                   NULL);

    g_timeout_add (50,
                   update_zoom_values,
                   NULL);


    if (!xml) {
        fprintf(stderr, "Can't load %s :(((\n", GLADE_FILE);

    }

gtk_main();

    return NULL;
}

static void file_sym_ok_sel( GtkWidget        *w, GtkFileSelection *fs )
{
    FILE *fp;
    fprintf(stderr, "%s\n", gtk_file_selection_get_filename (GTK_FILE_SELECTION (fs)));

    fp = fopen(gtk_file_selection_get_filename (GTK_FILE_SELECTION (fs)), "r");
    if(!fp) {
        // FIXME
        return;
    }

    while(1) {
        char s[1024];
        unsigned int add;
        char sym[256];
        if(fgets(s, 1024, fp) == NULL) break;
        sscanf(s, "%04X %s", &add, sym);
        strcpy(symbolTable[add&0xFFFF].name, sym);
    }
    fclose(fp);

    gtk_widget_hide (GTK_WIDGET(fs));
}

G_MODULE_EXPORT void on_buttonsymbol_clicked(GtkWidget *widget, gpointer user_data)
{
    GtkWidget *dial = gtk_file_selection_new("Open symbol file ...");
    g_signal_connect (G_OBJECT (GTK_FILE_SELECTION (dial)->ok_button),
		      "clicked", G_CALLBACK (file_sym_ok_sel), (gpointer) dial);
    g_signal_connect_swapped (G_OBJECT (GTK_FILE_SELECTION (dial)->cancel_button),
                              "clicked", G_CALLBACK (gtk_widget_destroy),
                              G_OBJECT (dial));

    gtk_widget_show (dial);

}
G_MODULE_EXPORT void on_buttonreset_clicked(GtkWidget *widget, gpointer user_data)
{
            Sys_Request |= 0x400;
}
G_MODULE_EXPORT void on_buttonstop_activate(GtkWidget *widget, gpointer user_data)
{
    progPause = 1;
}

G_MODULE_EXPORT void on_buttonrun_activate(GtkWidget *widget, gpointer user_data)
{
    progPause = 0;
}

void on_buttonstep_clicked(GtkWidget *widget, gpointer user_data)
{
    progStep = 1;
}

G_MODULE_EXPORT void on_about1_activate(GtkWidget *widget, gpointer user_data)
{
    gtk_widget_show(aboutWindow);
}

G_MODULE_EXPORT void on_quitter1_activate(GtkWidget *widget, gpointer user_data)
{
    exit(1);
}

G_MODULE_EXPORT void on_reg_close_activate(GtkWidget *widget, gpointer user_data)
{
    gtk_widget_hide(regWindow);
    regWinVisible = 0;
}
G_MODULE_EXPORT void on_checkFullscreen_toggled(GtkWidget *widget, gpointer user_data)
{
    setfullScreen = !fullScreen;
}

G_MODULE_EXPORT void on_checkscanline_toggled(GtkWidget *widget, gpointer user_data)
{
    if(scanlineEmulation == 1) zoomChange = 1;
    scanlineEmulation = !scanlineEmulation;
}

G_MODULE_EXPORT void on_checkregisters_toggled(GtkWidget *widget, gpointer user_data)
{
    regWinVisible = !regWinVisible;

    if(regWinVisible) {
        gtk_widget_show(regWindow);
    } else {
        gtk_widget_hide(regWindow);
    }
}
G_MODULE_EXPORT void on_checkstack_toggled(GtkWidget *widget, gpointer user_data)
{
    stackWinVisible = !stackWinVisible;

    if(stackWinVisible) {
        gtk_widget_show(stackWindow);
    } else {
        gtk_widget_hide(stackWindow);
    }
}

G_MODULE_EXPORT void on_checkcode_toggled(GtkWidget *widget, gpointer user_data)
{
    codeWinVisible = !codeWinVisible;

    if(codeWinVisible) {
        gtk_widget_show(codeWindow);
    } else {
        gtk_widget_hide(codeWindow);
    }
}

G_MODULE_EXPORT void on_checkSound_toggled(GtkWidget *widget, gpointer user_data)
{
    soundWinVisible = !soundWinVisible;

    if(soundWinVisible) {
        gtk_widget_show(soundWindow);
    } else {
        gtk_widget_hide(soundWindow);
    }
}

G_MODULE_EXPORT void on_button_mute_toggled(GtkWidget *widget, gpointer user_data)
{
    sound = !sound;
}

 G_MODULE_EXPORT void on_spinbutton1_value_changed(GtkWidget *widget, gpointer user_data)
{
    printf("Entered\n");
    zoomChange = gtk_spin_button_get_value_as_int((GtkSpinButton*)zoomSpin);
}

G_MODULE_EXPORT gboolean  update_zoom_values(gpointer data)
{
  gtk_spin_button_set_value((GtkSpinButton*)zoomSpin, zoomChange);
    return 1;
}

G_MODULE_EXPORT gboolean  update_registers_values(gpointer data)
{
    uint32_t a = (uint32_t)Oric_Mem;
    if(regWinVisible) {
        char v[10];
        sprintf(v, "$%02x", Registers.a);
        gtk_entry_set_text((GtkEntry*)entryA, (char*)v);
        sprintf(v, "$%02x", Registers.x);
        gtk_entry_set_text((GtkEntry*)entryX, (char*)v);
        sprintf(v, "$%02x", Registers.y);
        gtk_entry_set_text((GtkEntry*)entryY, (char*)v);
        sprintf(v, "$%04x", ((Registers.pc-1) - a)&0xFFFF);
        gtk_entry_set_text((GtkEntry*)entryPC, (char*)v);
        sprintf(v, "$%02x", Carry);
        gtk_entry_set_text((GtkEntry*)entryCarry, (char*)v);
        sprintf(v, "$%02x", Overflow);
        gtk_entry_set_text((GtkEntry*)entryOverflow, (char*)v);

        memset(v, 0x20, 8);
        if(Flags&128) v[0]='N';
        if(Flags&64)  v[1]='V';
                      v[2]='1'; // Always 1
        if(Flags&16)  v[3]='B';
        if(Flags&8)   v[4]='D';
        if(Flags&4)   v[5]='I';
        if(Flags&2)   v[6]='Z';
        if(Flags&1)   v[7]='C';
                      v[8]=0;
        gtk_entry_set_text((GtkEntry*)entryFlags, (char*)v);
    }
    return 1;
}

G_MODULE_EXPORT gboolean  update_stack_values(gpointer data)
{
    if(stackWinVisible) {
        char v[1024*10];
        int i, o=0;

        sprintf(v, "<tt>");
        o+=4;
        for(i=0;i<256;i++) {
            if(i%16==0) {
                sprintf(&v[o], "<b>%04x :</b> ", i+0x100);
                o+=14;
            }

            if(S == i) {
                sprintf(&v[o], "<span foreground=\"red\"><b>%02x</b></span> ", Oric_Mem[0x100+i]&0xFF);
                o = strlen(v);
            } else {
                sprintf(&v[o], "%02x ", Oric_Mem[0x100+i]&0xFF);
                o+=3;
            }
            if(i%16==15) {
                sprintf(&v[o], "\n");
                o++;
            }
        }
        sprintf(&v[o], "</tt>");

        gtk_label_set_markup((GtkLabel*)stackLabel, v);
    }
    return 1;
}

G_MODULE_EXPORT  gboolean  update_code_values(gpointer data)
{
    if(codeWinVisible) {
        char v[1024*10];
        int y, o=0;
        uint32_t a = (uint32_t)Oric_Mem;
        uint32_t offset = (Registers.pc-1) - a;

        sprintf(v, "<tt><span underline=\"double\">Addr     Hexadecimal |     ASCII    |   Disassembly</span>\n");
        o+=strlen(v);

        for(y=0;y<32;y++) {
            char h[1000];
            char d[1000];
            int x;
            int s =0;
            int l = 0;
            char has_sym = 0;
            char sym[256];

            /* Generate opcode line */
            for(x=0; x<opcodes[Oric_Mem[offset]].size; x++) {
                sprintf(&h[s], "%02X ", Oric_Mem[offset+x]);
                s = strlen(h);
                l+=3;
            }

            /* PAD */
            for(x=0; x<(4 - opcodes[Oric_Mem[offset]].size); x++) {
                sprintf(&h[s], "   ");
                s = strlen(h);
                l+=3;
            }
            sprintf(&h[s], "   |   ");
            s = strlen(h);
            l+=7;
            /* Generate ASCII*/
            for(x=0; x<opcodes[Oric_Mem[offset]].size; x++) {
                char c[10];
                if(Oric_Mem[offset+x]>=32 && Oric_Mem[offset+x]<=126) {
                    if(Oric_Mem[offset+x] == '<') {
                        sprintf(c, "&lt");
                    } else if (Oric_Mem[offset+x] == '>') {
                        sprintf(c, "&gt");
                    } else {
                        sprintf(c, "%c", Oric_Mem[offset+x]);
                    }
                } else {
                    sprintf(c, ".");
                }
                sprintf(&h[s], "%s", c);
                s = strlen(h);
                l+=1;
            }
            s = strlen(h);

            if(opcodes[Oric_Mem[offset]].size == 1) {// ?????
                sprintf(&h[s], " ");
                s = strlen(h);
            }
            /* PAD */
            for(x=0; x<(32 - l); x++) {
                sprintf(&h[s], " ");
                s = strlen(h);
                l+=1;
            }
            sprintf(&h[s], "   |   ");
            s = strlen(h);
            l+=7;
            decode[opcodes[Oric_Mem[offset]].mode](&Oric_Mem[offset], d, offset&0xFFFF);
            sprintf(&h[s], "%s", d);

                if(symbolTable[offset&0xFFFF].name[0] != 0) {
                    sprintf(sym, "<span foreground=\"#7f7f7f\" background=\"#ffff00\">%s:</span> \n", symbolTable[offset&0xFFFF].name);
                    has_sym = 1;
                }

                if(y==0) {
                    sprintf(&v[o], "<b>%s%04X: %s</b>\n", has_sym?sym:"", offset&0xFFFF, g_markup_escape_text(h, strlen(h)));
                } else {
                    sprintf(&v[o], "%s%04X: %s\n", has_sym?sym:"", offset&0xFFFF, g_markup_escape_text(h, strlen(h)));
                }

            o = strlen(v);
            offset+=opcodes[Oric_Mem[offset]].size;
        }
        sprintf(&v[o], "</tt>");
        gtk_label_set_markup((GtkLabel*)codeLabel, v);
    }
    return 1;
}


extern uint16_t timerA, timerB, timerC, timerN, timerE, periodA, periodB, periodC, periodN, periodE, outputA, outputB, outputC, outputN;
extern int8_t controlA, controlB, controlC, controlNA, controlNB, controlNC;
extern uint8_t chanelA, chanelB, chanelC, amplitudA, amplitudB, amplitudC, amplitudE, envelopA, envelopB, envelopC, attack, alternate, hold, timerP, period_count, first_period;


G_MODULE_EXPORT  gboolean  update_sound_values(gpointer data)
{
    if(soundWinVisible) {
        char v[10];
        sprintf(v, "$%04X", periodA&0xFFF);
        gtk_entry_set_text((GtkEntry*)pitchAEntry, v);
        sprintf(v, "$%04X", periodB&0xFFF);
        gtk_entry_set_text((GtkEntry*)pitchBEntry, v);
        sprintf(v, "$%04X", periodC&0xFFF);
        gtk_entry_set_text((GtkEntry*)pitchCEntry, v);
        sprintf(v, "$%04X", periodN&31);
        gtk_entry_set_text((GtkEntry*)NoiseEntry, v);
        sprintf(v, "%c%c%c",controlNA==0?'-':'A',controlNB==0?'-':'B',controlNC==0?'-':'C');
        gtk_entry_set_text((GtkEntry*)Status1Entry, v);
        sprintf(v, "%c%c%c",controlA==0?'-':'A',controlB==0?'-':'B',controlC==0?'-':'C');
        gtk_entry_set_text((GtkEntry*)Status2Entry, v);
        sprintf(v, "$%02X", amplitudA&31);
        gtk_entry_set_text((GtkEntry*)VolumeAEntry, v);
        sprintf(v, "$%02X", amplitudB&31);
        gtk_entry_set_text((GtkEntry*)volumeBEntry, v);
        sprintf(v, "$%02X", amplitudC&31);
        gtk_entry_set_text((GtkEntry*)volumeCEntry, v);
        sprintf(v, "$%02X", periodE&0xFFFF);
        gtk_entry_set_text((GtkEntry*)EGPeriodEntry, v);
        sprintf(v, "Missing");
        gtk_entry_set_text((GtkEntry*)EGCyleEntry, v);
        sprintf(v, "Missing");
        gtk_entry_set_text((GtkEntry*)keyColumnEntry, v);
    }

    return 1;
}



#else
/* Dummies */
void showState(void)
{

}

void debugStep(void)
{

}
#endif
