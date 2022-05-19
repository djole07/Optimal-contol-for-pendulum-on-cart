# Optimal-contol-for-pendulum-on-cart
Finding control for pendulum on cart to minimize time between 2 points

# Introduction

We have a system like this:

![picture](https://user-images.githubusercontent.com/70102890/169262470-d9fcb830-0186-44b1-9907-d71eeb859aa5.jpg)

With parameters down below:

M = 0.5kg
m = 0.2kg
b = 0.1m
I = 0.006 kg/m^2
g = 9.8 m/s^2
l = 0.3m

Now, we want the cart to minimize traveling from point A to point B. We to firsty stabilize system because otherwise we will will find control in open loop, and system can't be stable.

# LQR

For stabilization we will use LQR controller. After stabilization, system will behave as showed in the picture down below. The input is step signal.

![lqr](https://user-images.githubusercontent.com/70102890/169263920-257960d3-ca7a-4901-badf-17f0d0927c81.png)

# Minimization

We will want to system to travel a distance of 6m, with constraints that cart has to have zero acceleration in the beginning, as well as pendulum beeing still with zero angular velocity. At the end we want from system to also have zero acceleration/velocity, but from pendulum we want zero angle to the y-axis, but angular velocity don't have to be 0, because control will be to physically imposible, but after simulation velocity will be close to zero.

![opt](https://user-images.githubusercontent.com/70102890/169264990-62eb21a5-09ba-448e-a6ce-6148aca4972b.png)
Optimal contol with graph that show cart position (in blue), and current angle (in green). X-axis is time.s
