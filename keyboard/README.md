### credits to ThePrimeagen
[ThePrimeagen/keyboards](https://github.com/ThePrimeagen/keyboards/tree/master/ubuntu)

Open file
`sudo nvim /usr/share/X11/xkb/symbols/pl`

below section `xkb_symbols "dvp"` place content of `real-prog-dvorak-pl`

Then you have to update the `sudo vim /usr/share/X11/xkb/rules/evdev.xml` with the following, add it near the other English keyboards

```
<variant>
    <configItem>
        <name>real-prog-dvorak</name>
        <description>Polish (Real Programmers Dvorak)</description>
        <vendor>MichaelPaulson</vendor>
    </configItem>
</variant>
```

To setup the layout run command:
`setxkbmap -layout pl -variant real-prog-dvorak`
