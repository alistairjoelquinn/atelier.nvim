# Atelier - a Neovim plugin for creating & editing colorschemes

Atelier allows you to update your current colorscheme while you are working, or you can create new colorschemes from scratch, and export them as a standalone plugin.

Atelier is based on my own experience of wishing it was easier to update a colorscheme on the fly while I am using it. Perhaps you find there is one color which is a little too bright, or one you wish was a different color altogether. This plugin allows you to open a window, tweak the color, and get back to work.

## Installation

You can install `atelier.nvim` with your preferred package manager. Here is an example using `lazy.nvim`

```lua
{
  "alistairjoelquinn/atelier.nvim",
  lazy = false,
  priority = 1000,
}
```

You can then apply atelier, like you would apply any colorscheme in your Neovim setup.

## dull-ish

When first loading the plugin, the [dull-ish colorscheme](https://github.com/alistairjoelquinn/dull-ish.nvim) is applied. This is a low-contrast, minimalistic colorscheme with a few subtle color highlights.

<img width="775" alt="Screenshot 2025-05-25 at 14 42 31" src="https://github.com/user-attachments/assets/6fa96121-25c4-4630-ba55-3834f8a62543" />

From here, if you wish to open the plugin window you can do so with `:AtelierOpen`, or `<leader>at` which is preconfigured. This will present you with the color editor for the dull-ish colorscheme.

![Screenshot 2025-05-24 at 20 33 29](https://github.com/user-attachments/assets/3595e19d-48d0-4a48-b15d-73f78ec4084b)

There are 2 other views for this window. The help page, which can be accessed with `?`.

<img width="481" alt="Screenshot 2025-05-26 at 14 44 57" src="https://github.com/user-attachments/assets/5819172f-4c7e-49c5-8a63-3d6abdae1d9c" />

And the library, which can be accessed with `o` (for "options").

![Screenshot 2025-05-24 at 19 37 44](https://github.com/user-attachments/assets/a4e18edc-aa9a-4459-b069-f87e52d015cb)

We'll come back to these pages though.

## Color page

You can navigate back to the color page for the currently selected colorscheme ([dull-ish](https://github.com/alistairjoelquinn/dull-ish.nvim)), with `c`.

![Screenshot 2025-05-24 at 20 33 29](https://github.com/user-attachments/assets/309d28d7-6df1-4150-94cb-45eba35931ad)

From here you can navigate up and down between the hex codes with `j` & `k`, then simply change one, and press `s` to save. After changing a hex code, its background gives you immediate feedback as to what the color looks like, to make it easier to find a color which matches well with the rest of the palette. After saving you will see the colorscheme update immediately to reflect any changes. Below we have updated the hex code for `functions and warnings`. You can see that both the hex code and the functions in the background use the new color.

<img width="881" alt="Screenshot 2025-05-24 at 19 52 42" src="https://github.com/user-attachments/assets/1d89f05a-04d6-41dc-8412-99dd6f5988be" />

In order to simplify the creation and editing of colorschemes, the color highlights have been divided up into the 14 groups you can see in the window.

## Library

Now that we have managed to update the current colorscheme, let's try and create a new one. Navigate to the library by pressing `o`. In total `atelier.nvim` allows you to save up to 8 colorschemes.

![Screenshot 2025-05-24 at 19 37 44](https://github.com/user-attachments/assets/990faff6-9e37-4509-b388-f368f2794ef2)

From here you can select any one of the colorschemes by choosing its number. Currently all the other colorschemes are empty. The first time you choose an empty colorscheme you will be prompted to choose a name.

![Screenshot 2025-05-24 at 19 38 12](https://github.com/user-attachments/assets/ca14376c-9fb1-4ee5-ad9b-4f9285f6327a)

Let's call ours Muted Neon. Having entered the new name, you will be immediately navigated back to the color page, where the default dark colorscheme has been applied. The window title indicates that Muted Neon is currently selected.

![Screenshot 2025-05-24 at 19 38 30](https://github.com/user-attachments/assets/721f4aa7-0370-4823-bf25-96af7338717e)

Now we can repeat the process from before and update a hex code.

![Screenshot 2025-05-24 at 19 39 23](https://github.com/user-attachments/assets/f83646d3-7522-41dc-9f9f-9ec6c2a2c932)

Again, after pressing `s`, for save, we will see the Neovim colorscheme update immediately.

![Screenshot 2025-05-24 at 19 39 56](https://github.com/user-attachments/assets/75b39de3-4d8c-41f8-ba65-be44a4bfd261)

Let's change a couple more.

![Screenshot 2025-05-24 at 19 41 10](https://github.com/user-attachments/assets/b244ff14-5325-4f34-9827-206908159396)

We can return back to the library with `o` in order to change colorscheme again. Here we can press the number `1` to return back to `dull-ish` or we can pick another number to create another new colorscheme.

![Screenshot 2025-05-24 at 19 41 31](https://github.com/user-attachments/assets/d514c1b3-a4e3-4e9e-bfdb-991c00c0223a)

## Exporting colorschemes

Once you've created a colorscheme you're happy with, you can export it as a standalone plugin. This allows you to share your colorscheme with others or use it with a plugin manager like any other Neovim colorscheme.

To export a colorscheme:

1. Navigate to the library by pressing `o`
2. Press `e` followed by the number of the colorscheme you want to export (e.g., `e2` for the second colorscheme)
3. You'll be prompted to specify a location on your filesystem where the colorscheme will be exported
4. The plugin will create a complete colorscheme plugin directory with all necessary files

The exported colorscheme will be ready to use and can be published directly to GitHub.

## Considerations

- The color page is an editable buffer, which makes it very easy to undo changes should you dislike an update you have applied. Simply undo any changes in the text and re-apply with `s`.
  - This also means individual highlight groups can be deleted if desired.
- The plugin uses JSON to persist the hex codes for each colorscheme. One of the advantages of this is that the JSON file persisted at the root of the `nvim` directory can be included in version control, should you wish to share your saved colorschemes across devices. The reverse also being true, if you wish to persist your colorschemes only on one machine, the file can be ignored from version control.
- When troubleshooting, bear in mind that as last resort, if problems are arising, you can simply delete the json file from the root of your `nvim` directory and start from scratch the next time you open the plugin (any colorschemes saved will be lost).
