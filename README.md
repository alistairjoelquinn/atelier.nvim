# Dynamic Theme - a Neovim theme plugin with a twist

This Neovim theme comes with super powers. It allows you to update the current theme while you are working, as well as creating new themes from scratch. It's based on my own experience of wishing it was easier to update the theme that I am using. Perhaps you find there is one color which is a little too bright, or one you wish was a different color altogether. This plugin allows you to do just that.

## dull-ish

When first loading the plugin, the [dull-ish theme](https://github.com/alistairjoelquinn/dull-ish.nvim) is applied. This is a low-contrast, minimalistic theme with just a few subtle color highlights.

<img width="775" alt="Screenshot 2025-05-25 at 14 42 31" src="https://github.com/user-attachments/assets/6fa96121-25c4-4630-ba55-3834f8a62543" />

From here, if you wish to open the plugin window you can do so with `:DynamicThemeOpen`, or `<leader>dt` which is preconfigured. This will present you with the color editor for the dull-ish theme.

![Screenshot 2025-05-24 at 20 33 29](https://github.com/user-attachments/assets/3595e19d-48d0-4a48-b15d-73f78ec4084b)

There are 2 other views for this window. The help page, which can be accessed with `?`.

![Screenshot 2025-05-24 at 19 37 13](https://github.com/user-attachments/assets/39c349f3-ad84-46fc-9a24-68b19f8b719a)

And the theme page which can be accessed with `t`.

![Screenshot 2025-05-24 at 19 37 44](https://github.com/user-attachments/assets/a4e18edc-aa9a-4459-b069-f87e52d015cb)

We'll come back to these pages though. 

## Color page

You can navigate back to the color page for the currently selected theme ([dull-ish](https://github.com/alistairjoelquinn/dull-ish.nvim)), with `c`.

![Screenshot 2025-05-24 at 20 33 29](https://github.com/user-attachments/assets/309d28d7-6df1-4150-94cb-45eba35931ad)

From here you can simply update one of the hex codes, and press `s` to save. The background to the hex code gives you immediate feedback as to what the color looks like, to make it easier to find a color which matches well with the rest of the palette. After saving you will see the theme update immediately to reflect the changes. Below we have updated the hex code for `functions and warnings`. You can see that both the hex code and the functions in the background now use the new color.

<img width="881" alt="Screenshot 2025-05-24 at 19 52 42" src="https://github.com/user-attachments/assets/1d89f05a-04d6-41dc-8412-99dd6f5988be" />

In order to simplify the creation and editing of themes, the color highlights have been divided up into the 14 groups you can see in the window.

## Theme page

Now that we have managed to update the current theme, let's try and create a new one. Navigate to the theme page by pressing `t`. In total `dynamic-theme.nvim` allows you to save up to 8 themes.

![Screenshot 2025-05-24 at 19 37 44](https://github.com/user-attachments/assets/990faff6-9e37-4509-b388-f368f2794ef2)

From here you can select any one of the saved themes by choosing its number. Currently all the other themes are empty. The first time you choose an empty theme you will be prompted to choose a name.

![Screenshot 2025-05-24 at 19 38 12](https://github.com/user-attachments/assets/ca14376c-9fb1-4ee5-ad9b-4f9285f6327a)

Let's call ours Muted Neon. Having entered the new name, you will be immediately navigated back to the color page, where the default dark theme has been applied. The window title indicates that Muted Neon is currently selected.

![Screenshot 2025-05-24 at 19 38 30](https://github.com/user-attachments/assets/721f4aa7-0370-4823-bf25-96af7338717e)

Now we can repeat the process from before and update a hex code.

![Screenshot 2025-05-24 at 19 39 23](https://github.com/user-attachments/assets/f83646d3-7522-41dc-9f9f-9ec6c2a2c932)

Again, after pressing `s`, for save, we will see the Neovim theme update immediately.

![Screenshot 2025-05-24 at 19 39 56](https://github.com/user-attachments/assets/75b39de3-4d8c-41f8-ba65-be44a4bfd261)

Let's change a couple more.

![Screenshot 2025-05-24 at 19 41 10](https://github.com/user-attachments/assets/b244ff14-5325-4f34-9827-206908159396)

We can return back to the theme page with `t` in order to change theme again. Here we can press `1` to return back to `dull-ish` or we can pick another number to create another new theme.

![Screenshot 2025-05-24 at 19 41 31](https://github.com/user-attachments/assets/d514c1b3-a4e3-4e9e-bfdb-991c00c0223a)

That's all there is to it.

## Considerations

- The color page is an editable buffer, which makes it very easy to undo changes should you dislike an update you have applied. Simply undo any changes in the text and re-apply with `s`.
  - This also means individual highlight groups can be deleted if desired.
- The plugin uses JSON to persist the hex codes for each theme. One of the advantages of this is that the JSON file persisted in the `nvim` directory can be included in version control, should you wish to share your saved config across devices. The reverse also being true, if you wish to persist you themes only on one machine, the file can be ignored from version control.
- When troubleshooting, bear in mind that as last resort, if problems are arising, you can simply delete the json file from the root of your `nvim` directory and start from scratch the next time you open the plugin (bear in mind that any themes saved will be lost).

