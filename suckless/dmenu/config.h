/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
static const unsigned int alpha = 0x55;     /* Amount of opacity. 0xff is opaque             */				// Modified
static int centered = 1;                    /* -c option; centers dmenu on screen */ 						// Modified
static int min_width = 500;                    /* minimum width when centered */ 							// Modified
static const float menu_height_ratio = 4.0f;  /* This is the ratio used in the original calculation */		// Modified
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"Hack Nerd Font:size=10"
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
	[SchemeNorm] = { "#ffffff", "#000000" },
	[SchemeSel] = { "#ffffff", "#a40000" },
	[SchemeOut] = { "#000000", "#006666" },
};

static const unsigned int alphas[SchemeLast][2] = {			// Modified 
	[SchemeNorm] = { OPAQUE, alpha },						// Modified
	[SchemeSel] = { OPAQUE, alpha },						// Modified
	[SchemeOut] = { OPAQUE, alpha },						// Modified
};															// Modified

/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 5;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
