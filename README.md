# Realtime plotting of arbitrary input data

* run with ./realtime-plotting < sample/input.txt
* input can be infinite stream of lines
* currently script separates each line by spaces and tries to extract number from the last element
* if number is extracted successfully, it is plotted on real time plot
* default x axis size is 100, y axis size is -2 to 2