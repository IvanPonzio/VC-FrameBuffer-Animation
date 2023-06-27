# VC FrameBuffer on QEMU Emulating an RPi3

This repository contains the implementation of two exercises carried out as part of the "Computer Organization 2022" course. Below, you will find details about what was implemented in each exercise:

## Exercise 1: Static Image Generation

In this exercise, an ARMv8 assembly program was developed to generate a static image designed by the group. The generated image fulfills the following aspects:

- It utilizes the entire screen extension.
- It uses at least 3 different colors.
- It involves at least two shapes of different forms.

The source code of the program can be found in the "exercise1" directory. The main file is "app.s". To generate the image, the method of individually painting pixels in the FrameBuffer was used. The coordinates and colors of each pixel were defined to form the desired shapes.

## Exercise 2: Animation Generation with Moving Figures

In this exercise, an ARMv8 assembly program was implemented to generate defined figures of different colors with movement. The code reuses part of the code from exercise 1 and introduces modifications to achieve the effect of moving figures. The characteristics of the animation are as follows:

- It utilizes the entire screen extension.
- It uses at least 3 different colors.
- It involves at least two shapes of different forms.
- The figures move on a non-continuous background.

To achieve movement, the method of updating the coordinates of the figures in each animation frame was used. This is done by modifying the coordinates of the figures in the FrameBuffer memory in each iteration. Thus, the figures move on the screen and generate the effect of movement.

The source code of the program can be found in the "exercise2" directory. The main file is "app.s".

## Usage

To compile and run the programs on QEMU, follow these steps:

1. Install QEMU on your system if you haven't already.

2. Clone this repository to your local machine.

3. Navigate to the directory of the exercise you want to compile, either "exercise1" or "exercise2".

4. Execute the following command to compile the program:
   ```
   make
   ```

5. Once compiled, run the program with QEMU:
   ```
   qemu-system-aarch64 -M raspi3 -kernel app.bin -serial stdio
   ```

A QEMU emulation window will open, where you can see the generated image in the case of exercise 1 or the animation in the case of exercise 2.

## Acknowledgments

This project was developed as part of the "Computer Organization 2022" course at FAMAF, the Faculty of Mathematics, Astronomy, and Physics of the National University of Córdoba, Argentina.

## License

This project is licensed under the [MIT License](LICENSE).
