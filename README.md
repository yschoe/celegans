# *C. elegans* cell location data

This repository contains the C. elegans data and tools associated with the Society of Neuroscience abstract below:

> Yoonsuck Choe, Bruce H. McCormcik, and Wonryull Koh. Network connectivity analysis on the temporally augmented em c. elegans web: A pilot study. In Society for Neuroscience Abstracts.  Washington, DC: Society for Neuroscience, 2004. Program No. 921.9.

If you are in a rush, just download this CSV file, which has the neuron name, and x-y location.

> [a relative link](scaled-labeled-data/white-etal-celegans-neuron-position.sorted.csv)

# README 

The original README file (from 2004) is copied below.

```
Author: Yoonsuck Choe choe@tamu.edu
	http://faculty.cs.tamu.edu/choe

Date:   Mon Dec  6 09:26:53 CST 2004

Release: v0.1 (alpha)

Title: C-elegans neuron position (saggital) recording tool and position data.

1. Introduction

	This collection includes some (fairly general) programs for 
	recording (x,y) locations on an arbitrary PPM image, and
	dumping the coordinates; and subsequently displaying those
	coordinates back on the PPM image, overlaid on top.

	Also included are various data files that contain neuron soma
	location info gathered from the following source.

	@Article{white:ptrslb86,
	  author       =" J. G. White and E. Southgate and J. N. Thomson 
			  and S. Brenner",
	  title        = "The structure of the nervous system of 
			  the nematode Caenorhabditis elegans",
		journal = "Philosophical Transactions of the  Royal 
			   Society of
			   London B",
	  volume       = 314,
	  year         = 1986,
	  pages        = "1--340",
	  bibdate      = "Thu Jan 22 16:59:18 CST 2004",
	  bibauthor    = "yschoe",
	}
	

2. Directory description

	README			: this file.

	code/			: contains the programs.

	raw-data/		: contains raw x,y pixel location data

	raw-data-verification/  : replots x,y coordinates above on top of
				  ppm images to verify correctness

	scaled-data/		: all separate files incorporated into
				  a single coordinate system.

	scaled-labeled-data/	: the above, plus neuron labels.

3. Details

	See each directory's individual README file for more info.

4. Copyright and disclaimer

	All programs are distributed under GNU Public License.
	All data (except for page scans from white:ptrslb86) are
	distribted free for private use. For commercial use, please
	contact the author.

	The data is a rough approximation of true C. elegans data
	because (1) the data was gathered from a schematic diagram
	of cell locations in the original source, and (2) the coordinate
	transformation method may have been nonoptimal. Thus, please do
	not use this as an authoritative source--you may have to do
	some work to clean it up.

5. Distribution and acknowledging

	The data provided here is only preliminary, so please
	do not distribute it before asking for the author's permission.
	Send email to choe(a)tamu.edu.

	If you find this set of tools and data helpful in your research,
	it would be nice if you can acknowledge me and cite the following
	(for now):

        Yoonsuck Choe, Bruce H. McCormcik, and Wonryull Koh. Network
          connectivity analysis on the temporally augmented em c. elegans
          web: A pilot study. In Society for Neuroscience Abstracts.
          Washington, DC: Society for Neuroscience, 2004. Program No. 921.9.
```
