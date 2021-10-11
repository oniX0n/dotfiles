/* st/colors_preset.h 
 * Preset file for colortheme header file for st */

static const char colorname[] = {
	/* 8 darker colors */
	[0]  = "#", 	/* black */
	[1]  = "#",	/* red */	
	[2]  = "#",	/* green */
	[3]  = "#",	/* yellow */
	[4]  = "#",	/* blue */
	[5]  = "#",	/* magenta */
	[6]  = "#",	/* cyan */
	[7]  = "#",	/* gray */

	/* 8 brighter colors */	
	[8]  = "#",	/* gray */
	[9]  = "#",	/* red */
	[10] = "#",	/* green */
	[11] = "#",	/* yellow */
	[12] = "#",	/* blue */
	[13] = "#",	/* magenta */
	[14] = "#",	/* cyan */
	[15] = "#",	/* white */

	/* special colors to use as foreground or background */
	/* [256] = "#", */
	/* [257] = "#", */ 
	/* ... */
};

/* color index to use as foreground and background */
unsigned int defaultfg = 15;
unsigned int defaultbg = 0;

/* color index to use for cursor and reverse cursor (if unsure use fg) */
static unsigned int defaultcs = 15;
static unsigned int defaultrcs = 15;
