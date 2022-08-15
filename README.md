# What is Pixelium?
[Pixelium](https://github.com/Codiumdium/Pixelium) is a **collaborative** art game where people **draw** amazing things **together** on an infinite pixel grid.
I want Pixelium to become a place where digital artists **build** things **for** their community and **with** their community. 

I started to build this project at the [Starknet House Hackathon](https://www.starknet.house/hackathon) (August 11th - 15th 2022).

# How does Pixelium work?
**Pixelium** is an **infinite** grid of pixels where each pixel is an **NFT**.

People can buy, sell, trade, or change the color of the pixels they own every *42 second*s.
But every time they do, the minimum price **goes up** a little. 

Why these parameters?

* I want people to **collaborate** to draw something **amazing together**.
* I want them to **explore** the grid.
* I want to see if they will fight to **draw** something.
* After a while I don't want people to be able to change the color of the pixels to **freeze** the drawings.

It is a bit like [r/place](https://en.wikipedia.org/wiki/R/place) but the grid has **no limit** and people **own** it.

# Can you give us some usercases of Pixelium?

As a digital artist, you can :
- just draw something for fun and keep it on Pixelium for eternity
-  give or sell your art work to your community pixel by pixel
- let your community choose how your work should evolve over time
- choose something to draw and let your community do it

As a art community, you can:
- fight with many artistic communities to spread your vision of art
- buy an art work and improve it according to your vision
- own a few pixels of your favorite artwork

And of course, all the things I can not even imagine now.

# What is the structure of Pixelium's code?
Pixelium is a set of smartcontract written in [Cairo](https://cairo-lang.org/) and published on [Starknet](https://starknet.io/).

## Grid
The ***infinite*** grid is an [ERC721](https://github.com/immutable/imx-starknet/blob/main/docs/erc721.md) contract from [ImmutableX](https://github.com/immutable/imx-starknet). I will extend it with my own code by following the [OpenZeppelin design pattern](https://docs.openzeppelin.com/contracts-cairo/0.3.0/extensibility).
The grid is not really an ***infinite grid***. I use the *tokenId* of the *ERC721* contract to encode the pixel position.
The [tokenId](https://github.com/immutable/imx-starknet/blob/main/docs/erc721.md#ownerof) is an [Uint256](https://github.com/starkware-libs/cairo-lang/blob/master/src/starkware/cairo/common/uint256.cairo) so we have about **10^77 pixels**.

## Pixel
I use a [pairing function](https://en.wikipedia.org/wiki/Pairing_function) to **encode** into the *tokenId* the pixel **position**. I think I will use the [Cantor pairing function](https://math.stackexchange.com/questions/222709/inverting-the-cantor-pairing-function).

## Color
The color is stored via a [felt](https://www.cairo-lang.org/docs/hello_cairo/intro.html#the-primitive-type-field-element-felt) (252 bits).
The format of the pixel color is [RGB](https://en.wikipedia.org/wiki/RGB) (Red, Green, Blue). Each color channel uses 8 bits. So 24 bits in total. 
~~I use the [bitwise operations](https://www.cairo-lang.org/docs/reference/common_library.html#bitwise) to save each channel.~~

# What needs to be done ? (Roadmap)
## Step 1 (For this Hackathon)
* ECR721 contract
* Pairing function
* Color manipulation
* Timer
* Price

## Step 2 (After this Hackathon)
* FrondEnd (NextJS via StarknetReact)
  * Select one or more pixels
  * Change the color of one or more pixels
  * Mint, buy, sell, trade, make an offer
  * Zoom in, zoom out, move the view area

## Step 3 (In few months) 
* Integration with [Aspect](https://aspect.co/) and [Mint Square](https://mintsquare.io/)
* **Building the community**


## Step 4 (I do not know when)
* Create **subspaces** from the main pixel grid **managed** by sub-communities with **their own rules**
* Investigate how to have a **truly** infinite pixel grid ([Arbitrary-precision arithmetic](https://en.wikipedia.org/wiki/Arbitrary-precision_arithmetic))
* Try to replace the [Cantor pairing function](https://math.stackexchange.com/questions/222709/inverting-the-cantor-pairing-function) by a [square spiral pairing function](https://www.desmos.com/calculator/augmltextm?lang=fr)
* A mobile version

# Why do you do that ?
1. Because it's fun
2. Because I can do it
3. Because I am learning and the best way to learn is by building something cool.
4. See 1. 
