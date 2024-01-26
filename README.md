# Electronic Piano Learning Machine

Electronic Piano Learning Machine is a piano project implemented in Verilog based on Xilinx Artix-7 FPGA development board, EGO1 (XC7A35T-1CSG324C).

[*[Read the detailed project specifications]*](https://github.com/Layheng-Hok/Digital-Piano/blob/main/digital_piano/Project%20Specifications.pdf)

[*[Read the detailed project report]*](https://github.com/Layheng-Hok/Digital-Piano/blob/main/digital_piano/Project%20Report%20-%20Digital%20Piano.pdf)

# Preview

### Control Diagram of FPGA Board

<div style="display: flex; justify-content: space-between;">
  <div>
    <img src="https://github.com/Layheng-Hok/Digital-Piano/blob/main/resources/control.png" width = "800">
  </div>
</div>

### FPGA Board Connected to a Monitor and a Buzzer

<div style="display: flex; justify-content: space-between;">
  <div>
    <img src="https://github.com/Layheng-Hok/Digital-Piano/blob/main/resources/piano.png" width = "800">
  </div>
</div>

# Functionalities
+ Free mode: play any of the 7 notes (do, re, mi, fa, so, la, and si) freely
+ Autoplay mode: listen to any songs from the music library (Twinkle Twinkle Little Star, Two Tigers, and Ode to Joy)
+ Learning mode: learn how to play any songs from the music library with real-time performance rating
+ Save user's highest score in learning mode (support up to 3 users)
+ Support octave adjustment in every mode, including high, normal, and low ocatave, hence able to output 7×3 = 21 different music notes
+ Support speed adjustment in autoplay mode
+ Support VGA, LED, and seven-segment display output for intuitive and convenient interaction with the FPGA board

# Contributors
+ [Liu Gan](https://github.com/GanLiuuuu): autoplay mode and learning mode
+ [Hok Layheng](https://github.com/Layheng-Hok): free mode and VGA
+ [Zerhouni Khal Jaouhara](https://github.com/Jouwy): octave adjustment, code specification, and report
  
