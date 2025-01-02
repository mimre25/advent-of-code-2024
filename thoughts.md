# Thoughts

## Preamble
This is the first time I've been doing the advent of code.
While I'm not an expert in those kinds of coding challenges, I certainly have done quite some "challenges" in terms of coding ([Project Euler](https://projecteuler.net/)) and a handful of algorithms and data structure classes throughout my academic career.
My day job is less concerned about implementing algorithms or solving such challenges.

Anyhow, I mainly did it because I wanted to improve my Elixir skills.
I chose not to use third-party libraries other than a progress bar to focus on the standard library.

## The good
AoC started fairly easy and slowly ramped up the difficulty.
That was nice, and gave me the impression, that I can do this as a daily thing spending an hour or so.
I've learned quite quickly that this wasn't the case.
While this was a bummer for me, I still believe that if I had used a language I'm more familiar with or used third-party libraries, I would have probably been able to stay on top of AoC on a daily basis.

I was amazed by how well [Eric Wastl](https://was.tl/) took a simple problem and kept it easy in part one, just to follow up with a tiny alteration to make part two a good challenge.
For some problems the algorithm stayed the same but got confronted with tons of edge cases (eg block-pushing on day 15), some just hit a scalability wall (eg stones on day 11), and some just needed a completely different algorithm (eg the full-adder on day 24).

Later on, some days were easier to - what I assume - give participants a breather.
I also quite needed that, as staying on par with the days passing can wear one out.

That being said, I've refreshed a lot of past knowledge (looking at you Mr. Dijkstra) and found some weaknesses of mine (Memoization).
I enjoyed the one-dimensional puzzles, and the ones where building an interpreter was the task at hand.
I don't fancy 2D-grid puzzles tho.


## The bad
It's exhausting.
I went into this with the expectation that it would be 30 30-minute to one-hour daily brain teaser.
Oh boy was I wrong.

From about the 16th onwards AoC consumed most of my spare time.
Mainly because I thought, one could only get stars if completing the problems by the 25th.
At some point, I just wanted it to be over and not ruin my birthday (25th).
Luckily the problem on the 25th was fairly easy, and I just ran the 20th and waited for it to complete.

Another tough challenge for me was my poorly-speced laptop.
While 8GB of RAM and an i5 3.4Ghz octa-core machine sounds good on paper, it really falls apart, when more than half of those resources just go to having some music, a development environment, and a browser open.
This especially makes itself visible in those problems that can naively be solved, given that one has enough memory at hand.
That, however, made me realize, that the skill of memory optimization is also a long-forgotten one, due to modern hardware - a great learning!


## The ugly
In this section, I could just show my [benchmarks](./benchmarks.md) (lol), but instead, I'll use it to document the stupidity that I went through.

When you have a hammer, everything becomes a nail.
Elixir is very ergonomic around Enumerables like linked lists.
That code ergonomic comes with the price of run-time performance.
Luckily, I've noticed this halfway through and started using better data structures such as sets (`MapSet`).

I made a huge mistake on the first 2D-grid puzzle.
My parsing into a matrix (good), used a map of map (bad) instead of a map with a tuple as a key.
It took me quite a while to realize the clunkiness of that approach and the first hard wall on a 2D-grid problem for me to change this.
I didn't bother going back and changing this in the earlier days though, which makes me not wanna touch that code at all anymore.

There were four puzzles that I've struggled with.

Day 11 was the first one that broke me.
I ended up checking out some implementations of it from the [Elixir Forum](https://elixirforum.com/).
I knew exactly what I needed to do, but I just couldn't wrap my head around _how_ to do it.

Day 16 was the second wall I've hit.
I originally parsed the input into a graph and used that to solve part 1.
So far so good.
Part two, however, turned out to be nasty with the way I was doing things.
I ended up rewriting it as a whole much later on.

Day 20 was interesting.
When I first opened it (in the backseat of a car after 3 hours of solving other problems there), I just saw "yet another 2d-grid graph problem" and was sick of it.
I solved part one quickly and didn't even bother about part two, because I knew it wouldn't work with my approach (part one was already taking several minutes).
A few days later it was one of the few unsolved days I had remaining, and I checked online what other people were doing.
People on Reddit were discussing that it's actually not a graph problem at all, due to only having a single path.
Once I realized that, solving it was straightforward, but the computation took more than 2 hours.
It was the last problem that I've completed.
Once the dust had settled and I had a whole birthday of a break from AoC, I checked other people's solutions and noticed that they don't check if a "cheat" is valid.
I went back to reread the problem and realized I'd invented a requirement that wasn't necessary.

Day 21.
Well, it's basically 11 all over again.
Part one was ezpz.
Part two required me to check out other people's solutions.


# Reflection
While I consider it "cheating" to look at the solution of others, I believe it's the only way to really learn at times.
I tried to minimize this, but sometimes I was just stuck beyond good measure and it was just taking too much of a toll on me.

That said, the joy I felt whenever I solved one of the tougher problems, I realized that it was probably worth it.
Sadly, nobody around me could understand me (these folks aren't engineers).

I learned areas of weaknesses and some strengths - that's great.

Finally, let's reflect on the problems.
## Problems
- 1 ~ This was quite easy, not much to say about this. Good start.
- 2 ~ This was easy, but already showed that there can be beasts lying beneath problem 2.
- 3 ~ This was quite fun - loved it.
- 4 ~ Weirdly enough, I thought part two was easier than part one.
- 5 ~ Also quite fun. Just a simple dependency graph/list kinda problem.
- 6 ~ Super fun problem, but I've brute forced part two, whereas there is a smarter solution (just check spots on the original path)
- 7 ~ This was extremely easy - probably because Elixir is a functional language.
- 8 ~ Here part two also felt easier than part one for some reason.
- 9 ~ Lovely - disk fragmenting.
- 10 ~ I originally misunderstood part one and implemented the solution for part two first. :D
- 11 ~ I tried to memoize the outputting stones instead of the count for each step - yeah I don't have exabytes of memories.
- 12 ~ Part two was significantly harder than part one - let's say I found some inspiration on Reddit for this.
- 13 ~ I'm a software engineer so my solution for part one was just simulation. Part two, after some inspiration (after days 11 & 12 I was going mad), took five minutes on paper, and then another few minutes to implement.
- 14 ~ Part one was easy. Part two... well not speced enough for me. Thanks, Mr. Product Manager. Anyhow, after just running 10k steps and rendering all of them, I started to only render the ones that contained a long line of robots - that worked well.
- 15 ~ Since I finished day 14 quite early, I was fresh for day 15. If this wasn't the case, I might have thrown in the towel. Part two is a monster of ugliness. Well done on that problem.
- 16 ~ I thought I was smart using a graph when it turned out much easier using a map with coordinates as keys. This is where I went mad and did not complete the day before moving on to the next.
- 17 ~ I loved this so much. Part one was easy, part two was so much fun - Took me back to the reverse engineering days.
- 18 ~ When I first worked on this one, I really thought that the "bytes" fall over time. Instead one could just simply build the map after all of them had fallen and it was super simple. I wasted quite a bit of time on that misinterpretation.
- 19 ~ This wasn't too big of a problem, but my approach hit a wall in part two (I was splitting on the largest pattern instead of the first one). After checking how others are doing it, I quickly solved it as well
- 20 ~ As mentioned before - here the fatigue hit me and I just skipped part two without even trying it until the 24th.
- 21 ~ Same problem as for 11 - I just tried to memoize the solution sequence instead of the counts.
- 22 ~ That was fairly simple - I was happy about that, it meant I could catch up.
- 23 ~ This was also fairly straightforward. Finally a real "graph" problem (largest clique).
- 24 ~ So much fun. Part one was just a joy to implement, part two was an interesting puzzle. I ended up visualizing the circuit as a graph and checked the first diffing bit. I then looked at the graph and found the solution manually. After the dust had settled (I think it was the 28th), I implemented the algorithm as a brute force that always starts at the lowest diffing bit and then recurses - this was quite fast.
- 25 ~ This was super chill and I was happy about that. I was surprised that part two was nothing.
