#!/usr/bin/wish

# Author: Yoonsuck Choe <choe(a)tamu.edu>
# 	  http://faculty.cs.tamu.edu/choe
#
# Release data: Mon Dec  6 09:19:31 CST 2004
#
# Copyright: GNU Public License (see http://www.gnu.org).
#	     It would be nice if you can email me if you find this
#	     tool useful.
#
# Standard disclaimer: No guarantee/warranty--use at your own risk! 
#
# Usage: just type
#
#		annoteppm3.tcl
# 
# 	 for the list of command-line options.

global line_db zoom width height

#----------------------------------------
# Configurable parameters
#----------------------------------------
set linewidth 1				; # width of the object outline
set frame_flag 0			; # turn on frame border?
#----------------------------------------

set fontsize 50
font create myfont -family Helvetica -size $fontsize
set font "myfont"

set usage "
usage: annoteppm3.pl <xsize> <ysize> <zoom> <ppmfile>|\"noppm\" <command:command:...:command> \n\
	size: 	n  (ppm file is n x n) \n\
	zoom:	z  (how much to zoom) \n\
	ppmfile: n x n  image file \n\
		 if you say noppm, a blank file will be generated \n\
	command format: \n\
		circ,cx,cy,r,color \n\
		rect,xs,yx,xe,ye,color \n\
		oval,x1,y1,x2,y2\n\
		poly,x1,y1,x2,y2,x3,y3,x4,y4,...,xn,yn,color \n\
		text,x,y,text_str,color \n\
\n\
	output:	<ppmfile>-annoted.ps \n
\n\
	Example: annoteppm.tcl 142 142 2 or.ppm \"circ,96,48,10,white:oval,80,100,130,130,white:poly,10,10,50,10,50,50,24,64,10,10,white\"

"

#----------------------------------------------------------------------------
#	plot_line
#----------------------------------------------------------------------------
proc plot_line { centerx centery radius theta thick color } {

	global line_db
	global zoom width height

	set rad_theta [expr $theta*3.141592/18.0]

	set granx   [expr $zoom*$radius]
	set grany   [expr $zoom*$radius]
	set cx [expr $centerx*$zoom]
	set cy [expr $height-$centery*$zoom+1]
	set length  [expr 2.0*$granx]
	set offsetx [expr $length * cos($rad_theta) * $zoom]
	set offsety [expr $length * sin($rad_theta) * $zoom]

	set tag "$centerx-$centery"
	set line_db("$tag") "$radius:$theta:$thick:$color"

	.plot create line \
		[expr $cx-$offsetx/2.0] \
		[expr $cy+$offsety/2.0] \
		[expr $cx+$offsetx/2.0] \
		[expr $cy-$offsety/2.0] \
		-fill $color -width $thick -tag $tag

}

#----------------------------------------------------------------------------
#	rotate_line
#----------------------------------------------------------------------------
proc rotate_line { x y dir } {

	global line_db
	global zoom width height

	set xidx [expr $x/$zoom]
	set yidx [expr ($height + 1 - $y)/$zoom]

	if { [info exists line_db("$xidx-$yidx")] == 1 } {
		puts "$xidx x $yidx detected"
		if { $dir == "right" } {
			set rotate 1
		} else {
			set rotate -1
		}
  	        set spec [split $line_db("$xidx-$yidx") ":"]
		set new_theta [expr [lindex $spec 1] + $rotate ]
		.plot delete allItems withtag "$xidx-$yidx"
		plot_line $xidx $yidx [lindex $spec 0] $new_theta \
			[lindex $spec 2] [lindex $spec 3]
	}

}

#----------------------------------------------------------------------------
#	MAIN
#----------------------------------------------------------------------------
if { [llength $argv] != 5 } {
	puts $usage
	exit
}

set xsize 	[lindex $argv 0]
set ysize 	[lindex $argv 1]
set zoom	[lindex $argv 2]
set zoomx	[lindex $argv 2]
set zoomy	[lindex $argv 2]
set filename   	[lindex $argv 3]
set command_str [lindex $argv 4]

# derived values 

set width 	[expr $xsize * $zoom]
set height 	[expr $ysize * $zoom]

set plotwidth 	[expr $width - $zoom*2]
set plotheight  [expr $height - $zoom*4]

set outfile	"${filename}-annoted.ps"

#----------------------------------------
# First load the image to be annotated
#----------------------------------------
if { $filename != "noppm" } {
image create photo PPMsmall -file $filename -width $xsize -height $ysize
image create photo PPM -file $filename -width $width -height $height
PPM copy PPMsmall -from 0 0 [expr $xsize] [expr $ysize] -zoom $zoomx $zoomy
}

#----------------------------------------
# Create canvas
#----------------------------------------
canvas .plot -width $plotwidth -height $plotheight -background white
pack .plot -side top -padx 10 -pady 10

frame .fr 
set loc_xy "N/A"
label .fr.loclabel -text "Location (Cartersian)"
pack .fr.loclabel -side left
label .fr.loc -textvariable loc_xy -width 10 -relief sunken
pack .fr.loc -side left
pack .fr -side top

#----------------------------------------
# Create buttons
#----------------------------------------
button .psdump -command { \
        .plot postscript -file ${outfile}; \
        } -text "PS Dump"
pack .psdump -side top;

button .quit -command { exit } -text "Quit"
pack .quit -side top -padx 10 -pady 10

#----------------------------------------
# Add image to canvas
#----------------------------------------
if { $filename != "noppm" } {
.plot create image 0 0 -image PPM -anchor nw
}

if {$frame_flag == 1} {
  .plot create rectangle 0 0 $width $height -fill "" -outline black -width 1
}

#----------------------------------------
# Add input spec to the canvas
#----------------------------------------

# Parse input spec string
set commands [split $command_str ":"]
set num_cmds [llength $commands]

for {set i 0} {$i<$num_cmds} {incr i} {

  set cmd  [lindex $commands $i]
  set spec [split $cmd ","]
  set type [lindex $spec 0]

  switch $type {
	circ { 
		set centerx [lindex $spec 1]	
		set centery [lindex $spec 2]	
		set radius  [lindex $spec 3]
		set color   [lindex $spec 4]
		.plot create oval \
			[expr ($centerx-$radius) * $zoom] \
			[expr $height - ($centery-$radius) * $zoom + 1] \
			[expr ($centerx+$radius) * $zoom] \
			[expr $height - ($centery+$radius) * $zoom + 1] \
			-outline $color -width $linewidth
	}

	text { 
		set centerx [lindex $spec 1]	
		set centery [lindex $spec 2]	
		set textstr [lindex $spec 3]
		set textsize [lindex $spec 4]
		set color   [lindex $spec 5]
		set fontsize $textsize
		font delete myfont
		font create myfont -family Helvetica -size $fontsize
		set font "myfont"

		.plot create text \
			[expr ($centerx) * $zoom] \
			[expr $height - ($centery) * $zoom + 1] \
			-fill $color -anchor center -text $textstr \
			-font $font
	}


	line { 
		set centerx [lindex $spec 1]	
		set centery [lindex $spec 2]	
		set radius  [lindex $spec 3]
		set theta   [lindex $spec 4]
		set thick   [lindex $spec 5]
		set color   [lindex $spec 6]

		plot_line $centerx $centery $radius $theta $thick $color

	}
	
	rect {
		set x1 [lindex $spec 1]	
		set y1 [lindex $spec 2]	
		set x2 [lindex $spec 3]
		set y2 [lindex $spec 4]
		set color   [lindex $spec 5]
		.plot create rectangle \
			[expr $x1 * $zoom]  \
			[expr $height-($y1 * $zoom)+1]  \
			[expr $x2 * $zoom]  \
			[expr $height-($y2 * $zoom)+1]  \
			-outline $color -width $linewidth
	}

	oval {
		set x1 [lindex $spec 1]	
		set y1 [lindex $spec 2]	
		set x2 [lindex $spec 3]
		set y2 [lindex $spec 4]
		set color   [lindex $spec 5]
		.plot create oval \
			[expr $x1 * $zoom]  \
			[expr $height-($y1 * $zoom)+1]  \
			[expr $x2 * $zoom]  \
			[expr $height-($y2 * $zoom)+1]  \
			-outline $color -width $linewidth
	}

	hour {
		set color   [lindex $spec [expr [llength $spec]-1]]
		set polystr ".plot create polygon "

		set cx [expr ([lindex $spec 3]+[lindex $spec 7])/2]
		set cy [expr ([lindex $spec 4]+[lindex $spec 8])/2]

		set wcx1 [expr ([lindex $spec 3]+[lindex $spec 5])/2]
		set wcy1 [expr ([lindex $spec 4]+[lindex $spec 6])/2]

		set wcx2 [expr ([lindex $spec 7]+[lindex $spec 1])/2]
		set wcy2 [expr ([lindex $spec 8]+[lindex $spec 2])/2]

		set wx1 [expr ($cx+$wcx1)/2*$zoom]
		set wy1 [expr $height-($cy+$wcy1)/2*$zoom+1]

		set wx2 [expr ($cx+$wcx2)/2*$zoom]
		set wy2 [expr $height-($cy+$wcy2)/2*$zoom+1]

		set wcx [expr $cx * $zoom]
		set wcy [expr $height - $cy * $zoom + 1]

		puts stderr "cx = $cx, cy = $cy"

		for {set k 1} {$k < [expr [llength $spec]-1]} {incr k} {
			set coord [lindex $spec $k]
			set zfcoord [expr $coord * $zoom]
			if { $k%2 == 0 } { ; # x coord
				set zfcoord [expr $height - $zfcoord + 1]
			} 
			set polystr "$polystr $zfcoord"

			if { $k == 4 } { ;# insert first waist point
				set zfcoord "$wx1 $wy1"	
				set polystr "$polystr $zfcoord"
			}

			if { $k == 8 } { ;# insert second waist point
				set zfcoord "$wx2 $wy2"	
				set polystr "$polystr $zfcoord"
			}
		}
		eval "$polystr -fill \"\" -outline $color -width $linewidth"
	}


	poly {
		set color   [lindex $spec [expr [llength $spec]-1]]
		set polystr ".plot create polygon "
		for {set k 1} {$k < [expr [llength $spec]-1]} {incr k} {
			set coord [lindex $spec $k]
			set zfcoord [expr $coord * $zoom]
			if { $k%2 == 0 } { ; # x coord
				set zfcoord [expr $height - $zfcoord + 1]
			} 
			
			set polystr "$polystr $zfcoord"
		}
		eval "$polystr -fill \"\" -outline $color -width 2"
	}

	default { 
	  puts stderr "annoteppm.tcl: $cmd not supported." 
	}
  }
}

bind .plot <ButtonPress-1> { set x [expr %x/$zoom]; \
		set y %y; set yy [expr $ysize-($y)/$zoom+1];\
		set loc_xy "$x $yy"; \
		puts -nonewline stderr "$x $yy\n"; \
		update }

bind .plot <ButtonPress-2> { rotate_line %x %y "right" }
bind .plot <ButtonPress-3> { rotate_line %x %y "left"  }

bind . <KeyPress-q> { exit; } 

update;

.plot postscript -file ${outfile};

puts "\n\nannoteppm.tcl: output file ${outfile} generated."
# exit;

