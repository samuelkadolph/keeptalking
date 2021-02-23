## keeptalking

This repo is for modifying the manual for the VR game [Keep Talking and Nobody Explodes](https://www.bombmanual.com/) to
add some helpful markings to make it easier to defuse the bomb.

## Added Markings

#### Complicated Wires

![Combinated wires](https://rawcdn.githack.com/samuelkadolph/keeptalking/v1.0.0/img/complicated-wires.png)

This one is straight forward. The red wire ellipse is shaded red and the blue wire ellipse is shaded blue.

#### Mazes

![Mazes](https://rawcdn.githack.com/samuelkadolph/keeptalking/v1.0.0/img/mazes.png)

Adding a grid coordinate system makes it very easy to give the location of the markings, white light, and triangle.

#### Knobs

![Knobs](https://rawcdn.githack.com/samuelkadolph/keeptalking/v1.0.0/img/knobs.png)

This is a bit more complicated. I noticed there was a few patterns unique to each position of the knob.

1. If the left column is lit up, the knob should be in the right position.
2. If the second left column is unlit, the knob should be in the left position.
3. If the 2 right columns make an L shape, the knob should be in the up position.
4. Otherwise the knob should be in the down position. This one doesn't have an easy pattern so process of elimiation is
best. But if the second left column is lit or the pattern is alternating (minus the bottom middle one), the knob should
be in the down position.
