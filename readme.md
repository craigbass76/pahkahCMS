## The Story

PahkahCMS is a quick and dirty pandoc-based CMS that uses a shell script to generate the HTML needed for a full-fledged documentation website. It also creates downloadable PDFs that sit alongside their related `.html` files, and show up in navigation menus for site visitors that would rather download something to read offline.

Pandoc-flavored Markdown offers a bit more control over the end result than regular and Git-flavored, and I'd used it before on another project (making PDFs for study guides at Linux Academy). I couldn't find a CMS that used this flavor of Markdown, so here we are after I'd rolled my own.

My last name is Parker, and I'm from Maine. We try our damndest not to pronounce the letter **r** here, hence the name *PahkahCMS*.

## Preliminary Schtuff

We need Bash, Pandoc, and Weasyprint installed in order to run the scripts provided. We'll also need to lay out a particular directory tree ahead of time, unless you want to rewrite the script commands. I am actually very much looking forward to someone doing this. I've been through a rough few months, and I just don't have it in me. Maybe by summer I can revisit it... Anyway, this layout is what made sense to me and is working at the moment.

## File/Directory Layout

I've got a root directory where all the shell scripts are, then I've got `md` and a few subdirectories. The subdirectories in `md` mirror what's in `./`. There is one for each major section of the docs. Each of those subdirectories must contain `z-subtitle.md` and `z-sectionDesc` files. 

```
├── ap
├── ar
├── fonts
├── images
│   ├── ar
│   └── pos
├── md
│   ├── ap
│   ├── ar
│   ├── pos
│   ├── prm
│   └── pur
├── pos
├── prm
├── pur
└── templates
```

The bash scripts read the markdown, then make `html` and `pdf` files in the corresponding subdirectories. That may then get synced to those directories with another one. I've currently got an EC2 instance's `/var/www/html` mounted up in a local directory, but you could push with `git` somewhere, to an S3 bucket (or any other cloud provider's storage platform) or whatever toots your horn.

There are two stylesheets, `styleWEB.css` and `stylePDF.css`. The latter gets used when going from `html` to `pdf`. The former, we just need to keep updated (when we make changes to the other) and tweaked so that the HTML looks ok in a browser once it's uploaded to a website directory. The `css` file, by the way, needs to be uploaded so it's sitting up with the HTML on a web server.

Those directories (the ones in the main folder that correspond with the ones in the `md` folder) must exist ahead of time. 

### Links

I'm trying to make this a self-contained thing where I can zip up the *entire* project, and then unzip it and dump it anywhere. So links to other docs need to be relative. If I've got a doc in the `2` directory, and I want to link to a file called `dubbah.html` in the `1` directory, then my link would look like this:`[Dubbah!](../1/dubbah.html)`.

The downside to this method, I'm noticing, is that if I change the file name to `001.html`(so that it shows up differently in the menu) I've got to go find all of the links to it in the `md` files. So far, it looks like I'll have to search for them manually (`grep -r dubbah ./ --include="*.md"` should do it) but I may cook up a find/replace script at some point. I can see this being a headache for me down the road.

## The Scripts

Since this is supposed to create a whole documentation website, but still be something we can just run a quick *make 'er go* type of thing, there a few different shell scripts to run...

:::defs

- `createOne.sh`
  - This script just creates a single `html` and `pdf` of a `md` file. It's handy for when you're working on a particular file and want to see what it looks like, as you go, in both HTMl and PDF format.
- `createSection.sh`
  - This creates the "structural" HTML for a directory. It looks at the markdown directory, then makes the `index.html`, complete with a sidebar menu, for the corresponding HTML directory.
- `createWholeSection.sh`
  - This looks at a markdown directory, and then deletes and recreates all of the HTML and PDF (including the same stuff that `createSection.sh` makes) in the corresponding HTML directory.
- `renameFiles.sh`
  - A partial solution to the *What if I rename a file?* question, this will prompt for a directory, then a file, then a new file name. It changes the `.md`, `.html`, and `.pdf` filenames, and also updates the TOC in the `.html` file so that the PDF link points to the new filename.
- `createIndex.sh`
  - If you add a markdown directory, run this. It will take that into account and build a new, home page, `index.html` with an updated menu.
- `sync-dirs.sh`
  - This will sync the live copy of the documentation to your local copy. Be careful - I've added the `--delete` option, so if something doesn't exist in your local repository, it's going to be deleted from the live site.
:::

## The Website

Results here will vary... I am pushing all HTML, CSS, and images up to an EC2 instance (a LAMP box, essentially) but it sounds possible to push to some sort of S3 bucket that is configured to serve out a static page website, or push to some sort of Git-related site. 

I'm used to Apache servers, so I stuck with what I know. The commented out `rsync` commands you see in `sync-dirs.sh` are pushing to my EC2 instance's `/var/www/html` directory, which I happen to have mounted up (via `sshfs`) to my `/home/craig/craigEC2` directory.

## The Workflow

Using this setup, I've developed a sort of workflow. When I'm starting out a new doc, I grab `blank.md` and save it out as `xFileName.md`. This means that when I run `createSection.sh`, it will be ignored, and this doc will be sort of like a draft. `createWholeSection.sh` actually wipes the directory out, so if you need to be looking at a PDF, you'll have to recreate it with `createOne.sh` after running this one.

### My Own Workflow

When I'm working on a single document, I run `createOne.sh`. I'll have the markdown file open (I liked the Atom editor, and hate Microsoft, so I'm using VSCodium now) and the `pdf`. When I run the script, my PDF automatically updates. Once I think it's good to go, I get out of the `.md` file, run `renameFiles.sh`, then rename the one I'm working on to something that will get put into the live site. Then I run `sync-dirs.sh` and make it live.

When I update a section's description, I go ahead and edit the relevant `z-sectionDesc.md`, then run `createSection.sh` to update. I can also use this if I've been working on a doc that I never named `x` something, and want to just get it added to the TOC.

I wrote it, but don't use `createWholeSection.sh` much. It's more for when I just want to trash the HTML/PDF folder and start fresh from the relevant Markdown folder. 

### ToDo

I'd really like to add some sort of `dialog` commands to the shell scripts, but haven't figured out how yet. This would save having to reach for a mouse (to highlight/copy things at the `read -ep` prompts). 

I'd also like to implement search, but haven't gotten there yet either. If anyone's got something that would work, feel free to implement and document it.

### In Closing

All of the commands I think anyone would need are in one of these shell scripts, but you may have to play around to make them fit your own workflow. Check out the Markdown file in the `./md/1` and its corresponding `./1` HTML/PDF directory for examples of what I've done in the CSS. Take it and run with it. I'm curious to see what other folks can make it do.

There are also a few more templates that aren't called in any of the scripts. THey're just different layouts I have been dorking with.

Enjoy, keep in touch, and try to stay out of the news.
