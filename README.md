# Amiga open heart project

This project is about programming the Amiga in Assembler. The focus of this project is on 3D graphics with the very limited resources for it on the Amiga platform.

I named it "open heart project" because programming on the Amiga in Assembler feels like performing a surgery on an open heart. It feels like programming with all the other programmers from Commodore at the same time. The people who wrote the underlying Kickstart or even the AmigaOS. Even in the "Amiga ROM Kernel Reference Manual Libraries" book in the "Exec Library" section about "Exec interrupts" you can read that messing with registers of other programmers is not a good idea. I felt so, when I was using the `Move` and `Draw` commands of the graphics.library and the address register `a1` (holding the rasterport address) was zeroed all the time after execution.

Thanks to the project in https://github.com/LutzGrosshennig/amiga-simple3d I can start with a line drawing version of an aircraft. It already contains the tricky parts for rotation and projection and runs out of the box on Kickstart 1.3.

My goal is to transform it into a version which draws the aircraft with filled planes and allows control over the rotation.

# How to run the example

To run the project you need to do "Amiga Assembly: Create example workspace" in VSCode first to create the files for the development environment in the folder where you cloned the project.  
Hit F5 to run the project in the debugger.  
Unfortunately, on windows debugging slows down the emulator.

# Tools and Resources

The development is done on an emulator FS-UAE or WinUAE.  
Fortunately, there are many of the good old even german books to be found in the internet archive.

## Amiga Assembly for VSCode extension

Still in development but very helpful. With the extension comes all you need for developing.

https://marketplace.visualstudio.com/items?itemName=prb28.amiga-assembly

## Books (german and english)

The books are in good quality and fully readable. Also, a PDF version can be downloaded with (nearly) full text search.

### General assembly programming (and on intuition and graphics)

* Amiga Programmieren in Maschinenesprache:  
  https://archive.org/details/amiga-programmieren-in-maschinensprache

* Compute!'s Amiga machine language programming guide:  
  https://archive.org/details/COMPUTEs_Amiga_Machine_Language_Programming_Guide_1988_COMPUTE_Publications

### Reference manuals

* Amiga Hardware Reference Manual 3rd Edition:  
  https://archive.org/details/amiga-hardware-reference-manual-3rd-edition

* Amiga ROM Kernel Reference Manual Libraries 3rd Edition:  
  https://archive.org/details/amiga-rom-kernel-reference-manual-libraries-3rd-edition

### AmigaOS 2.04, ARexx, Amiga 3000

* Amiga intern : the definitive reference book for all Amiga computers:  
  https://archive.org/details/Amiga_Intern_1992_Abacus

### Game programming (german)

* Grafik in Assembler auf dem Amiga:  
  https://archive.org/details/schimanski-grafik-in-assembler-auf-dem-amiga-1990

* Spieleprogrammierung in Assembler:  
  https://archive.org/details/spiele-programmierung-in-assembler

* Amiga Spiele selber programmieren:  
  https://archive.org/details/amiga-spiele-selber-programmieren

* Amiga Spiele selber programmieren Band 2:  
  https://archive.org/details/amiga-spiele-selber-programmieren-band-2
