/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 0;        /* border pixel of windows */ // Modified
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = {"Hack Nerd Font:size=10"}; // Modified
static const char dmenufont[]       = "Hack Nerd Font:size=10"; // Modified
static unsigned int baralpha        = 0xd0;
static unsigned int borderalpha     = OPAQUE;
static const unsigned int gappx     = 0;        /* gaps between windows */  // Modified

static const char col_black[]	    = "#000000";		// Modified
static const char col_gray1[]       = "#111111";
static const char col_gray2[]       = "#222222";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char col_red[]			= "#8d0000";		// Modified

static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_black, col_gray1 },
	[SchemeSel]  = { col_gray4, col_gray1, col_cyan  }, // Modified
};

/* staticstatus */
static const int statmonval = 0;

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */ // Modified
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[ ] =",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define ALTKEY Mod1Mask
#define MODKEY Mod4Mask // Modified
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } } // Modified

#define STATUSBAR "dwmblocks"	// Modified

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, NULL };	// Modified
static const char *termcmd[]  = { "kitty", NULL }; // Modified
static const char *filecmd[] = {"thunar", NULL}; // Modified
static const char *scrshotcmd[] = {"flameshot", "gui", NULL}; //Modified


static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ ALTKEY,                       XK_space,  spawn,          {.v = dmenucmd } }, // Modified
	{ ALTKEY,                       XK_Return, spawn,          {.v = termcmd } }, // Modified
	{ MODKEY,                       XK_e,      spawn,          {.v = filecmd } }, // Modified
	{ MODKEY|ShiftMask,             XK_s,      spawn,          {.v = scrshotcmd } }, // Modified
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,                       XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY,                       XK_q,      quit,           {0} }, // Modified
	{ ALTKEY,                       XK_l,      shiftview,      {.i = +1}},  // Modified
	{ ALTKEY,                       XK_h,      shiftview,      {.i = -1}},  // Modified
	{ ALTKEY|ShiftMask,             XK_l,      shiftwindow,    {.i = +1}},  // Modified
	{ ALTKEY|ShiftMask,             XK_h,      shiftwindow,    {.i = -1}},  // Modified
	{ 0, XF86XK_AudioLowerVolume, 	spawn, 	   SHCMD("pamixer -d 5; pkill -RTMIN+1 dwmblocks") },	// Modified
	{ 0, XF86XK_AudioRaiseVolume, 	spawn,     SHCMD("pamixer -i 5; pkill -RTMIN+1 dwmblocks") },	// Modified
	{ 0, XF86XK_AudioMute, 			spawn,     SHCMD("pamixer -t; pkill -RTMIN+1 dwmblocks") },		// Modified
	{ 0, XF86XK_MonBrightnessDown, 	spawn,     SHCMD("brightnessctl set 5%-") },	// Modified				// Modified
	{ 0, XF86XK_MonBrightnessUp,   	spawn,     SHCMD("brightnessctl set 5%+") },	// Modified				// Modified

};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
// 	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },	// Modified
	{ ClkStatusText,        0,              Button1,        sigstatusbar,   {.i = 1} },			// Modified 
	{ ClkStatusText,        0,              Button2,        sigstatusbar,   {.i = 2} },			// Modified
	{ ClkStatusText,        0,              Button3,        sigstatusbar,   {.i = 3} },			// Modified
	{ ClkStatusText,        0,              Button4,        sigstatusbar,   {.i = 4} },			// Modified 
	{ ClkStatusText,        0,              Button5,        sigstatusbar,   {.i = 5} },			// Modified
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

