#convert demoinside.png +dither -remap colors.bmp demoinside.bmp
#convert -size 1x1 \( xc:black xc:white xc:green xc:blue \) -composite colors.bmp
convert -size 1x1 \( xc:black xc:white xc:green xc:blue xc:red xc:magenta xc:cyan xc:yellow \) +append colors.bmp

#convert -size 240x200 xc:black \( -scale 240x200 580818_2066604840571_1708317713_980748_325154342_n.jpg \) -composite ualchimie2.bmp

#convert -size 240x200 xc:black \( -scale 240x200 580818_2066604840571_1708317713_980748_325154342_n.jpg \) -composite -dither None -remap colors.bmp -colors 8 ualch2.bmp
convert ualchimie2.bmp -remap colors.bmp -colors 8 ualch2.bmp
