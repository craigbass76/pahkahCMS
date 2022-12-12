---
subtitle: A sample markdown file 
---

## Images

Floating images are hard, especially when I'm outputting PDF and HTML. So I've decided to have either one big image, or split a section in two with the image on the right or left, and the text opposite. Here are two examples of splits:

:::imgDIV

:::imgDIVimgr
![](../images/1/darth-maul-killed-my-kids-sm.png)
:::

:::imgDIVtextl
:::space
:::
Darth Maul killed my kids at LegoLand in Florida. They were thrilled with the picture (and are now ages 18 and 16)

:::
:::

:::imgDIV

:::imgDIVimgl
![](../images/1/parker-kids-at-at.png)
:::

:::imgDIVtextr
:::space
:::
Here's one with the image on the left, but it's one bigger div, with the image and text in smaller right and left divs.
:::

:::

:::space
:::


One issue I'm having with this is that I need a border (white) or the `imgDIV` goes haywire. It's something dumb, I'm sure, I just haven't found the issue yet.

## Table of Contents Problem

There was one wee little issue, with the table of contents. When a list (the H3 headings are the list items) went over a page break, the items on the first page's part got bumped up a bit. 

The fix is to edit `boxes.py`. You'll have to hunt for it, but it's sitting in whichever directory WeasyPrint got installed into. Try this to find it:
```
sudo find / -name boxes.py
```

It should be somewhere like: `/usr/local/lib/python3.x/dist-packages/weasyprint/formatting_structure` (on a Linux machine), or on a Mac: <br />
`/usr/local/lib/python3.x/site-packages/weasyprint/formatting_structure/`

We're looking for something in the vicinity of line 320-350 of that file (which may change in future versions) that reads:
```
if (start or end) and old_style == self.style:
```
It essentially means _"if something is equal to something else"_, and we need it to say _"if something is NOT equal to something else"_ instead. We do it by replacing the first of those equals signs with an exclamation point, like this:
```
if (start or end) and old_style != self.style:
```
Rendering the TOC should work fine after this change.

## Lists over Page Breaks Issue

This is something the WeasyPrint community is still looking into (as of 3/2020)... If there's a list that goes over a page break, the first list item on the next page of the list looks a little weird. It's almost like the number/bullet is bumped down a bit from the contents of that number/bullet point. I kind of work around it for now (like, by making lower-level headings instead of list items), but it has been labeled a bug by the community. Someone will fix it.

## Heading Examples

### H3  

This is **H3**

#### H4  

This is **H4**

##### H5  

This is **H5**

###### H6  

This is **H6**

### Blank Lines Required

That's a joke, really. Blank lines aren't required between things so much, like they are with the LaTeX template I cooked up. Because it's easier to read the Markdown though, I'll probably just keep doing it.

A blank line is ***still*** required before a bulleted list though. And speaking of lists...

## Lists

By using `:::dubbah` ahead of a list, and `:::` after it (with blank lines above and below each), we are essentially create a `<div class="dubbah"> </div>` tags in the resulting HTML. This means we can create a different list style for each of those `div` classes. I've made a few, but the sky's the limit.


### Normal List

This is the default list style:

  - Bullet 1 (top-level)
    - #1 Level 2 Bullet
    - #2 Level 2 Bullet
    - #3 Level 2 Bullet
  - Bullet 2 (top-level)
    - #1 Level 2 Bullet
    - #2 Level 2 Bullet
    - #3 Level 2 Bullet  
      - Level 4
        - Level 5
          - Level 6
            - Level 7
              - Level 8
                - Level 9
  - Bullet 4 (top-level)
  - Bullet 5 (top-level)
    - Another #1 point
      ```
      A code block nested in a list
      ```
  - Bullet 6 (top-level)

### Other List Styles

Look in the `css` file to see the different styles that are set up. Try them here, by changing the `:::b` to something else, like `:::defs`.

:::b

  - Bullet 1 (top-level)
    - #1 Level 2 Bullet
    - #2 Level 2 Bullet
    - #3 Level 2 Bullet
  - Bullet 2 (top-level)
    - #1 Level 2 Bullet
    - #2 Level 2 Bullet
    - #3 Level 2 Bullet  
      - Level 4
        - Level 5
          - Level 6
            - Level 7
              - Level 8
                - Level 9
  - Bullet 4 (top-level)
  - Bullet 5 (top-level)
    - Another #1 point
      ```
      A code block nested in a list
      ```
  - Bullet 6 (top-level)
  
:::

The `:::defs` typew list, by the way, is one I'm using and still twaeking a lot. I'm on the fence about styling a list ofr this, or styling different sized headings for it. I've got both options going in the `css` file until I make up my mind.



:::horiz

### Other Items We Might Run Into

Need a landscape page all of a sudden in your PDF? Check out the `.horiz` declaration in the `css` and in this corresponding markdown.

Here is a horizontal line:

---

> Here is a block quote: Blahdy blah blah MOO I'm a goat.  

> ##### And here is an H5 header, inside a quote, with a quoted list under it:
>
> 1.   ONE list item! Ah ah ah...
> 2.   TWO list items! Ah ah ah...
>
> Now for good measure, let's throw in some example code:
> ```
> return shell_exec("echo $input | $markdown_script");
> ```

:::

:::pb
:::

### Tables

Eghads... Making tables work in LaTeX is a ruckus, Doing them this way (using an HTML/CSS template with WeasyPrint) lets them just work. There's no LaTeX tinkering required, whatsoever. I've written a PHP app that keeps track of chord charts for songs, and uses Markdown tables. Here's what one looks like:

|         | |        |        |        |        | | |        |        |        |        |
|-------- |-|--------|--------|--------|--------|-|-|--------|--------|--------|--------|
|*Intro*  | |   2    |   5    |   1    |   5    | | |        |        |        |        |
|         | |        |        |        |        | | |        |        |        |        |
|         | |   1    |   4    |   1    |  5-/1  | | |   4    |   4    |    1   |  3/6   |
|         | |   2    |   5    |  1/6   |  2/5   | | |        |        |        |        |
| *Out*   | |  1/6   |   2    |   5    |   1    | | |        |        |        |        |


### Forcing Page Breaks

You may not like where something lands, page-wise, and want to kick it down to the next one. There's a div class for that, called `pb`. To do a page break, just use the same kind of div class hack we were doing earlier with lists:
```
:::pb
:::
```

To see how this works, take a looksie at the raw Markdown, just above the **### Tables** heading. I did it there. You'll be able to see that there's a break right before that heading in the PDF.

