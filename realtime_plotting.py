#!/usr/bin/env python3
import sys
import matplotlib.pyplot as plt
import collections

X_AXIS_SIZE = 100
Y_AXIS_SIZE = 2

plt.ion()
fig = plt.figure()

if not sys.stdin.isatty():
    input_stream = sys.stdin
else:
    raise IndexError('Can only be used with bash!')

x_axis = list(range(X_AXIS_SIZE))

y_axis = collections.deque(maxlen=X_AXIS_SIZE)
y_axis.extend(list(range(X_AXIS_SIZE)))

li, = plt.plot(x_axis, y_axis)
plt.axis([0, X_AXIS_SIZE, -Y_AXIS_SIZE, Y_AXIS_SIZE])
fig.canvas.draw()
plt.show(block=False)

for line in input_stream:
    splitted_line = line.split(' ')
    try:
        measurement = float(splitted_line[len(splitted_line) - 1])
        y_axis.append(measurement)
        li.set_ydata(y_axis)
        fig.canvas.draw()
        plt.pause(0.0001)
    except ValueError:
        pass
